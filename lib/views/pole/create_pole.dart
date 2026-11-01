import 'dart:async';

import 'package:bpdb_gis_app/views/pole/filter_pole_detail.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../api/pole_api.dart';
import '../../api/region_api.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';
import '../../models/pole_lookup/pole.dart';
import '../../models/pole_lookup/pole_condition.dart';
import '../../models/pole_lookup/pole_type.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';
import '../map/layer_loading_service.dart';
import 'filter_pole_by_snd.dart';

class AddPoleInfo extends StatefulWidget {
  const AddPoleInfo({super.key});

  @override
  State<AddPoleInfo> createState() => _AddPoleInfoState();
}

class _AddPoleInfoState extends State<AddPoleInfo> {
  double? _latitude;
  double? _longitude;
  final MapController _mapController = MapController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  LatLng _currentPosition = const LatLng(23.8103, 90.4125); 
  bool _isGPSLocationAdded = false;
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
      _latitudeController.text = latLng.latitude.toStringAsFixed(6);
      _longitudeController.text = latLng.longitude.toStringAsFixed(6);
    });

    if (moveMap) {
      _mapController.move(latLng, 16);
    }
  }

  final _formKey = GlobalKey<FormState>();

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

  var dt = DateTime.now(); // Date-Time
  bool isLoading = false;
  User? user = globalUser;

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
    _surveyDateController.text = DateFormat('yyyy-MM-dd').format(dt);
    _startDateController.text = DateFormat('yyyy-MM-dd').format(dt);
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

  bool _streetLight = false;
  bool _transformerExist = false;
  bool _commonPole = false;
  bool _tap = false;
  void itemSwitchStreetLight(bool value) {
    setState(() {
      _streetLight = !_streetLight;
    });
  }

  void itemSwitchTransformerExist(bool value) {
    setState(() {
      _transformerExist = !_transformerExist;
    });
  }

  void itemSwitchCommonPole(bool value) {
    setState(() {
      _commonPole = !_commonPole;
    });
  }

  void itemSwitchTap(bool value) {
    setState(() {
      _tap = !_tap;
    });
  }

  final TextEditingController _poleId = TextEditingController();
  final TextEditingController _noOfWireHt = TextEditingController();
  final TextEditingController _noOfWireLt = TextEditingController();
  final TextEditingController _msjNo = TextEditingController();
  final TextEditingController _sleeveNo = TextEditingController();
  final TextEditingController _twistNo = TextEditingController();
  final TextEditingController _poleNumber = TextEditingController();
  final TextEditingController _poleHeight = TextEditingController();
  final TextEditingController _noOfLine33Kv = TextEditingController();
  final TextEditingController _noOfLine11Kv = TextEditingController();
  final TextEditingController _noOfLineP4Kv = TextEditingController();

  // final TextEditingController _latitudeController = TextEditingController();
  // final TextEditingController _longitudeController = TextEditingController();

  final TextEditingController _remarks = TextEditingController();

  final TextEditingController _surveyDateController = TextEditingController();
  final TextEditingController _surveyorNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'New Pole Info',
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
        padding: const EdgeInsets.only(top: 3),
        child: Form(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
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
                                // onChanged: (value) {
                                //   selectedZoneId = value;
                                //   onZoneChanged(value);
                                // },
                                onChanged: user?.ZoneId == null
                                    ? (value) {
                                        selectedZoneId = value;
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
                                // onChanged: (value) {
                                //   setState(() {
                                //     selectedCircleId = value;
                                //     onCircleChanged(value);
                                //   });
                                // },
                                onChanged: user?.CircleId == null
                                    ? (value) {
                                        selectedCircleId = value;
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
                                  // onChanged: (value) {
                                  //   setState(() {
                                  //     selectedSnDId = value;
                                  //     onSnDChanged(value);
                                  //   });
                                  // },
                                  onChanged: user?.SndId == null
                                      ? (value) {
                                          selectedSnDId = value;
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
                                  // onChanged: (value) {
                                  //   setState(() {
                                  //     selectedEsuId = value;
                                  //   });
                                  // },
                                  onChanged: user?.EsuId == null
                                      ? (value) {
                                          selectedEsuId = value;
                                          onEsuChanged(value);
                                        }
                                      : null);
                            } else {
                              return const Text('No Esus available!');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        ///// Esu Info //////

                        const SizedBox(height: 17.5),
                      ],
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////

              ///////////////////////////////////////////////////////////////////////////////
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
                        // _buildTextField(_poleId, 'Pole Id', true),
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
                                        '${poleType.poleTypeId}: ${poleType.poleTypeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
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
                                        '${poleCondition.poleConditionId}: ${poleCondition.conditionName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
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
                        _buildTextField(_msjNo, 'MSJ No.', false),
                        _buildTextField(_sleeveNo, 'Sleeve No.', false),
                        _buildTextField(_twistNo, 'Twist No.', false),
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
                                      // children: [
                                      //   TextSpan(
                                      //     text: ' *',
                                      //     style: TextStyle(
                                      //       color: Colors.red,
                                      //     ),
                                      //   ),
                                      // ],
                                    ),
                                  ),
                                  Switch(
                                    //activeColor: Colors.blue,
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
                                      // children: [
                                      //   TextSpan(
                                      //     text: ' *',
                                      //     style: TextStyle(
                                      //       color: Colors.red,
                                      //     ),
                                      //   ),
                                      // ],
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
                                      // children: [
                                      //   TextSpan(
                                      //     text: ' *',
                                      //     style: TextStyle(
                                      //       color: Colors.red,
                                      //     ),
                                      //   ),
                                      // ],
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
                                      // children: [
                                      //   TextSpan(
                                      //     text: ' *',
                                      //     style: TextStyle(
                                      //       color: Colors.red,
                                      //     ),
                                      //   ),
                                      // ],
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
                        _buildTextField(_poleNumber, 'Pole Number', false),
                        _buildTextField(_poleHeight, 'Pole Height', false),
                        _buildTextField(
                            _noOfLine11Kv, 'Number of Line 11Kv', false),
                        _buildTextField(
                            _noOfLine33Kv, 'Number of Line 33Kv', false),
                        _buildTextField(
                            _noOfLineP4Kv, 'Number of Line 0.4Kv', false),
                      ],
                    ),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////

              ///////////////////////////////////////////////////////////////////////////////
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
              ///////////////////////////////////////////////////////////////////////////
              ///  ///////////////////////////////////////////////////////////////////////////////
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
                                // children: [
                                //   TextSpan(
                                //     text: ' *',
                                //     style: TextStyle(
                                //       color: Colors
                                //           .red, // Red color for the asterisk
                                //     ),
                                //   ),
                                // ],
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
              ///////////////////////////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////////////////////////////
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
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final int poleId =
                                await CallPoleApi().fetchMaxPoleId();
                            try {
                              int parseOrZero(String? text) {
                                try {
                                  return int.tryParse(text?.trim() ?? '') ?? 0;
                                } catch (e) {
                                  throw 'Invalid integer for field $text';
                                }
                              }

                              double parseOrZeroDouble(String? text) {
                                try {
                                  return double.tryParse(text?.trim() ?? '') ??
                                      0.0;
                                } catch (e) {
                                  throw 'Invalid double for field $text';
                                }
                              }

                              String formatDate(String? text) {
                                if (text != '') {
                                  try {
                                    return DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                        .format(DateTime.parse(
                                            text ?? dt.toString()));
                                  } catch (e) {
                                    throw 'Invalid Start Date format';
                                  }
                                } else {
                                  return "";
                                }
                              }

                              T checkNotNull<T>(T? value, String fieldName) {
                                if (value == null || value == 0.00) {
                                  throw 'Please Provide $fieldName Data.';
                                }
                                return value;
                              }

                              T checkNotSelect<T>(T? value, String fieldName) {
                                if (value == null || value == 0.00) {
                                  throw 'Please Select $fieldName.';
                                }
                                return value;
                              }

                              Poles pole = Poles(
                                zoneId: checkNotSelect(selectedZoneId, 'Zone'),
                                circleId:
                                    checkNotSelect(selectedCircleId, 'Circle'),
                                sndId: checkNotSelect(selectedSnDId, 'Snd'),
                                esuId: selectedEsuId,
                                poleId: poleId,
                                poleTypeId: checkNotSelect(
                                    selectedPoleTypeId, 'Pole Type'),
                                poleConditionId: selectedPoleConditionId ?? 0,
                                noOfWireHt: parseOrZero(_noOfWireHt.text),
                                noOfWireLt: parseOrZero(_noOfWireLt.text),
                                msjNo: _msjNo.text,
                                sleeveNo: _sleeveNo.text,
                                twistNo: _twistNo.text,
                                streetLight: _streetLight,
                                transformerExist: _transformerExist,
                                commonPole: _commonPole,
                                tap: _tap,
                                poleNumber: _poleNumber.text,
                                poleHeight: parseOrZeroDouble(_poleHeight.text),
                                noOfLine11Kv: parseOrZero(_noOfLine11Kv.text),
                                noOfLine33Kv: parseOrZero(_noOfLine33Kv.text),
                                noOfLineP4Kv: parseOrZero(_noOfLineP4Kv.text),
                                latitude: checkNotNull(
                                    parseOrZeroDouble(_latitudeController.text),
                                    'Latitude'),
                                longitude: checkNotNull(
                                    parseOrZeroDouble(
                                        _longitudeController.text),
                                    'Longitude'),
                                surveyorName: _surveyorNameController.text,
                                surveyDate:
                                    formatDate(_surveyDateController.text),
                                startingDate:
                                    formatDate(_startDateController.text),
                                remarks: _remarks.text,
                                activationStatusId: 2,
                                verificationStateId: 2,
                              );

                              await CallPoleApi().createPole(pole);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FilterPoleBySnd()),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pole Created Successfully'),
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
              ///////////////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField(TextEditingController controller, String label) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16.0),
  //     child: TextFormField(
  //       controller: controller,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //       ),
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Please enter $label';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }
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
