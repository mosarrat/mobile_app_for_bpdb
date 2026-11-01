// ignore_for_file: library_private_types_in_public_api, deprecated_member_use
import 'package:bpdb_gis_app/models/feederlines_lookup/feederline.dart';
import 'package:intl/intl.dart';

import '../../api/api.dart';
import '../../api/feederline_api.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/distribution_transformer.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/feederline_conductor.dart';
import '../../models/regions/feederlinetype.dart';
import '../../models/regions/pole.dart';
import '../../models/regions/service_point.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';
import 'package:flutter/material.dart';

import 'feederline_filter.dart';
import 'view_feederline.dart';
//import 'package:geolocator/geolocator.dart';

class NewFedderLineExp extends StatefulWidget {
  const NewFedderLineExp({super.key});

  @override
  _NewFedderLineExpState createState() => _NewFedderLineExpState();
}

class _NewFedderLineExpState extends State<NewFedderLineExp> {
  final _formKey = GlobalKey<FormState>();

  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<EsuInfo>> esu;
  late Future<List<Substation>> substations;
  late Future<List<Pole>> poles;
  late Future<List<ServicePoint>> servicePoints;
  late Future<List<DistributionTransformer>> dts;
  late Future<List<FeederLineType>> feederlinetype;
  late Future<List<FeederConductorType>> feederlineConductor;

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedEsuId;
  int? selectedSubstationId;
  int? selectedFeederLineId;

  int? selectedPoleId;
  int? selectedServicePointId;
  int? selectedDTId;
  int? selectedFeederlineTypeId;
  int? selectedFeederLineConductorId;

  bool isLoading = false;
  var dt = DateTime.now(); // Date-Time
  // #region controls
  final TextEditingController _feederlineId = TextEditingController();
  final TextEditingController _feederLineCode = TextEditingController();
  final TextEditingController _feederlineName = TextEditingController();
  final TextEditingController _feederLineToGrid = TextEditingController();
  final TextEditingController _feederLineUId = TextEditingController();
  final TextEditingController _feederLocation = TextEditingController();
  final TextEditingController _feederMeterNumber = TextEditingController();
  final TextEditingController _maximumDemand = TextEditingController();
  final TextEditingController _peakDemand = TextEditingController();
  final TextEditingController _sanctionedLoad = TextEditingController();
  final TextEditingController _nominalVoltage = TextEditingController();
  final TextEditingController _meterModelController = TextEditingController();
  final TextEditingController _meterCurrentRating = TextEditingController();
  final TextEditingController _bulkCustomerName = TextEditingController();
  final TextEditingController _feederLength = TextEditingController();
  final TextEditingController _meterVoltageRating = TextEditingController();

  String? gpsLat = "0.00";
  String? gpsLong = "0.00";
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  final TextEditingController _remarks = TextEditingController();

  String? selectedConsumerType;
  // #endregion

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    zones = CallApi().fetchZoneInfo();
    circles = Future.value([]);
    snds = Future.value([]);
    esu = Future.value([]);
    substations = Future.value([]);
    feederlinetype = CallApiService().fetchFeederLineTypeInfo();
    feederlineConductor = CallApiService().fetchFeederlineConductor();
  }

  void _getCurrentLocation() async {
    try {
      //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitudeController.text = "0.00"; // position.latitude.toString();
        _longitudeController.text = "0.00"; // position.longitude.toString();

        gpsLat = "0.00"; // position.latitude.toString();
        gpsLong = "0.00"; // position.longitude.toString();
      });
    } catch (e) {
      //print(e);
      _latitudeController.text = "0.00";
      _longitudeController.text = "0.00";

      gpsLat = "0.00";
      gpsLong = "0.00";
    }
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void onFeederlineType(int? value) {
    setLoading(true);
    selectedFeederlineTypeId = value;
  }

  void onFeederlineConductor(int? value) {
    setLoading(true);
    selectedFeederLineConductorId = value;
  }

  void onZoneChanged(int? value) {
    setLoading(true);
    selectedZoneId = value;
    selectedCircleId = null;
    selectedSnDId = null;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;
    circles = CallApi().fetchCircleInfo(value!).whenComplete(() {
      setLoading(false);
    });
    snds = Future.value([]);
    substations = Future.value([]);
  }

  void onCircleChanged(int? value) {
    setLoading(true);
    selectedCircleId = value;
    selectedSnDId = null;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;
    snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
      setLoading(false);
    });

    substations = Future.value([]);
  }

  void onSnDChanged(int? value) {
    setLoading(true);
    selectedSnDId = value;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;
    substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
      setLoading(false);
    });
    esu = CallApiService().fetchEsuInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  void onEsuChanged(int? value) {
    setLoading(true);
    selectedEsuId = value;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;
  }

  void onSubstationChanged(int? value) {
    setLoading(true);
    selectedSubstationId = value;
    selectedFeederLineId = null;
    selectedPoleId = null;
    selectedServicePointId = null;
    selectedDTId = null;
  }

  bool isGridSelected = false;
  bool isBluckConsumerSelected = false;
  void itemSwitchGrid(bool value) {
    setState(() {
      isGridSelected = !isGridSelected;
    });
  }

  void itemSwitchBlukConsumer(bool value) {
    setState(() {
      isBluckConsumerSelected = !isBluckConsumerSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'New Feeder Line',
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
          key: _formKey,
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
                                decoration: InputDecoration(
                                  labelText: 'Zone',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: selectedZoneId,
                                hint: const Text('Select a Zone'),
                                items: snapshot.data!.map((zone) {
                                  return DropdownMenuItem<int>(
                                    value: zone.zoneId,
                                    child: Text(
                                        '${zone.zoneCode}: ${zone.zoneName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedZoneId = value;
                                  onZoneChanged(value);
                                },
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
                                decoration: InputDecoration(
                                  labelText: 'Circle',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: null,
                                hint: const Text('No circles available!'),
                                items: [],
                                onChanged: null,
                              );
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'Circle',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: selectedCircleId,
                                hint: const Text('Select a Circle'),
                                items: snapshot.data!.map((circle) {
                                  return DropdownMenuItem<int>(
                                    value: circle.circleId,
                                    child: Text(
                                        '${circle.circleCode}: ${circle.circleName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCircleId = value;
                                    onCircleChanged(value);
                                  });
                                },
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
                                decoration: InputDecoration(
                                  labelText: 'SnD',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: null,
                                hint: const Text('No SnDs available!'),
                                items: [],
                                onChanged: null,
                              );
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'SnD',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: selectedSnDId,
                                hint: const Text('Select a SnD'),
                                items: snapshot.data!.map((snd) {
                                  return DropdownMenuItem<int>(
                                    value: snd.sndId,
                                    child:
                                        Text('${snd.sndCode}: ${snd.snDName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSnDId = value;
                                    onSnDChanged(value);
                                  });
                                },
                              );
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
                                    child:
                                        Text('${esu.esuCode}: ${esu.esuName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedEsuId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Esus available!');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        ///// Esu Info //////
                        FutureBuilder<List<Substation>>(
                          future: substations,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (snapshot.hasError) {
                              showMessage('Error: ${snapshot.error}', 'error');
                              return DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'Substation',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: null,
                                hint: const Text('No substations available!'),
                                items: [],
                                onChanged: null,
                              );
                            } else if (snapshot.hasData) {
                              return DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'Substation',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                ),
                                value: selectedSubstationId,
                                hint: const Text('Select a Substation'),
                                items: snapshot.data!.map((substation) {
                                  return DropdownMenuItem<int>(
                                    value: substation.substationId,
                                    child: Text(
                                        '${substation.substationCode}: ${substation.substationName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSubstationId = value;
                                    onSubstationChanged(value);
                                  });
                                },
                              );
                            } else {
                              return const Text('No substations available!');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ],
                ),
              ),
              ////////////////////////////////////////////////////////////////////////////
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  ////minTileHeight: 25,
                  collapsedBackgroundColor:
                      const Color.fromARGB(255, 241, 245, 245),
                  title: const Text('Feeder Line Information'),
                  childrenPadding: EdgeInsets.zero,
                  children: [
                    FieldsetLegend(
                      legendText: 'Feeder Line Information',
                      children: [
                        _buildTextField(_feederlineId, 'Feeder Line Id'),
                        _buildTextField(_feederLineCode, 'Feeder Line Code'),
                        _buildTextField(_feederlineName, 'Feeder Line Name'),
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
                                  const Text(
                                    'IsGrid',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Switch(
                                    value: isGridSelected,
                                    onChanged: itemSwitchGrid,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _buildTextField(
                            _feederLineToGrid, 'Feeder Line To Grid'),
                        _buildTextField(_feederLineUId, 'Feeder Line UId'),
                        FutureBuilder<List<FeederLineType>>(
                          future: feederlinetype,
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
                                decoration: InputDecoration(
                                  // labelText: 'Feeder Line Type',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize + 3,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                value: selectedFeederlineTypeId,
                                hint: const Text('Select a Feeder Line Type'),
                                items: snapshot.data!.map((feederlinetype) {
                                  return DropdownMenuItem<int>(
                                    value: feederlinetype.feederLineTypeId,
                                    child: Text(
                                        '${feederlinetype.feederLineTypeId}: ${feederlinetype.feederLineTypeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedFeederlineTypeId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text(
                                  'No Feeder Line Type available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        FutureBuilder<List<FeederConductorType>>(
                          future: feederlineConductor,
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
                                  // labelText: 'Feeder Line Type',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: deviceFontSize - 3,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                value: selectedFeederLineConductorId,
                                hint: const Text(
                                    'Select a FeederLine Conductor Type'),
                                items:
                                    snapshot.data!.map((feederlineConductor) {
                                  return DropdownMenuItem<int>(
                                    value: feederlineConductor
                                        .feederConductorTypeId,
                                    child: Text(
                                      '${feederlineConductor.feederConductorTypeId}: ${feederlineConductor.feederConductorTypeName}',
                                      style:
                                          TextStyle(fontSize: deviceFontSize),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedFeederLineConductorId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text(
                                  'No Feeder Line Type available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(
                            _feederLocation, 'Feeder Line Location'),
                        _buildTextField(_feederLength, 'Feeder Line Length'),
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
                  title: const Text('Meter Information'),
                  childrenPadding: EdgeInsets.zero,
                  children: [
                    FieldsetLegend(
                      legendText: 'Meter Information',
                      children: [
                        _buildTextField(_feederMeterNumber, 'Feeder Meter No'),
                        _buildTextField(_nominalVoltage, 'Nominal Voltage'),
                        _buildTextField(
                            _meterCurrentRating, 'Meter Current Rating'),
                        _buildTextField(
                            _meterVoltageRating, 'Meter Voltage Rating'),
                        _buildTextField(_maximumDemand, 'Maximum Demand'),
                        _buildTextField(_peakDemand, 'Peak Demand'),
                        _buildTextField(_sanctionedLoad, 'Sanctioned Load'),
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
                                  const Text(
                                    'Is BulkCustomer',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Switch(
                                    value: isBluckConsumerSelected,
                                    onChanged: itemSwitchBlukConsumer,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _buildTextField(
                            _bulkCustomerName, 'Bulk Customer Name'),
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
                      const Color.fromARGB(255, 241, 245, 245),
                  title: const Text('Remarks'),
                  childrenPadding: EdgeInsets.zero,
                  children: [
                    FieldsetLegend(
                      legendText: 'Remarks',
                      children: [
                        _buildTextField(_remarks, 'Remarks'),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              T checkNotNull<T>(T? value, String fieldName) {
                                if (value == null || value == 0) {
                                  throw 'Invalid value for $fieldName. PLease Check Again ';
                                }
                                return value;
                              }

                              await CallApiService().createData(FeederLines(
                                feederLineId: checkNotNull(
                                    int.parse(_feederlineId.text),
                                    'Feeder Line Id'),
                                feederlineName: checkNotNull(
                                    _feederlineName.text, 'Feeder Line Name'),
                                zoneId: checkNotNull(selectedZoneId, 'Zone'),
                                circleId:
                                    checkNotNull(selectedCircleId, 'Circle'),
                                sndId: checkNotNull(selectedSnDId, 'SnD'),
                                esuId: selectedEsuId,
                                sourceSubstationId: checkNotNull(
                                    selectedSubstationId, 'Substation'),
                                destinationSubstationId: 2,
                                feederLineCode: checkNotNull(
                                    _feederLineCode.text, 'Feeder Line Code'),
                                isGrid: isGridSelected,
                                gridSubstationInputId: 0,
                                feederLineUId: checkNotNull(
                                    _feederLineUId.text, 'Feeder Line UId'),
                                feederLineTypeId: checkNotNull(
                                    selectedFeederlineTypeId,
                                    'Feeder Line Type'),
                                feederConductorTypeId: checkNotNull(
                                    selectedFeederLineConductorId,
                                    'Feeder Line Conductor Type'),
                                nominalVoltage: checkNotNull(
                                    double.tryParse(_nominalVoltage.text),
                                    'Nominal Voltage'),
                                feederLocation: _feederLocation.text,
                                feederMeterNumber: _feederMeterNumber.text,
                                meterCurrentRating:
                                    int.tryParse(_meterCurrentRating.text),
                                meterVoltageRating:
                                    double.tryParse(_meterVoltageRating.text),
                                maximumDemand:
                                    double.tryParse(_maximumDemand.text),
                                peakDemand: double.tryParse(_peakDemand.text),
                                maximumLoad:
                                    double.tryParse(_maximumDemand.text),
                                sanctionedLoad:
                                    double.tryParse(_sanctionedLoad.text),
                                isBulkCustomer: isBluckConsumerSelected,
                                bulkCustomerName: _bulkCustomerName.text,
                                isPgcbGrid: false,
                                startingDate:
                                    DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                        .format(dt),
                                activationStatusId: 2,
                                verificationStateId: 2,
                                isPermittedToVerify: false,
                                isPermittedToApprove: false,
                                isEditAvailable: false,
                                feederLength: double.tryParse(_feederLength.text) ?? 0,
                                remarks: _remarks.text,
                              ));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FeederLineFilter()),
                                    //builder: (context) => FilterFeederline()),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Feeder Line Info Created Successfully'),
                                    backgroundColor: Colors.green),
                              );
                            } catch (error) {
                              //print(error);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('$error'),
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
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
}
