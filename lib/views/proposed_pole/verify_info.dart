// verify_info.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:bpdb_gis_app/models/proposed_pole/proposed_pole.dart';
import 'package:bpdb_gis_app/models/proposed_pole/proposed_pole_sec.dart';
import '../../api/map_api.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';

class VerificationSection extends StatefulWidget {
  final List<ProposedPole> proposedPole;
  final PoleSection? poleSectionData;

  const VerificationSection({
    super.key,
    required this.proposedPole,
    this.poleSectionData,
  });

  @override
  State<VerificationSection> createState() => _VerificationSectionState();
}

class _VerificationSectionState extends State<VerificationSection> {
  User? user = globalUser;
  final MapController _mapController = MapController();

  LatLng _initialCenter = const LatLng(23.8103, 90.4125); // fallback (Dhaka)

  /* ===================== POLE MARKERS ===================== */

  List<Marker> _buildPoleMarkers() {
    return widget.proposedPole
        .where((p) => p.latitude != null && p.longitude != null)
        .map((pole) {
      return Marker(
        point: LatLng(pole.latitude!, pole.longitude!),
        width: 120,
        height: 80,
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                pole.poleNo ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 32,
            ),
          ],
        ),
      );
    }).toList();
  }

  /* ===================== INIT ===================== */

  @override
  void initState() {
    super.initState();
    if (widget.proposedPole.isNotEmpty) {
      final firstPole = widget.proposedPole.first;
      if (firstPole.latitude != null && firstPole.longitude != null) {
        _initialCenter = LatLng(
          firstPole.latitude!,
          firstPole.longitude!,
        );
      }
    }
  }

  /* ===================== UI ===================== */

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Confirm and Submit Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Divider(color: Color.fromARGB(255, 5, 161, 182)),
            const SizedBox(height: 16),

            /// ADMIN INFO
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                title: const Text(
                  "Administrative Information",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  [
                    user?.ZoneName,
                    user?.CircleName,
                    user?.SnDName,
                    user?.EsuName,
                  ].where((e) => e != null && e.isNotEmpty).join(' | '),
                  style: const TextStyle(height: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// MAP (READ-ONLY)
            Container(
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _initialCenter,
                    initialZoom: 16,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                    ),
                  ),
                  children: [
                    /// SATELLITE IMAGERY (ESRI)
                    TileLayer(
                      urlTemplate:
                          'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                      userAgentPackageName: 'com.example.app',
                    ),

                    /// PREVIOUS POLE MARKERS ONLY
                    MarkerLayer(
                      markers: _buildPoleMarkers(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}