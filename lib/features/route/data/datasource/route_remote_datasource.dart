import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/route_model.dart';

class RouteRemoteDataSource {
  final ApiClient _api = ApiClient.instance;

  /// GET route-list
Future<List<RouteModel>> getRouteList() async {
  final response = await _api.get(ApiConstants.routeList);
  final list = response['route_list'] ?? [];
  return (list as List).map((e) => RouteModel.fromJson(e)).toList();
}
}