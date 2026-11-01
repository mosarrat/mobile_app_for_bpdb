import 'dart:async';

// import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';


import '../../constants/constant.dart';
import '../../models/Login/login.dart';
import '../../models/proposed_pole/proposed_pole.dart';


class MapLocationSection extends StatefulWidget {
  final TextEditingController latitude;
  final TextEditingController longitude;
  final TextEditingController area;
  final Widget Function(TextEditingController controller, String label, bool mandetory) buildTextField;
  final void Function(double, double)? onLocationSelected;
  final List<ProposedPole> proposedPole;

  const MapLocationSection({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.area,
    required this.buildTextField,
    this.onLocationSelected,
    required this.proposedPole,
  });

  @override
  State<MapLocationSection> createState() => _MapLocationSectionState();
}

class _MapLocationSectionState extends State<MapLocationSection> {
  double? _latitude;
  double? _longitude;
  User? user = globalUser;
  final MapController _mapController = MapController();
  LatLng _currentPosition = const LatLng(23.8103, 90.4125); 
  bool _isGPSLocationAdded = false;
  bool _locationInitialized = false;
  bool _isTyping = false;



  /* ===================== PERMISSION ===================== */

  /*Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnack(context, "Location services are disabled");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnack(
        context,
        "Location permission permanently denied. Enable it from Settings.",
      );
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
  */
  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnack(context, "Location services are disabled");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnack(
        context,
        "Location permission permanently denied. Enable it from Settings.",
      );
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(msg)),
    );
  }


  /* ===================== LOCATION ===================== */

  Future<void> _getCurrentLocation() async {
    //if (_locationInitialized) return; // only run once

    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _updateLocation(
      LatLng(position.latitude, position.longitude),
      moveMap: true,
    );

    _locationInitialized = true; // mark GPS used
  }


void _updateLocation(LatLng latLng, {bool moveMap = false}) {
  setState(() {
    _currentPosition = latLng;
  });

  // Only update fields if user is NOT typing
  if (!_isTyping) {
    widget.latitude.text = latLng.latitude.toStringAsFixed(6);
    widget.longitude.text = latLng.longitude.toStringAsFixed(6);
  }

  widget.onLocationSelected?.call(latLng.latitude, latLng.longitude);

  if (moveMap) {
    _mapController.move(latLng, 16);
  }
}



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
                color: Colors.black.withOpacity(0.7),
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

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (widget.proposedPole.isNotEmpty) {
  //       final lastPole = widget.proposedPole.last;
  //       if (lastPole.latitude != null && lastPole.longitude != null) {
  //         _updateLocation(
  //           LatLng(lastPole.latitude!, lastPole.longitude!),
  //           moveMap: true,
  //         );
  //         return;
  //       }
  //     }
  //     _getCurrentLocation();
  //   });
  // }


@override
void initState() {
  super.initState();

  widget.latitude.addListener(_onManualLatLngChanged);
  widget.longitude.addListener(_onManualLatLngChanged);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _getCurrentLocation();
  });
}


void _onManualLatLngChanged() {
  _isTyping = true;

  final lat = double.tryParse(widget.latitude.text);
  final lng = double.tryParse(widget.longitude.text);

  if (lat != null && lng != null) {
    setState(() {
      _currentPosition = LatLng(lat, lng);
    });

    widget.onLocationSelected?.call(lat, lng);

    _mapController.move(LatLng(lat, lng), _mapController.camera.zoom);
  }

  _isTyping = false;
}


@override
void dispose() {
  widget.latitude.removeListener(_onManualLatLngChanged);
  widget.longitude.removeListener(_onManualLatLngChanged);
  super.dispose();
}


 /* ===================== UI ===================== */

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Location Information",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Divider(color: Color.fromARGB(255, 5, 161, 182)),
          const SizedBox(height: 12),

          /// MAP
          Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentPosition,
                      initialZoom: 16,
                      onPositionChanged: (position, hasGesture) {
                        if (hasGesture) {
                          _updateLocation(position.center);
                          _locationInitialized = true;
                        }
                      },
                    ),
                    children: [
                      /// SATELLITE TILES
                      TileLayer(
                        urlTemplate:
                            'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                        userAgentPackageName: 'com.example.app',
                      ),

                      /// MARKERS
                      MarkerLayer(
                        markers: [
                          ..._buildPoleMarkers(),

                          Marker(
                            point: _currentPosition,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// REFRESH BUTTON
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        color: const Color.fromARGB(255, 45, 134, 251),
                        iconSize: 28,
                        onPressed: () async {
                          _locationInitialized = true;
                          await _getCurrentLocation();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentPosition,
                  initialZoom: 16,
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture) {
                      _updateLocation(position.center);
                      _locationInitialized = true;
                    }
                  },
                ),
                children: [
                  /// SATELLITE TILES (ESRI)
                  TileLayer(
                    urlTemplate:
                        'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                    userAgentPackageName: 'com.example.app',
                  ),

                  /// MARKERS
                  MarkerLayer(
                    markers: [
                      ..._buildPoleMarkers(),

                      /// CURRENT LOCATION
                      Marker(
                        point: _currentPosition,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                    ],
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 2),
                        ],
                      ),
                      child: IconButton(
                      icon: const Icon(Icons.refresh),
                      color: const Color.fromARGB(255, 45, 134, 251),
                      iconSize: 25,
                      onPressed: () {
                        _getCurrentLocation();
                      },
                    ),
                    ),
                  ),
                ],
              ),
            ),
            */
          ),

          const SizedBox(height: 16),

          widget.buildTextField(widget.latitude, 'Latitude', true),
          const SizedBox(height: 8),
          widget.buildTextField(widget.longitude, 'Longitude', true),
        ],
      ),
    );
  }
}