import '../entities/attendance_entity.dart';
import '../repositories/dashboard_repository.dart';

/// Use case: GET /attendance/status
class GetAttendanceStatusUseCase {
  final DashboardRepository _repository;
  GetAttendanceStatusUseCase(this._repository);

  Future<AttendanceEntity> call() => _repository.getAttendanceStatus();
}