import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../data/models/route_model.dart';

class RouteDetailPage extends StatelessWidget {
  final RouteModel route;
  const RouteDetailPage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final hasLocation = route.latitude != null && route.longitude != null;
    final markInLatLng = hasLocation
        ? LatLng(route.latitude!, route.longitude!)
        : const LatLng(19.0013, 73.1369); // fallback

    final markOutLatLng = LatLng(
      (route.latitude ?? 19.0013) + 0.002,
      (route.longitude ?? 73.1369) + 0.002,
    );

    // ] distance 
    final distance = _calculateDistance(markInLatLng, markOutLatLng);

    return Scaffold(
      backgroundColor: AppColors.createAccountBg,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "My Route",),
      body: Stack(
        children: [
          //  Full screen map 
          FlutterMap(
            options: MapOptions(
              initialCenter: markInLatLng,
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.mediezy.zyromate',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [markInLatLng, markOutLatLng],
                    strokeWidth: 3,
                    color: AppColors.primaryTeal,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Mark In marker
                  Marker(
                    point: markInLatLng,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primaryTeal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.login,
                          color: AppColors.white, size: 20),
                    ),
                  ),
                  // Mark Out marker
                  Marker(
                    point: markOutLatLng,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primaryDark,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.logout,
                          color: AppColors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),

   
Positioned(
  bottom: 0, left: 0, right: 0,
  child: Container(
    margin: EdgeInsets.only(bottom: 10,left: 10,right: 10),
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    decoration: const BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.all( Radius.circular(17)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                route.date ?? 'Albert Rayman',
                style: AppTextStyles.label.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Online/Offline',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Image.asset("assets/icons/Battery.png",width: 14,height: 14,),
                 
                  const SizedBox(width: 1),
                  Text('100%', style: AppTextStyles.heading5),
                ],
              ),
            ],
          ),
        ),

        Text(
          '${distance.toStringAsFixed(1)} Km',
          style: AppTextStyles.heading2.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 16),

        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.refresh,
              color: AppColors.white, size: 22),
        ),
      ],
    ),
  ),
),
        ],
      ),
    );
  }

  double _calculateDistance(LatLng from, LatLng to) {
    const distance = Distance();
    return distance.as(LengthUnit.Kilometer, from, to);
  }
}