class RouteModel {
  final String? id;
  final String? date;
  final String? markInTime;
  final String? markOutTime;
  final double? latitude;
  final double? longitude;
  final double? markOutLatitude;
  final double? markOutLongitude;

  RouteModel({
    this.id,
    this.date,
    this.markInTime,
    this.markOutTime,
    this.latitude,
    this.longitude,
    this.markOutLatitude,
    this.markOutLongitude,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final inLocation  = json['mark_in_location']  as Map<String, dynamic>?;
    final outLocation = json['mark_out_location'] as Map<String, dynamic>?;

    return RouteModel(
      id:               json['id']?.toString(),
      date:             json['date'],
      markInTime:       json['mark_in'],
      markOutTime:      json['mark_out'],
      latitude:         double.tryParse(inLocation?['latitude']?.toString()  ?? ''),
      longitude:        double.tryParse(inLocation?['longitude']?.toString() ?? ''),
      markOutLatitude:  double.tryParse(outLocation?['latitude']?.toString()  ?? ''),
      markOutLongitude: double.tryParse(outLocation?['longitude']?.toString() ?? ''),
    );
  }
}