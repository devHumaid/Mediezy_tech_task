import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/leave_model.dart';

class LeaveRemoteDataSource {
  final ApiClient _api = ApiClient.instance;

  /// POST /apply-leave
  Future<Map<String, dynamic>> applyLeave({
    required String leaveMode,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
    required String userId,
  }) async {
    return await _api.post(
      ApiConstants.applyLeave,
      data: {
        'leave_mode': leaveMode,
        'leave_type': leaveType,
        'start_date': startDate,
        'end_date':   endDate,
        'reason':     reason,
        'user_id':    userId,
      },
    );
  }

  /// POST /leaves
Future<List<LeaveModel>> getLeaves({
  required String employeeId,
  required String leaveType,
  required String month,
}) async {
  final response = await _api.post(
    ApiConstants.leaves,
    data: {
      'employee_id': employeeId,
      'leave_type':  leaveType,
      'month':       month,
    },
  );
  // API returns 'sales_executive_leaves' not 'leaves' or 'data'
  final list = response['sales_executive_leaves'] ?? [];
  return (list as List).map((e) => LeaveModel.fromJson(e)).toList();
}
}