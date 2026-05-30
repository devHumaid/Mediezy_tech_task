import 'package:flutter/material.dart';
import '../../data/datasource/route_remote_datasource.dart';
import '../../data/models/route_model.dart';

enum RouteStatus { initial, loading, loaded, error }

class RouteProvider extends ChangeNotifier {
  final RouteRemoteDataSource _dataSource = RouteRemoteDataSource();

  RouteStatus      _status      = RouteStatus.initial;
  List<RouteModel> _routes      = [];
  List<RouteModel> _filtered    = [];
  String?          _errorMessage;
  String           _searchQuery = '';

  RouteStatus      get status       => _status;
  List<RouteModel> get routes       => _filtered;
  String?          get errorMessage => _errorMessage;
  bool             get isLoading    => _status == RouteStatus.loading;

  Future<void> fetchRouteList() async {
    _status = RouteStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _routes   = await _dataSource.getRouteList();
      _filtered = _routes;
      _status   = RouteStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = RouteStatus.error;
    }
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filtered = _routes;
    } else {
      _filtered = _routes.where((r) =>
        (r.date ?? '').toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }
}