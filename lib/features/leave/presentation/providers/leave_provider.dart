import 'package:flutter/material.dart';
import '../../data/datasource/leave_remote_datasource.dart';
import '../../data/models/leave_model.dart';
import '../../../../shared/services/local_storage_service.dart';

enum LeaveStatus { initial, loading, loaded, error }

class LeaveProvider extends ChangeNotifier {
  final LeaveRemoteDataSource _dataSource = LeaveRemoteDataSource();

  LeaveStatus    _status         = LeaveStatus.initial;
  List<LeaveModel> _leaves       = [];
  String?        _errorMessage;
  String?        _successMessage;
  String         _selectedFilter = 'all'; 
  String         _selectedMonth  = DateTime.now().month.toString();

  LeaveStatus      get status         => _status;
  List<LeaveModel> get leaves         => _leaves;
  String?          get errorMessage   => _errorMessage;
  String?          get successMessage => _successMessage;
  String           get selectedFilter => _selectedFilter;
  String           get selectedMonth  => _selectedMonth;
  bool             get isLoading      => _status == LeaveStatus.loading;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
    fetchLeaves();
  }

  void setMonth(String month) {
    _selectedMonth = month;
    notifyListeners();
    fetchLeaves();
  }

  Future<void> fetchLeaves() async {
    _status = LeaveStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final userId = await LocalStorageService.instance.getUserId() ?? '';
      _leaves = await _dataSource.getLeaves(
        employeeId: userId,
        leaveType:  _selectedFilter,
        month:      _selectedMonth,
      );
      _status = LeaveStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = LeaveStatus.error;
    }
    notifyListeners();
  }

  Future<bool> applyLeave({
    required String leaveMode,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    _status = LeaveStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final userId = await LocalStorageService.instance.getUserId() ?? '';
      await _dataSource.applyLeave(
        leaveMode: leaveMode, leaveType: leaveType,
        startDate: startDate, endDate: endDate,
        reason: reason,       userId: userId,
      );
      _successMessage = 'Leave applied successfully!';
      _status = LeaveStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = LeaveStatus.error;
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _errorMessage   = null;
    _successMessage = null;
    notifyListeners();
  }
}