import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasource/attendance_model.dart';
import '../../data/datasource/dashboard_remote_datasource.dart';

/// Possible states for the dashboard attendance banner
enum BannerState {
  notStarted, // State 1 → "Start Your Day!" + Mark In button
  working,    // State 2 → "Your work started" + Mark Out button
  completed,  // State 3 → "Your Day Completed" – no button
}

/// Loading states for the provider
enum DashboardStatus { initial, loadingStatus, marking, loaded, error }

class DashboardProvider extends ChangeNotifier {
  final DashboardRemoteDataSource _dataSource = DashboardRemoteDataSource();

  DashboardStatus  _status         = DashboardStatus.initial;
  AttendanceModel? _attendance;
  String?          _errorMessage;
  String?          _successMessage;
  Position?        _currentPosition;

  // ── Getters ───────────────────────────────────────────────────────────
  DashboardStatus  get status          => _status;
  AttendanceModel? get attendance      => _attendance;
  String?          get errorMessage    => _errorMessage;
  String?          get successMessage  => _successMessage;
  Position?        get currentPosition => _currentPosition;

  /// True while fetching status or marking attendance
  bool get isLoading =>
      _status == DashboardStatus.loadingStatus ||
      _status == DashboardStatus.marking;

  /// Resolves which of the 3 banner states to display
BannerState get bannerState {
  if (attendance == null || attendance!.isNotStarted) return BannerState.notStarted;
  if (attendance!.isDayCompleted) return BannerState.completed;
  if (attendance!.isMarkedIn) return BannerState.working;
  return BannerState.notStarted;
}

  // ── Fetch current attendance status ───────────────────────────────────
  /// Called on dashboard init to know the current state
  Future<void> fetchAttendanceStatus() async {
    _status = DashboardStatus.loadingStatus;
    _errorMessage = null;
    notifyListeners();

    try {
      _attendance = await _dataSource.getAttendanceStatus();
      _status = DashboardStatus.loaded;
    } catch (e) {
      // Silently fail – dashboard still loads, banner shows State 1
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = DashboardStatus.loaded; // don't block the UI
    }
    notifyListeners();
  }

  // ── Mark In / Mark Out ────────────────────────────────────────────────
  /// [markIn] true → POST mark_in, false → POST mark_out
  Future<void> markAttendance({required bool markIn}) async {
    _status = DashboardStatus.marking;
    _errorMessage   = null;
    _successMessage = null;
    notifyListeners();

    try {
      // 1. Get GPS location
      final position = await _getGPSLocation();
      _currentPosition = position;

      // 2. Call POST /attendance/mark
      final attendanceStatus =
          markIn ? AppConstants.attendanceIn : AppConstants.attendanceOut;

      await _dataSource.markAttendance(
        attendanceStatus: attendanceStatus,
        latitude:         position.latitude,
        longitude:        position.longitude,
      );

      _successMessage = markIn ? 'Marked In successfully!' : 'Marked Out successfully!';

      // 3. Refresh status to get updated check-in/out times
      await fetchAttendanceStatus();

    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _status = DashboardStatus.loaded;
      notifyListeners();
    }
  }

  // ── GPS Helper ────────────────────────────────────────────────────────
  Future<Position> _getGPSLocation() async {
    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled. Please enable GPS.');

    // Check and request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied. Please enable in settings.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ── Clear feedback messages ───────────────────────────────────────────
  void clearMessages() {
    _errorMessage   = null;
    _successMessage = null;
    notifyListeners();
  }
}