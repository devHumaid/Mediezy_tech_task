class RouteModel {
  final String? id;
  final String? date;
  final String? markInTime;
  final String? markOutTime;
  final double? latitude;
  final double? longitude;

  RouteModel({
    this.id, this.date, this.markInTime,
    this.markOutTime, this.latitude, this.longitude,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    // location is nested: mark_in_location: { latitude, longitude }
    final inLocation  = json['mark_in_location']  as Map<String, dynamic>?;
    final outLocation = json['mark_out_location'] as Map<String, dynamic>?;

    return RouteModel(
      id:          json['id']?.toString(),
      date:        json['date'],
      markInTime:  json['mark_in'],   // ← API uses 'mark_in' not 'mark_in_time'
      markOutTime: json['mark_out'],  // ← API uses 'mark_out' not 'mark_out_time'
      latitude:    double.tryParse(inLocation?['latitude']?.toString() ?? ''),
      longitude:   double.tryParse(inLocation?['longitude']?.toString() ?? ''),
    );
  }
}