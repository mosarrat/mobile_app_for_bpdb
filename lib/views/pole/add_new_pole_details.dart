import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../api/pole_api.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';
import '../../models/pole_lookup/pole_condition.dart';
import '../../models/pole_lookup/pole_data.dart';
import '../../models/pole_lookup/pole_type.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';

class AddNewPoleData extends StatefulWidget {
  final Function(PoleFormData) onChanged;
  const AddNewPoleData({super.key, required this.onChanged});

  @override
  State<AddNewPoleData> createState() => _AddNewPoleDataState();
}

class _AddNewPoleDataState extends State<AddNewPoleData> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _poleId = TextEditingController();
  final TextEditingController _noOfWireHt = TextEditingController();
  final TextEditingController _remarks = TextEditingController();
  final TextEditingController _noOfWireLt = TextEditingController();
  final TextEditingController _msjNo = TextEditingController();
  final TextEditingController _sleeveNo = TextEditingController();
  final TextEditingController _twistNo = TextEditingController();
  final TextEditingController _poleNumber = TextEditingController();
  final TextEditingController _poleHeight = TextEditingController();
  final TextEditingController _noOfLine33Kv = TextEditingController();
  final TextEditingController _noOfLine11Kv = TextEditingController();
  final TextEditingController _noOfLineP4Kv = TextEditingController();
  final TextEditingController _surveyDateController = TextEditingController();
  late TextEditingController _surveyorNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final MapController _mapController = MapController();

  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<EsuInfo>> esu;
  late Future<List<PoleType>> fetchPoleType;
  late Future<List<PoleCondition>> fetchPoleCondition;

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedEsuId;
  int? selectedPoleTypeId;
  int? selectedPoleConditionId;

  var dt = DateTime.now();
  bool isLoading = false;
  User? user = globalUser;
  double? _latitude;
  double? _longitude;
  LatLng _currentPosition = const LatLng(23.8103, 90.4125); 
  bool _isGPSLocationAdded = false;
  bool _streetLight = false;
  bool _transformerExist = false;
  bool _commonPole = false;
  bool _tap = false;

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(msg)),
    );
  }

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
      _latitudeController.text = latLng.latitude.toStringAsFixed(6);
      _longitudeController.text = latLng.longitude.toStringAsFixed(6);
    });

    if (moveMap) {
      _mapController.move(latLng, 16);
    }
  }

  void _notifyParent() {
    widget.onChanged(
      PoleFormData(
        poleId: int.tryParse(_poleId.text),
        zoneId: selectedZoneId,
        circleId: selectedCircleId,
        sndId: selectedSnDId,
        esuId: selectedEsuId,
        poleTypeId: selectedPoleTypeId,
        poleConditionId: selectedPoleConditionId,
        noOfWireHt: int.tryParse(_noOfWireHt.text),
        noOfWireLt: int.tryParse(_noOfWireLt.text),
        msjNo: _msjNo.text,
        sleeveNo: _sleeveNo.text,
        twistNo: _twistNo.text,
        streetLight: _streetLight,
        transformerExist: _transformerExist,
        commonPole: _commonPole,
        tap: _tap,
        poleNumber: _poleNumber.text,
        poleHeight: double.tryParse(_poleHeight.text),
        noOfLine11Kv: _noOfLine11Kv.text.isNotEmpty
            ? int.tryParse(_noOfLine11Kv.text)
            : null,
        noOfLine33Kv: _noOfLine33Kv.text.isNotEmpty
            ? int.tryParse(_noOfLine33Kv.text)
            : null,
        noOfLineP4Kv: _noOfLineP4Kv.text.isNotEmpty
            ? int.tryParse(_noOfLineP4Kv.text)
            : null,
        latitude: double.tryParse(_latitudeController.text),
        longitude: double.tryParse(_longitudeController.text),
        surveyDate: _surveyDateController.text,
        surveyorName: _surveyorNameController.text,
        startingDate: _startDateController.text,
        remarks: _remarks.text,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
    zones = CallApi().fetchZoneInfo();
    circles = Future.value([]);
    snds = Future.value([]);
    esu = Future.value([]);

    fetchPoleType = CallPoleApi().fetchPoleType();
    fetchPoleCondition = CallPoleApi().fetchPoleCondition();
    _surveyorNameController = TextEditingController(text: user?.UserName ?? '');
    _surveyDateController.text = DateFormat('yyyy-MM-dd').format(dt);
    _startDateController.text = DateFormat('yyyy-MM-dd').format(dt);
  
    _poleId.addListener(_notifyParent);
    _noOfWireHt.addListener(_notifyParent);
    _remarks.addListener(_notifyParent);
    _latitudeController.addListener(_notifyParent);
    _longitudeController.addListener(_notifyParent);
    _surveyorNameController.addListener(_notifyParent);  
    _surveyDateController.addListener(_notifyParent);
    _surveyDateController.addListener(_notifyParent);
    _startDateController.addListener(_notifyParent);
    _loadPoleId(); 
  }

  Future<void> _loadPoleId() async {
    try {
      setLoading(true);

      final int maxId = await CallPoleApi().fetchMaxPoleId();
      _poleId.text = maxId.toString();
      _notifyParent();
    } catch (e) {
      debugPrint('Error loading pole id: $e');
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void onZoneChanged(int? value) {
    setLoading(true);
    selectedZoneId = value;
    selectedCircleId = null;
    selectedSnDId = null;
    selectedEsuId = null;
    circles = CallApi().fetchCircleInfo(value!).whenComplete(() {
      setLoading(false);
    });
    snds = Future.value([]);
  }

  void onCircleChanged(int? value) {
    setLoading(true);
    selectedCircleId = value;
    selectedSnDId = null;
    selectedEsuId = null;
    snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  void onSnDChanged(int? value) {
    setLoading(true);
    selectedSnDId = value;
    selectedEsuId = null;
    esu = CallConsumerApi().fetchEsuInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  void onEsuChanged(int? value) {
    setLoading(true);
    selectedEsuId = value;
  }

  void itemSwitchStreetLight(bool value) {
    setState(() {
      _streetLight = value;
    });
    _notifyParent();
  }

  void itemSwitchTransformerExist(bool value) {
    setState(() {
      _transformerExist = value;
    });
    _notifyParent();
  }

  void itemSwitchCommonPole(bool value) {
    setState(() {
      _commonPole = value;
    });
    _notifyParent();
  }

  void itemSwitchTap(bool value) {
    setState(() {
      _tap = value;
    });
    _notifyParent();
  }

  
  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (user?.ZoneId != null) {
      selectedZoneId = user!.ZoneId;
      circles = CallApi().fetchCircleInfo(selectedZoneId!).whenComplete(() {
        setLoading(false);
      });
    }
    if (user?.CircleId != null) {
      selectedCircleId = user!.CircleId;
      snds = CallApi().fetchSnDInfo(selectedCircleId!).whenComplete(() {
        setLoading(false);
      });
    }
    if (user?.SndId != null) {
      selectedSnDId = user!.SndId;
      esu = CallConsumerApi().fetchEsuInfo(selectedSnDId!).whenComplete(() {
        setLoading(false);
      });
    }
    if (user?.EsuId != null) {
      selectedEsuId = user!.EsuId;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ///////////---- Administrative Location ----///////////
            Theme(
              data: ThemeData().copyWith(
                dividerColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: ExpansionTile(
                ////minTileHeight: 25,
                collapsedBackgroundColor:
                    const Color.fromARGB(255, 223, 240, 243),
                title: const Text('Administrative Location'),
                childrenPadding: const EdgeInsets.all(5),
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Administrative Location',
                    children: [
                      FutureBuilder<List<Zone>>(
                        future: zones,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: 'Zone',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: deviceFontSize + 3,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              value: selectedZoneId,
                              hint: const Text('Select a Zone'),
                              items: snapshot.data!.map((zone) {
                                return DropdownMenuItem<int>(
                                  value: zone.zoneId,
                                  child: Text(zone.zoneName),
                                );
                              }).toList(),
                              onChanged: user?.ZoneId == null
                                  ? (value) {
                                      selectedZoneId = value;
                                      _notifyParent();
                                      onZoneChanged(value);
                                    }
                                  : null,
                                  
                            );
                          } else {
                            return const Text('No zones available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<Circles>>(
                        future: circles,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            showMessage('Error: ${snapshot.error}', 'error');
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: 'Circle',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: deviceFontSize + 3,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              value: null,
                              hint: const Text('No circles available!'),
                              items: [],
                              onChanged: null,
                            );
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: 'Circle',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: deviceFontSize + 3,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              value: selectedCircleId,
                              hint: const Text('Select a Circle'),
                              items: snapshot.data!.map((circle) {
                                return DropdownMenuItem<int>(
                                  value: circle.circleId,
                                  child: Text(circle.circleName!),
                                );
                              }).toList(),
                              onChanged: user?.CircleId == null
                                  ? (value) {
                                      selectedCircleId = value;
                                      _notifyParent();
                                      onCircleChanged(value);
                                    }
                                  : null,
                            );
                          } else {
                            return const Text('No circles available!');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<SndInfo>>(
                        future: snds,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            showMessage('Error: ${snapshot.error}', 'error');
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: 'SnD',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: deviceFontSize + 3,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              value: null,
                              hint: const Text('No SnDs available!'),
                              items: [],
                              onChanged: null,
                            );
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  label: RichText(
                                    text: TextSpan(
                                      text: 'SnD',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: deviceFontSize + 3,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                value: selectedSnDId,
                                hint: const Text('Select a SnD'),
                                items: snapshot.data!.map((snd) {
                                  return DropdownMenuItem<int>(
                                    value: snd.sndId,
                                    child: Text(snd.snDName!),
                                  );
                                }).toList(),
                                onChanged: user?.SndId == null
                                    ? (value) {
                                        selectedSnDId = value;
                                        _notifyParent();
                                        onSnDChanged(value);
                                      }
                                    : null);
                          } else {
                            return const Text('No SnDs available!');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ////// ESU Info //////
                      FutureBuilder<List<EsuInfo>>(
                        future: esu,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            showMessage('Error: ${snapshot.error}', 'error');

                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Esu',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                ),
                              ),
                              value: null,
                              hint: const Text('No Esus available!'),
                              items: [],
                              onChanged: null,
                            );
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Esu',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: selectedEsuId,
                                hint: const Text('Select a Esu'),
                                items: snapshot.data!.map((esu) {
                                  return DropdownMenuItem<int>(
                                    value: esu.esuId,
                                    child: Text(esu.esuName),
                                  );
                                }).toList(),
                                onChanged: user?.EsuId == null
                                    ? (value) {
                                        selectedEsuId = value;
                                        _notifyParent();
                                        onEsuChanged(value);
                                      }
                                    : null);
                          } else {
                            return const Text('No Esus available!');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ///////////---- Administrative Location ----///////////
            ///////////---- Pole Information ----///////////
            Theme(
              data: ThemeData().copyWith(
                dividerColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: ExpansionTile(
                ////minTileHeight: 25,
                collapsedBackgroundColor:
                    const Color.fromARGB(255, 241, 245, 245),
                title: const Text('Pole Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Pole Information',
                    children: [
                      _buildTextField(_poleNumber, 'Pole Number', false),
                      FutureBuilder<List<PoleType>>(
                        future: fetchPoleType,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              value: selectedPoleTypeId,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Pole Type',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 100, 97, 97),
                                    fontSize: 16.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              items: snapshot.data!.map((poleType) {
                                return DropdownMenuItem<int>(
                                  value: poleType.poleTypeId,
                                  child: Text(
                                      '${poleType.poleTypeName}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _notifyParent();
                                  selectedPoleTypeId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Pole Type available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<PoleCondition>>(
                        future: fetchPoleCondition,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceFontSize + 3,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              value: selectedPoleConditionId,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Pole Condition',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 100, 97, 97),
                                    fontSize: 16.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              items: snapshot.data!.map((poleCondition) {
                                return DropdownMenuItem<int>(
                                  value: poleCondition.poleConditionId,
                                  child: Text(
                                      '${poleCondition.conditionName}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _notifyParent();
                                  selectedPoleConditionId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Pole Condition available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                          _noOfWireHt, 'Number of Wire HT', false),
                      _buildTextField(
                          _noOfWireLt, 'Number of Wire LT', false),
                      //_buildTextField(_msjNo, 'MSJ No.', false),
                      
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
                                    text: 'Street Light',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 100, 97, 97),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _streetLight,
                                  onChanged: itemSwitchStreetLight,
                                  
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                                    text: 'Transformer Exist',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 100, 97, 97),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _transformerExist,
                                  onChanged: itemSwitchTransformerExist,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                                    text: 'Common Pole',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 100, 97, 97),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _commonPole,
                                  onChanged: itemSwitchCommonPole,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                                    text: 'Tap',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 100, 97, 97),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _tap,
                                  onChanged: itemSwitchTap,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Radio Button
                      
                      _buildTextField(_poleHeight, 'Pole Height', false),
                      _buildTextField(
                          _noOfLine11Kv, 'Number of Line 11Kv', false),
                      _buildTextField(
                          _noOfLine33Kv, 'Number of Line 33Kv', false),
                      _buildTextField(
                          _noOfLineP4Kv, 'Number of Line 0.4Kv', false),
                      // _buildTextField(_sleeveNo, 'Sleeve No.', false),
                      //_buildTextField(_twistNo, 'Twist No.', false),
                    ],
                  ),
                ],
              ),
            ),
            ///////////---- Pole Information ----///////////
            
            ///////////---- GPS Information ----///////////
            Theme(
              data: ThemeData().copyWith(
                dividerColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: ExpansionTile(
                ////minTileHeight: 25,
                collapsedBackgroundColor:
                    const Color.fromARGB(255, 223, 240, 243),
                title: const Text('GPS Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'GPS Information',
                    children: [
                      _buildTextField(_latitudeController, 'Latitude', true),
                      _buildTextField(
                          _longitudeController, 'Longitude', true),
                      // const SizedBox(height: 16.0),
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
                    ],
                  ),
                ],
              ),
            ),
            ///////////---- GPS Information ----///////////
            ///////////---- Survey Information ----///////////
            Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 241, 245, 245),
                  title: const Text('Survey Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Survey Information',
                      children: [
                        _buildTextField(
                            _surveyorNameController, 'Surveyor Name', false),
                        TextFormField(
                          controller: _surveyDateController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            label: RichText(
                              text: const TextSpan(
                                text: "Survey Date",
                                style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 105, 103, 103), // Label text color
                                  fontSize: 16.0, // Label font size
                                ),
                                children: [
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                      color: Colors
                                          .red, // Red color for the asterisk
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectSurvryDate(context);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Survey Date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _startDateController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            label: RichText(
                              text: const TextSpan(
                                text: "Starting Date",
                                style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 105, 103, 103), // Label text color
                                  fontSize: 16.0, // Label font size
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectStartingDate(context);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Start Date';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ///////////---- Survey Information ----///////////
            ///////////---- Remarks ----///////////
            Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 223, 240, 243),
                  title: const Text('Remarks'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Remarks',
                      children: [
                        _buildTextField(_remarks, 'Remarks', false),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ],
                ),
              ),
            ///////////---- Remarks ----///////////
            
          ],
        ),
      ),
    );
  }

Widget _buildTextField(
      TextEditingController controller, String label, bool mandatory) {
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
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  void _errorPrint(String label, BuildContext context) {
    final snackBar = SnackBar(content: Text('Please enter $label'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _selectSurvryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _surveyDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectStartingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
