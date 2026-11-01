import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../api/field_monitoring_api.dart';
import '../../models/field_monitoring/field_monitoring.dart';
import 'view_data.dart';

class FieldMonitoring extends StatefulWidget {
  const FieldMonitoring({super.key});

  @override
  State<FieldMonitoring> createState() => _FieldMonitoringState();
}

class _FieldMonitoringState extends State<FieldMonitoring> {

  final MapController _mapController = MapController();
  final TextEditingController application_traking_num = TextEditingController();
  final TextEditingController applicant_name = TextEditingController();
  final TextEditingController applicant_nid= TextEditingController();
  final TextEditingController aapplicant_mobile = TextEditingController();
  final TextEditingController m_latitude = TextEditingController();
  final TextEditingController m_longitude = TextEditingController();
  final TextEditingController dist_from_pole = TextEditingController();
  final TextEditingController arrear_status = TextEditingController();
  final TextEditingController est_load = TextEditingController();
  final TextEditingController submit_date = TextEditingController();
  LatLng _currentPosition = const LatLng(23.8103, 90.4125); 
  bool _isGPSLocationAdded = false;
  bool isLandDocumented = false;
  bool isPrevConnection = false;
  var dt = DateTime.now(); 

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

  
  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _updateLocation(
      LatLng(position.latitude, position.longitude),
      moveMap: true,
    );
  }

  void _updateLocation(LatLng latLng, {bool moveMap = false}) {
    setState(() {
      _currentPosition = latLng;
      m_latitude.text = latLng.latitude.toStringAsFixed(6);
      m_longitude.text = latLng.longitude.toStringAsFixed(6);
    });

    if (moveMap) {
      _mapController.move(latLng, 16);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
    submit_date.text = DateFormat('yyyy-MM-dd').format(dt);

  }

  void itemIsLandDocumented(bool value) {
    setState(() {
      isLandDocumented = value;
    });
  }

  void itemIsPrevConnection(bool value) {
    setState(() {
      isPrevConnection = value;
    });
  }

  final Map<String, String> arrearOptions = {
    'Cleared': 'Cleared',
    'Not Cleared': 'Not Cleared',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'Field Monitoring',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 5, 161, 182),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(application_traking_num, 'Application Tracking Number', false),
              _buildTextField(applicant_name, 'Applicant Name', false),
              _buildTextField(applicant_nid, 'Applicant NID', false),
              _buildTextField(aapplicant_mobile, 'Applicant Mobile', false),

              //Radio Button
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: 'Land Document',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 100, 97, 97),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Switch(
                          value: isLandDocumented,
                          onChanged: itemIsLandDocumented,
                          
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _currentPosition,
                            initialZoom: 16,
                            onPositionChanged: (position, hasGesture) {
                              if (hasGesture && position.center != null) {
                                _updateLocation(position.center!);
                              }
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                              userAgentPackageName: 'com.example.app',
                            ),

                            /// DRAGGABLE MARKER
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _currentPosition,
                                  width: 50,
                                  height: 50,
                                  child: GestureDetector(
                                    onPanUpdate: (details) {
                                      final latLng =
                                          _mapController.camera.center;
                                      _updateLocation(latLng);
                                    },
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                      if (!_isGPSLocationAdded)
                        Positioned.fill(
                          child: IgnorePointer(
                            ignoring:
                                true, // let taps pass through to the map
                            child: Center(
                              child: Icon(
                                Icons.add_location_alt_rounded,
                                color: Colors.red,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildTextField(m_latitude, 'Latitude', false),
              _buildTextField(m_longitude, 'Longitude', false),
              //Radio Button
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: 'Previous Connection',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 100, 97, 97),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Switch(
                          value: isPrevConnection,
                          onChanged: itemIsPrevConnection,
                          
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // === Arrear Status Dropdown === //
                DropdownButtonFormField<String>(
                value: arrear_status.text.isNotEmpty ? arrear_status.text : null,
                hint: const Text('Select Arrear Status'),
                items: arrearOptions.entries
                    .map((entry) => DropdownMenuItem(
                          value: entry.key, // this is the value
                          child: Text(entry.value), // this is the displayed text
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                      arrear_status.text = value!;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              // === Arrear Status Dropdown === //
              _buildTextField(dist_from_pole, 'Distance from Pole', false),
              _buildTextField(est_load, 'Estimated Load', false),

              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          FieldMonitoringData monitoringData = FieldMonitoringData(
                            applicationTrackingNumber: application_traking_num.text,
                            applicantName: applicant_name.text,
                            applicantNid: applicant_nid.text,
                            applicantMobile: aapplicant_mobile.text,
                            meterLatitude: double.tryParse(m_latitude.text),
                            meterLongitude: double.tryParse(m_longitude.text),
                            distanceFromNearestPole: double.tryParse(dist_from_pole.text),
                            arrearStatus: arrear_status.text,
                            estimatedLoad: double.tryParse(est_load.text),
                            isLandDocumentOk: isLandDocumented,
                            hasPreviousConnection: isPrevConnection,
                            submitDate: DateTime.tryParse(submit_date.text),
                          );

                          await CallFieldMonitoringApi().createFieldMonitoringData(monitoringData);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewFieldMonitoringData()),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Consumer Created Successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (error) {
                          //print(error);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Failed to Create data: $error'),
                                backgroundColor: Colors.red),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      child: const Text('Save',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTextField(
      TextEditingController? controller, String label, bool mandatory) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                color: Color.fromARGB(255, 100, 97, 97),
                fontSize: 16.0,
              ),
              children: [
                if (mandatory)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        validator: (value) {
          if (mandatory && (value == null || value.isEmpty)) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}