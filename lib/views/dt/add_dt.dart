import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../api/dt_api.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';
import '../../models/dt_lookup/Support_pole_type.dart';
import '../../models/dt_lookup/add_dt_model.dart';
import '../../models/dt_lookup/body_color_condition.dart';
import '../../models/dt_lookup/dt_condition.dart';
import '../../models/dt_lookup/installed_condition.dart';
import '../../models/dt_lookup/installed_place.dart';
import '../../models/dt_lookup/platform_material.dart';
import '../../models/dt_lookup/support_pole_condition.dart';
import '../../models/dt_lookup/transformer_owner.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/pole.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';
import 'filter_dt.dart';

class AddDTInfo extends StatefulWidget {
  const AddDTInfo({super.key});

  @override
  State<AddDTInfo> createState() => _AddDTInfoState();
}

class _AddDTInfoState extends State<AddDTInfo> {
  final _formKey = GlobalKey<FormState>();

  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<EsuInfo>> esu;
  late Future<List<Substation>> substations;
  late Future<List<FeederLine>> feederLines;
  late Future<List<Pole>> poleLeft;
  late Future<List<Pole>> poleRight;

  late Future<List<DTCondition>> fetchDTCondition;

  late Future<List<InstalledCondition>> installedCondition;
  late Future<List<InstalledPlaced>> installPlaced;
  late Future<List<TransformerOwner>> transformerOwner;
  late Future<List<BodyColorCondition>> bodyColorCondition;
  late Future<List<PlatfromMeterial>> platformMaterial;
  late Future<List<SupportPoleType>> typeOfSupportPole;
  late Future<List<SupportPoleCondition>> supportPoleCondition;

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedEsuId;
  int? selectedSubstationId;
  int? selectedFeederLineId;
  int? selectedPoleDetailLeftId;
  int? selectedPoleDetailRightId;

  int? selectedDTConditionId;
  int? selectedInstalledConditionId;
  int? selectedInstalledPlaceId;
  int? selectedTransformerOwnerId;
  int? selectedBodyConditionId;
  int? selectedPlatformMaterial;
  int? selectedSupportPoleTypeLeft;
  String? selectedSupportPoleConditionLeft;
  int? selectedSupportPoleTypeRight;
  String? selectedSupportPoleConditionRight;

  int? selectedhtBushingRPhaseOil;
  int? selectedhtBushingYPhaseOil;
  int? selectedhtBushingBPhaseOil;
  int? selectedhtBushingNPhaseOil;
  int? selectedltBushingRPhaseOil;
  int? selectedltBushingYPhaseOil;
  int? selectedltBushingBPhaseOil;
  int? selectedltBushingNPhaseOil;

  int? selectedconditionofDropOutFuseRphase;
  int? selectedconditionofDropOutFuseYphase;
  int? selectedconditionofDropOutFuseBphase;

  int? selectedconditionofLightingArrestorRphase;
  int? selectedconditionofLightingArrestorYphase;
  int? selectedconditionofLightingArrestorBphase;

  int? selectedconditionofDistributionBox;

  int? selectedmanufacturerTypeOriginofMCCBforCircuit1;
  int? selectedmanufacturerTypeOriginofMCCBforCircuit2;
  int? selectedconditionofMCCBforCircuit1;
  int? selectedconditionofMCCBforCircuit2;

  int? selectedconditionofHTDropGoodbsBad;
  int? selectedconditionofLTDropGoodbsBadCKT1;	
  int? selectedconditionofLTDropGoodbsBadCKT2;
  int? selectedearthingLead1ConditionStandard;
  int? selectedearthingLead2ConditionStandard;

  var dt = DateTime.now(); // Date-Time
  bool isLoading = false;
  User? user = globalUser;

  @override
  void initState() {
    super.initState();
    zones = CallApi().fetchZoneInfo();
    circles = Future.value([]);
    snds = Future.value([]);
    esu = Future.value([]);
    substations = Future.value([]);
    feederLines = Future.value([]);
    poleLeft = Future.value([]);
    poleRight = Future.value([]);
    fetchDTCondition = CallDTApi().fetchDTCondition();
    installedCondition = CallDTApi().installedCondition();
    installPlaced = CallDTApi().installPlaced();
    transformerOwner = CallDTApi().transformerOwner();
    bodyColorCondition = CallDTApi().bodyColorCondition();
    platformMaterial = CallDTApi().platformMaterial();
    typeOfSupportPole = CallDTApi().typeOfSupportPole();
    supportPoleCondition = CallDTApi().supportPoleCondition();
    _startingDate.text = DateFormat('yyyy-MM-dd').format(dt);
    _lastMaintenanceDate.text = DateFormat('yyyy-MM-dd').format(dt);
    _dateAndTime1.text = DateFormat('yyyy-MM-dd').format(dt);
    _dateAndTime2.text = DateFormat('yyyy-MM-dd').format(dt);
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
    selectedSubstationId = null;
    selectedFeederLineId = null;
    selectedPoleDetailLeftId = null;
    selectedPoleDetailRightId = null;
    circles = CallApi().fetchCircleInfo(value!).whenComplete(() {
      setLoading(false);
    });
    snds = Future.value([]);
    substations = Future.value([]);
    feederLines = Future.value([]);
    poleLeft = Future.value([]);
    poleRight = Future.value([]);
  }

  void onCircleChanged(int? value) {
    setLoading(true);
    selectedCircleId = value;
    selectedSnDId = null;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    selectedPoleDetailLeftId = null;
    selectedPoleDetailRightId = null;
    snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
      setLoading(false);
    });
    substations = Future.value([]);
    feederLines = Future.value([]);
    poleLeft = Future.value([]);
    poleRight = Future.value([]);
  }

  void onSnDChanged(int? value) {
    setLoading(true);
    selectedSnDId = value;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    selectedPoleDetailLeftId = null;
    selectedPoleDetailRightId = null;
    substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
      setLoading(false);
    });
    esu = CallConsumerApi().fetchEsuInfo(value!).whenComplete(() {
      setLoading(false);
    });
    feederLines = Future.value([]);
    poleLeft = Future.value([]);
    poleRight = Future.value([]);
  }

  void onEsuChanged(int? value) {
    setLoading(true);
    selectedEsuId = value;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    selectedPoleDetailLeftId = null;
    selectedPoleDetailRightId = null;
  }

  void onSubstationChanged(int? value) {
    setLoading(true);
    selectedSubstationId = value;
    selectedFeederLineId = null;
    selectedPoleDetailLeftId = null;
    selectedPoleDetailRightId = null;
    feederLines = CallApi().fetchFeederLineInfo(value!).whenComplete(() {
      setLoading(false);
    });
    poleLeft = Future.value([]);
    poleRight = Future.value([]);
  }

  void onFeederLineChanged(int? value) {
    setLoading(true);
    selectedFeederLineId = value;
    selectedPoleDetailLeftId = null;
    selectedPoleDetailRightId = null;
    poleLeft = CallApi().fetchPoleInfo(value!).whenComplete(() {
      setLoading(false);
    });
    poleRight = CallApi().fetchPoleInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  bool _oilLeakageYesOrNo = false;
  bool _htBushingRPhaseOil = false;
  bool _htBushingYPhaseOil = false;
  bool _htBushingBPhaseOil = false;
  bool _htBushingNPhaseOil = false;
  bool _ltBushingRPhaseOil = false;
  bool _ltBushingYPhaseOil = false;
  bool _ltBushingBPhaseOil = false;
  bool _ltBushingNPhaseOil = false;

  bool _dropOutFuseExistbsNotExistRphase = false;
  bool _dropOutFuseExistbsNotExistYphase = false;
  bool _dropOutFuseExistbsNotExistBphase = false;
  bool _lightningArrestorRphase = false;
  bool _lightningArrestorYphase = false;
  bool _lightningArrestorBphase = false;
  bool _distributionBoxExistbsnotExist = false;
  void itemSwitchoilLeakage(bool value) {
    setState(() {
      _oilLeakageYesOrNo = !_oilLeakageYesOrNo;
    });
  }

  void itemSwitchHtBushingRPhaseOil(bool value) {
    setState(() {
      _htBushingRPhaseOil = !_htBushingRPhaseOil;
    });
  }

  void itemSwitchHtBushingYPhaseOil(bool value) {
    setState(() {
      _htBushingYPhaseOil = !_htBushingYPhaseOil;
    });
  }

  void itemSwitchHTBushingBPhaseOil(bool value) {
    setState(() {
      _htBushingBPhaseOil = !_htBushingBPhaseOil;
    });
  }

  void itemSwitchHTBushingNPhaseOil(bool value) {
    setState(() {
      _htBushingNPhaseOil = !_htBushingNPhaseOil;
    });
  }

  void itemSwitchLtBushingRPhaseOil(bool value) {
    setState(() {
      _ltBushingRPhaseOil = !_ltBushingRPhaseOil;
    });
  }

  void itemSwitchLtBushingYPhaseOil(bool value) {
    setState(() {
      _ltBushingYPhaseOil = !_ltBushingYPhaseOil;
    });
  }

  void itemSwitchLtBushingBPhaseOil(bool value) {
    setState(() {
      _ltBushingBPhaseOil = !_ltBushingBPhaseOil;
    });
  }

  void itemSwitchLtBushingNPhaseOil(bool value) {
    setState(() {
      _ltBushingNPhaseOil = !_ltBushingNPhaseOil;
    });
  }

  // For _dropOutFuseExistbsNotExistRphase
  void itemSwitchDropOutFuseRphase(bool value) {
    setState(() {
      _dropOutFuseExistbsNotExistRphase = !_dropOutFuseExistbsNotExistRphase;
    });
  }

// For _dropOutFuseExistbsNotExistYphase
  void itemSwitchDropOutFuseYphase(bool value) {
    setState(() {
      _dropOutFuseExistbsNotExistYphase = !_dropOutFuseExistbsNotExistYphase;
    });
  }

// For _dropOutFuseExistbsNotExistBphase
  void itemSwitchDropOutFuseBphase(bool value) {
    setState(() {
      _dropOutFuseExistbsNotExistBphase = !_dropOutFuseExistbsNotExistBphase;
    });
  }

// For _lightningArrestorRphase
  void itemSwitchLightningArrestorRphase(bool value) {
    setState(() {
      _lightningArrestorRphase = !_lightningArrestorRphase;
    });
  }

// For _lightningArrestorYphase
  void itemSwitchLightningArrestorYphase(bool value) {
    setState(() {
      _lightningArrestorYphase = !_lightningArrestorYphase;
    });
  }

// For _lightningArrestorBphase
  void itemSwitchLightningArrestorBphase(bool value) {
    setState(() {
      _lightningArrestorBphase = !_lightningArrestorBphase;
    });
  }

// For _distributionBoxExistbsnotExist
  void itemSwitchDistributionBoxExist(bool value) {
    setState(() {
      _distributionBoxExistbsnotExist = !_distributionBoxExistbsnotExist;
    });
  }

  final TextEditingController _dtCode = TextEditingController();
  final TextEditingController _dtLocationName = TextEditingController();
  final TextEditingController _dtNumber = TextEditingController();
  final TextEditingController _nameOf33Bs11KvSubstation =
      TextEditingController();
  final TextEditingController _nameof11KvFeeder = TextEditingController();
  final TextEditingController _sndIdentificationNo = TextEditingController();
  final TextEditingController _nearestHoldingHouseNoShop =
      TextEditingController();
  final TextEditingController _existingPoleNumberIfAny =
      TextEditingController();
  final TextEditingController _transformerKvaRating = TextEditingController();
  final TextEditingController _contactNo = TextEditingController();
  final TextEditingController _yearOfManufacturing = TextEditingController();
  final TextEditingController _nameofManufacturer = TextEditingController();
  final TextEditingController _transformerSerialNo = TextEditingController();
  final TextEditingController _nameOfBodyColor = TextEditingController();
  final TextEditingController _placeOfOilLeakageMark = TextEditingController();
  final TextEditingController _ratedVoltage = TextEditingController();
  final TextEditingController _ratedHtVoltage = TextEditingController();
  final TextEditingController _ratedLTVoltage = TextEditingController();
  final TextEditingController _ratedHTCurrent = TextEditingController();
  final TextEditingController _ratedLTCurrent = TextEditingController();
  final TextEditingController _controlVoltage = TextEditingController();
  final TextEditingController _motorVoltageforspringcharge =
      TextEditingController();
  final TextEditingController _htBushingRPhaseColor = TextEditingController();
  final TextEditingController _htBushingYPhaseColor = TextEditingController();
  final TextEditingController _htBushingBPhaseColor = TextEditingController();
  final TextEditingController _htBushingNPhaseColor = TextEditingController();
  final TextEditingController _ltBushingRPhaseColor = TextEditingController();
  final TextEditingController _ltBushingYPhaseColor = TextEditingController();
  final TextEditingController _ltBushingBPhaseColor = TextEditingController();
  final TextEditingController _ltBushingNPhaseColor = TextEditingController();

  final TextEditingController _voltage1 = TextEditingController();
  final TextEditingController _ryVoltageVolt1 = TextEditingController();
  final TextEditingController _ybVoltageVolt1 = TextEditingController();
  final TextEditingController _rbVoltageVolt1 = TextEditingController();
  final TextEditingController _rnVoltageVolt1 = TextEditingController();
  final TextEditingController _ynVoltageVolt1 = TextEditingController();
  final TextEditingController _bnVoltageVolt1 = TextEditingController();
  final TextEditingController _leakageVoltageBodyEarthVolt1 =
      TextEditingController();

  final TextEditingController _voltage2 = TextEditingController();
  final TextEditingController _ryVoltageVolt2 = TextEditingController();
  final TextEditingController _ybVoltageVolt2 = TextEditingController();
  final TextEditingController _rbVoltageVolt2 = TextEditingController();

  final TextEditingController _wireSizeofHTDrop = TextEditingController();
  final TextEditingController _wirebsCableSizeofLTDropCKT1 =
      TextEditingController();
  final TextEditingController _wirebsCableSizeofLTDropCKT2 =
      TextEditingController();
  final TextEditingController _earthingLead1 = TextEditingController();
  final TextEditingController _earthingLead1Size = TextEditingController();
  final TextEditingController _earthingLead1Material = TextEditingController();
  final TextEditingController _earthingLead2 = TextEditingController();
  final TextEditingController _earthingLead2Size = TextEditingController();
  final TextEditingController _earthingLead2Material = TextEditingController();
  final TextEditingController _dayPeak = TextEditingController();
  final TextEditingController _dateAndTime1 = TextEditingController();

  final TextEditingController _rPhaseCurrentAmps1Ckt1 = TextEditingController();
  final TextEditingController _rPhaseCurrentAmps1Ckt2 = TextEditingController();
  final TextEditingController _rPhaseCurrentAmps1Ckt3 = TextEditingController();
  final TextEditingController _yPhaseCurrentAmps1Ckt1 = TextEditingController();
  final TextEditingController _yPhaseCurrentAmps1Ckt2 = TextEditingController();
  final TextEditingController _yPhaseCurrentAmps1Ckt3 = TextEditingController();
  final TextEditingController _bPhaseCurrentAmps1Ckt1 = TextEditingController();
  final TextEditingController _bPhaseCurrentAmps1Ckt2 = TextEditingController();
  final TextEditingController _bPhaseCurrentAmps1Ckt3 = TextEditingController();
  final TextEditingController _neutralCurrentAmps1Ckt1 =
      TextEditingController();
  final TextEditingController _neutralCurrentAmps1Ckt2 =
      TextEditingController();
  final TextEditingController _neutralCurrentAmps1Ckt3 =
      TextEditingController();
  final TextEditingController _calculatedDayPeakkVA = TextEditingController();
  final TextEditingController _calculatedEveningPeakkVA =
      TextEditingController();
  final TextEditingController _eveningPeak = TextEditingController();
  final TextEditingController _dateAndTime2 = TextEditingController();

  final TextEditingController _noOfMCCB = TextEditingController();
  final TextEditingController _ampereRatingasPerNamePlateofMCCBforCKT1 =
      TextEditingController();
  final TextEditingController _ampereRatingasPerNameplateOfMCCBForCKT2 =
      TextEditingController();

  final TextEditingController _lastMaintenanceDate = TextEditingController();
  final TextEditingController _startingDate = TextEditingController();
  final TextEditingController _recommendation = TextEditingController();
  final TextEditingController _remarks = TextEditingController();

  final TextEditingController _manufacturerTypeOriginofMCCBforCircuit1 = TextEditingController();
  final TextEditingController _manufacturerTypeOriginofMCCBforCircuit2 = TextEditingController();

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
      substations =
          CallApi().fetchSubstationInfo(selectedSnDId!).whenComplete(() {
        setLoading(false);
      });
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'New DT Info',
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
          child: ListView(padding: EdgeInsets.zero, children: [
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
                                : null,
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
                                : null,
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
                              isExpanded: true,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: 'Substation',
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
                              hint: const Text('No substations available!'),
                              items: [],
                              onChanged: null,
                            );
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: 'Substation',
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
                              value: selectedSubstationId,
                              hint: const Text('Select a Substation'),
                              items: snapshot.data!.map((substation) {
                                return DropdownMenuItem<int>(
                                  value: substation.substationId,
                                  child: Text(substation.substationName),
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
                      FutureBuilder<List<FeederLine>>(
                        future: feederLines,
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
                                    text: 'Feeder Line',
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
                              hint: const Text('No feeder line available!'),
                              items: [],
                              onChanged: null,
                            );
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: 'Feeder Line',
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
                              value: selectedFeederLineId,
                              hint: const Text('Select a Feeder Line'),
                              items: snapshot.data!.map((feeder) {
                                return DropdownMenuItem<int>(
                                  value: feeder.feederLineId,
                                  child: Text(
                                    feeder.operatingSndName != null &&
                                            feeder.operatingSndName!.isNotEmpty
                                        ? '${feeder.feederlineName ?? ''} (${feeder.operatingSndName})'
                                        : feeder.feederlineName ?? '',
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedFeederLineId = value;
                                  onFeederLineChanged(value);
                                });
                              },
                            );
                          } else {
                            return const Text('No feeder line available!');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<Pole>>(
                        future: poleLeft,
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
                                    text: 'Pole Details Left Id',
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
                              hint: const Text('No pole available!'),
                              items: [],
                              onChanged: null,
                            );
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: 'Pole Details Left Id',
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
                              value: selectedPoleDetailLeftId,
                              hint: const Text('Select a Pole Detail Left Id'),
                              items: snapshot.data!.map((pole) {
                                return DropdownMenuItem<int>(
                                  value: pole.poleId,
                                  child: Text(pole.poleCode),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedPoleDetailLeftId = value;
                                  //onPoleChanged(value);
                                });
                              },
                            );
                          } else {
                            return const Text('No pole available!');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<Pole>>(
                        future: poleRight,
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
                                    text: 'Pole Details Right Id',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: deviceFontSize + 3,
                                    ),
                                    // children: const [
                                    //   TextSpan(
                                    //     text: ' *',
                                    //     style: TextStyle(
                                    //       color: Colors.red,
                                    //     ),
                                    //   ),
                                    // ],
                                  ),
                                ),
                              ),
                              value: null,
                              hint: const Text('No pole available!'),
                              items: [],
                              onChanged: null,
                            );
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(
                                    text: 'Pole Details Right Id',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: deviceFontSize + 3,
                                    ),
                                    // children: const [
                                    //   TextSpan(
                                    //     text: ' *',
                                    //     style: TextStyle(
                                    //       color: Colors.red,
                                    //     ),
                                    //   ),
                                    // ],
                                  ),
                                ),
                              ),
                              value: selectedPoleDetailRightId,
                              hint: const Text('Select a Pole Detail Right Id'),
                              items: snapshot.data!.map((pole) {
                                return DropdownMenuItem<int>(
                                  value: pole.poleId,
                                  child: Text(pole.poleCode),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedPoleDetailRightId = value;
                                  //onPoleChanged(value);
                                });
                              },
                            );
                          } else {
                            return const Text('No pole available!');
                          }
                        },
                      ),
                      const SizedBox(height: 17.5),
                      //_buildTextField(_poleLeftId, 'Pole Id'),
                      // _buildTextField(_poleDetailLeftId, 'Pole Detail Left Id'),
                      // _buildTextField(
                      //     _poleDetailRightId, 'Pole Detail Right Id'),
                    ],
                  ),
                ],
              ),
            ),
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
                title: const Text('Distribution Transformer Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Distribution Transformer Information',
                    children: [
                      // _buildTextField(
                      //     _dtId, 'Distribution Transformer Id', false),
                      _buildTextField(
                          _dtCode, 'Distribution Transformer Code', true),
                      _buildTextField(_dtLocationName,
                          'Distribution Transformer Location Name', false),
                      _buildTextField(
                          _dtNumber, 'Distribution Transformer Number', false),
                      FutureBuilder<List<DTCondition>>(
                        future: fetchDTCondition,
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
                              value: selectedDTConditionId,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a DT Condition',
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
                              items: snapshot.data!.map((dtCondition) {
                                return DropdownMenuItem<int>(
                                  value: dtCondition.id,
                                  child: Text(
                                      dtCondition.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedDTConditionId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No DT Condition available');
                          }
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
                title: const Text('Distribution Transformer Other Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Distribution Transformer Other Information',
                    children: [
                      _buildTextField(_nameOf33Bs11KvSubstation,
                          'Name Of 33 Bs 11 Kv Substation', false),
                      _buildTextField(
                          _nameof11KvFeeder, 'Name Of 11 Kv Feeder', false),
                      _buildTextField(
                          _sndIdentificationNo, 'SnD Identification No', false),
                      _buildTextField(_nearestHoldingHouseNoShop,
                          'Nearest Holding House No Shop', false),
                      _buildTextField(_existingPoleNumberIfAny,
                          'Existing Pole Number If Any', false),
                      FutureBuilder<List<InstalledCondition>>(
                        future: installedCondition,
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
                              value: selectedInstalledConditionId,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Install Condition',
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
                              items: snapshot.data!.map((installedCondition) {
                                return DropdownMenuItem<int>(
                                  value: installedCondition.id,
                                  child: Text(
                                      installedCondition.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedInstalledConditionId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Pole Condition available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<InstalledPlaced>>(
                        future: installPlaced,
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
                              value: selectedInstalledPlaceId,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Installed Place',
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
                              items: snapshot.data!.map((installedPlace) {
                                return DropdownMenuItem<int>(
                                  value: installedPlace.id,
                                  child: Text(
                                      installedPlace.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedInstalledPlaceId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Pole Condition available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<TransformerOwner>>(
                        future: transformerOwner,
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
                              value: selectedTransformerOwnerId,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Transformer Owner',
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
                              items: snapshot.data!.map((transformerOwner) {
                                return DropdownMenuItem<int>(
                                  value: transformerOwner.id,
                                  child: Text(
                                      transformerOwner.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedTransformerOwnerId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Transformer Owner available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(_transformerKvaRating,
                          'Transformer Kva Rating', false),
                      _buildTextField(_contactNo, 'Contact No', false),
                      // _buildTextField(
                      //     _yearOfManufacturing, 'Year Of Manufacturing'),
                      TextFormField(
                        controller: _yearOfManufacturing,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          label: RichText(
                            text: const TextSpan(
                              text: "Year Of Manufacturing",
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
                          _selectYearofManufacturing(context);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Year of Manufacturing';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                          _nameofManufacturer, 'Name of Manufacturer', false),
                      _buildTextField(
                          _transformerSerialNo, 'Transformer Serial No', false),
                      FutureBuilder<List<BodyColorCondition>>(
                        future: bodyColorCondition,
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
                              value: selectedBodyConditionId,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Body Color Condition',
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
                              items: snapshot.data!.map((bodyColorCondition) {
                                return DropdownMenuItem<int>(
                                  value: bodyColorCondition.id,
                                  child: Text(
                                      bodyColorCondition.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedBodyConditionId = value;
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
                          _nameOfBodyColor, 'Name Of Body Color', false),
                      _buildSwitchButton(_oilLeakageYesOrNo,
                          itemSwitchoilLeakage, 'Oil Leakage Yes or No'),
                      _buildTextField(_placeOfOilLeakageMark,
                          'Place Of Oil Leakage Mark', false),
                      FutureBuilder<List<PlatfromMeterial>>(
                        future: platformMaterial,
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
                              value: selectedPlatformMaterial,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Platform Material',
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
                              items: snapshot.data!.map((platformMeterials) {
                                return DropdownMenuItem<int>(
                                  value: platformMeterials.id,
                                  child: Text(
                                      platformMeterials.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedPlatformMaterial = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Platform Material Available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<SupportPoleType>>(
                        future: typeOfSupportPole,
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
                              value: selectedSupportPoleTypeLeft,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Type Transformer Support Pole Left',
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
                              items: snapshot.data!.map((supportpoleTypeleft) {
                                return DropdownMenuItem<int>(
                                  value: supportpoleTypeleft.id,
                                  child: Text(
                                      supportpoleTypeleft.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSupportPoleTypeLeft = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Support Pole Type');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<SupportPoleCondition>>(
                        future: supportPoleCondition,
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
                              // Parse the string to an int, but ensure it is not null or invalid
                              value: selectedSupportPoleConditionLeft != null
                                  ? int.tryParse(
                                      selectedSupportPoleConditionLeft!)
                                  : null,
                              hint: RichText(
                                text: const TextSpan(
                                  text:
                                      'Condition of Transformer Support Pole Left',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 100, 97, 97),
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              items: snapshot.data!
                                  .map((supportPoleConditionLeft) {
                                return DropdownMenuItem<int>(
                                  value:
                                      int.tryParse(supportPoleConditionLeft.id),
                                  child: Text(
                                      supportPoleConditionLeft.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSupportPoleConditionLeft = value
                                      ?.toString(); // Convert int back to string
                                });
                              },
                            );
                          } else {
                            return const Text('No Support Pole Condition');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<SupportPoleType>>(
                        future: typeOfSupportPole,
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
                              value: selectedSupportPoleTypeRight,
                              hint: RichText(
                                text: const TextSpan(
                                  text:
                                      'Type of Transformer Support Pole Right',
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
                              items: snapshot.data!.map((supportPoleTypeRight) {
                                return DropdownMenuItem<int>(
                                  value: supportPoleTypeRight.id,
                                  child: Text(
                                      supportPoleTypeRight.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSupportPoleTypeRight = value;
                                });
                              },
                            );
                          } else {
                            return const Text(
                                'No Type of Transformer Support Pole Right available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<SupportPoleCondition>>(
                        future: supportPoleCondition,
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
                              // Parse the string to an int, but ensure it is not null or invalid
                              value: selectedSupportPoleConditionRight != null
                                  ? int.tryParse(
                                      selectedSupportPoleConditionRight!)
                                  : null,
                              hint: RichText(
                                text: const TextSpan(
                                  text:
                                      'Condition of Transformer Support Pole Right',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 100, 97, 97),
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              items: snapshot.data!
                                  .map((supportPoleConditionRight) {
                                return DropdownMenuItem<int>(
                                  value: int.tryParse(
                                      supportPoleConditionRight.id),
                                  child: Text(
                                      supportPoleConditionRight.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSupportPoleConditionRight = value
                                      ?.toString(); // Convert int back to string
                                });
                              },
                            );
                          } else {
                            return const Text(
                                'No Support Pole Condition Right');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
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
                title: const Text('Voltage Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Rated Voltage/Current',
                    children: [
                      _buildTextField(_ratedVoltage, 'Rated Voltage', false),
                      _buildTextField(
                          _ratedHtVoltage, 'Rated Ht Voltage', false),
                      _buildTextField(
                          _ratedLTVoltage, 'Rated Lt Voltage', false),
                      _buildTextField(
                          _ratedHTCurrent, 'Rated Ht Current', false),
                      _buildTextField(
                          _ratedLTCurrent, 'Rated Lt Current', false),
                      _buildTextField(
                          _controlVoltage, 'Control Voltage', false),
                      _buildTextField(_motorVoltageforspringcharge,
                          'Motor Voltage for Spring Charge', false),
                    ],
                  ),
                  FieldsetLegend(
                    legendText: 'Voltage 1',
                    children: [
                      _buildTextField(_voltage1, 'Voltage 1', false),
                      _buildTextField(
                          _ryVoltageVolt1, 'RY Voltage Volt 1', false),
                      _buildTextField(
                          _ybVoltageVolt1, 'YB Voltage Volt 1', false),
                      _buildTextField(
                          _rbVoltageVolt1, 'RB Voltage Volt 1', false),
                      _buildTextField(
                          _rnVoltageVolt1, 'RN Voltage Volt 1', false),
                      _buildTextField(
                          _ynVoltageVolt1, 'YN Voltage Volt 1', false),
                      _buildTextField(
                          _bnVoltageVolt1, 'BN Voltage Volt 1', false),
                      _buildTextField(_leakageVoltageBodyEarthVolt1,
                          'Leakage Voltage Body Earth Volt 1', false),
                    ],
                  ),
                  FieldsetLegend(
                    legendText: 'Voltage 2',
                    children: [
                      _buildTextField(_voltage2, 'Voltage 2', false),
                      _buildTextField(
                          _ryVoltageVolt2, 'RY Voltage Volt 2', false),
                      _buildTextField(
                          _ybVoltageVolt2, 'YB Voltage Volt 2', false),
                      _buildTextField(
                          _rbVoltageVolt2, 'RB Voltage Volt 2', false),
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
                title: const Text('Bushing Phase Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Bushing Phase',
                    children: [
                      _buildSwitchButton(
                          _htBushingRPhaseOil,
                          itemSwitchHtBushingRPhaseOil,
                          'Ht Bushing R Phase Oil'),
                      _builtDTCondDropdown(selectedhtBushingRPhaseOil,
                          'Ht Bushing R Phase', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_htBushingRPhaseColor,
                          'Ht Bushing R Phase Color', false),
                      _buildSwitchButton(
                          _htBushingYPhaseOil,
                          itemSwitchHtBushingYPhaseOil,
                          'Ht Bushing Y Phase Oil'),
                      _builtDTCondDropdown(selectedhtBushingYPhaseOil,
                          'Ht Bushing Y Phase', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_htBushingYPhaseColor,
                          '"Ht Bushing Y Phase Color', false),
                      _buildSwitchButton(
                          _htBushingBPhaseOil,
                          itemSwitchHTBushingBPhaseOil,
                          'Ht Bushing B Phase Oil'),
                      _builtDTCondDropdown(selectedhtBushingBPhaseOil,
                          'Ht Bushing B Phase', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_htBushingBPhaseColor,
                          'Ht Bushing B Phase Color', false),
                      _buildSwitchButton(
                          _htBushingNPhaseOil,
                          itemSwitchHTBushingNPhaseOil,
                          'Ht Bushing N Phase Oil'),
                      _builtDTCondDropdown(selectedhtBushingNPhaseOil,
                          'Ht Bushing N Phase', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_htBushingNPhaseColor,
                          'Ht Bushing N Phase Color', false),
                      _buildSwitchButton(
                          _ltBushingRPhaseOil,
                          itemSwitchLtBushingRPhaseOil,
                          'Lt Bushing R Phase Oil'),
                      _builtDTCondDropdown(selectedltBushingRPhaseOil,
                          'Lt Bushing R Phase', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_ltBushingRPhaseColor,
                          'Lt Bushing R Phase Color', false),
                      _buildSwitchButton(
                          _ltBushingYPhaseOil,
                          itemSwitchLtBushingYPhaseOil,
                          'Lt Bushing Y Phase Oil'),
                      _builtDTCondDropdown(selectedltBushingYPhaseOil,
                          'Lt Bushing Y Phase', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_ltBushingYPhaseColor,
                          'Lt Bushing Y Phase Color', false),
                      _buildSwitchButton(
                          _ltBushingBPhaseOil,
                          itemSwitchLtBushingBPhaseOil,
                          'Lt Bushing B Phase Oil'),
                      _builtDTCondDropdown(selectedltBushingBPhaseOil,
                          'Lt Bushing B Phase', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_ltBushingBPhaseColor,
                          'Lt Bushing B Phase Color', false),
                      _buildSwitchButton(
                          _ltBushingNPhaseOil,
                          itemSwitchLtBushingNPhaseOil,
                          'Lt Bushing N Phase Oil'),
                      _builtDTCondDropdown(selectedltBushingNPhaseOil,
                          'Lt Bushing N Phase', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_ltBushingNPhaseColor,
                          'Lt Bushing N Phase Color', false),
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
                title: const Text('Wire/Earthing Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Wire/Earthing Information',
                    children: [
                      _buildTextField(
                          _wireSizeofHTDrop, 'Wire Size Of HT Drop', false),
                      _builtDTCondDropdown(selectedconditionofHTDropGoodbsBad,'Condition Of HT Drop', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_wirebsCableSizeofLTDropCKT1,
                          'Wire BS Cable Size Of LT Drop CKT1', false),
                      _builtDTCondDropdown(selectedconditionofLTDropGoodbsBadCKT1,'Condition Of LT Drop CKT1', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_wirebsCableSizeofLTDropCKT2,
                          'Wire BS Cable Size Of LT Drop CKT2', false),
                      _builtDTCondDropdown(selectedconditionofLTDropGoodbsBadCKT2,'Condition Of LT Drop CKT2', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_earthingLead1, 'Earthing Lead 1', false),
                      _buildTextField(
                          _earthingLead1Size, 'Earthing Lead 1 Size', false),
                      _buildTextField(_earthingLead1Material,
                          'Earthing Lead 1 Material', false),
                      _builtDTCondDropdown(selectedearthingLead1ConditionStandard,'Earthing Lead 1 Condition', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_earthingLead2, 'Earthing Lead 2', false),
                      _buildTextField(
                          _earthingLead2Size, 'Earthing Lead 2 Size', false),
                      _buildTextField(_earthingLead2Material,
                          'Earthing Lead 2 Material', false),
                      _builtDTCondDropdown(selectedearthingLead2ConditionStandard,'Earthing Lead 2 Condition', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _buildTextField(_dayPeak, 'Day Peak', false),
                      TextFormField(
                        controller: _dateAndTime1,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          label: RichText(
                            text: const TextSpan(
                              text: "Date And time 1",
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
                          _selectDateTime1(context);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Date and Time 1';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
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
                title: const Text('Phase Current Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Phase Current',
                    children: [
                      _buildTextField(_rPhaseCurrentAmps1Ckt1,
                          'R Phase Current Amps 1 Ckt1', false),
                      _buildTextField(_rPhaseCurrentAmps1Ckt2,
                          'R Phase Current Amps 1 Ckt2', false),
                      _buildTextField(_rPhaseCurrentAmps1Ckt3,
                          'R Phase Current Amps 1 Ckt3', false),
                      _buildTextField(_yPhaseCurrentAmps1Ckt1,
                          'Y Phase Current Amps 1 Ckt1', false),
                      _buildTextField(_yPhaseCurrentAmps1Ckt2,
                          'Y Phase Current Amps 1 Ckt2', false),
                      _buildTextField(_yPhaseCurrentAmps1Ckt3,
                          'Y Phase Current Amps 1 Ckt3', false),
                      _buildTextField(_bPhaseCurrentAmps1Ckt1,
                          'B Phase Current Amps 1 Ckt1', false),
                      _buildTextField(_bPhaseCurrentAmps1Ckt2,
                          'B Phase Current Amps 1 Ckt2', false),
                      _buildTextField(_bPhaseCurrentAmps1Ckt3,
                          'B Phase Current Amps 1 Ckt3', false),
                      _buildTextField(_neutralCurrentAmps1Ckt1,
                          'Neutral Current Amps 1 Ckt1', false),
                      _buildTextField(_neutralCurrentAmps1Ckt2,
                          'Neutral Current Amps 1 Ckt2', false),
                      _buildTextField(_neutralCurrentAmps1Ckt3,
                          'Neutral Current Amps 1 Ckt3', false),
                      _buildTextField(_calculatedDayPeakkVA,
                          'Calculated Evening Peak kVA', false),
                      _buildTextField(_calculatedEveningPeakkVA,
                          'Calculated Day Peak kVA', false),
                      _buildTextField(_eveningPeak, 'Evening Peak', false),
                      TextFormField(
                        controller: _dateAndTime2,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          label: RichText(
                            text: const TextSpan(
                              text: "Date And Time 2",
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
                          _selectDateTime2(context);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Date and Time 1';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
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
                title: const Text('DropOut Fuse Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'DropOut Fuse',
                    children: [
                      _buildSwitchButton(
                          _dropOutFuseExistbsNotExistRphase,
                          itemSwitchDropOutFuseRphase,
                          'Drop Out Fuse Exist/Not Exist R phase'),
                      _buildSwitchButton(
                          _dropOutFuseExistbsNotExistYphase,
                          itemSwitchDropOutFuseYphase,
                          'Drop Out Fuse Exist/Not Exist Y phase'),
                      _buildSwitchButton(
                          _dropOutFuseExistbsNotExistBphase,
                          itemSwitchDropOutFuseBphase,
                          'Drop Out Fuse Exist/Not Exist B phase'),
                      _builtDTCondDropdown(selectedconditionofDropOutFuseRphase,
                          'Condition Of DropOut Fuse Rphase', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _builtDTCondDropdown(selectedconditionofDropOutFuseYphase,
                          'Condition Of DropOut Fuse Yphase', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _builtDTCondDropdown(selectedconditionofDropOutFuseBphase,
                          'Condition Of DropOut Fuse Bphase', deviceFontSize),
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
                title: const Text('Lightning Arrestor Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Lightning Arrestor',
                    children: [
                      _buildSwitchButton(
                          _lightningArrestorRphase,
                          itemSwitchLightningArrestorRphase,
                          'Lightning Arrestor R phase'),
                      _buildSwitchButton(
                          _lightningArrestorYphase,
                          itemSwitchLightningArrestorYphase,
                          'Lightning Arrestor Y phase'),
                      _buildSwitchButton(
                          _lightningArrestorBphase,
                          itemSwitchLightningArrestorBphase,
                          'Lightning Arrestor B phase'),
                      _builtDTCondDropdown(
                          selectedconditionofLightingArrestorRphase,
                          'Condition Of Lightning Arrestor Rphase',
                          deviceFontSize),
                      const SizedBox(height: 16.0),
                      _builtDTCondDropdown(
                          selectedconditionofLightingArrestorYphase,
                          'Condition Of Lightning Arrestor Yphase',
                          deviceFontSize),
                      const SizedBox(height: 16.0),
                      _builtDTCondDropdown(
                          selectedconditionofLightingArrestorBphase,
                          'Condition Of Lightning Arrestor Bphase',
                          deviceFontSize),
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
                title: const Text('Distribution Box Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Distribution Box',
                    children: [
                      _buildSwitchButton(
                          _distributionBoxExistbsnotExist,
                          itemSwitchDistributionBoxExist,
                          'Distribution Box Exist/Not Exist'),
                      _builtDTCondDropdown(selectedconditionofDistributionBox,
                          'Condition Of Distribution Box', deviceFontSize),
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
                title: const Text('MCCB Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'MCCB',
                    children: [
                      _buildTextField(_noOfMCCB, 'No Of MCCB', false),
                      _buildTextField(
                          _manufacturerTypeOriginofMCCBforCircuit1,
                          'Manufacturer Type Origin Of MCCB For Circuit 1',
                          false),
                      _buildTextField(
                          _manufacturerTypeOriginofMCCBforCircuit2,
                          'Manufacturer Type Origin Of MCCB For Circuit 2',
                          false),
                      _buildTextField(
                          _ampereRatingasPerNamePlateofMCCBforCKT1,
                          'Ampere Rating asPer Name Plate Of MCCB For CKT1',
                          false),
                      _buildTextField(
                          _ampereRatingasPerNameplateOfMCCBForCKT2,
                          'Ampere Rating asPer Name Plate Of MCCB For CKT2',
                          false),
                      _builtDTCondDropdown(selectedconditionofMCCBforCircuit1,
                          'Condition Of MCCB for Circuit1', deviceFontSize),
                      const SizedBox(height: 16.0),
                      _builtDTCondDropdown(selectedconditionofMCCBforCircuit2,
                          'Condition Of MCCB for Circuit2', deviceFontSize),
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
                title: const Text('Remarks/Recommendation'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Remarks/Recommendation',
                    children: [
                      TextFormField(
                        controller: _lastMaintenanceDate,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          label: RichText(
                            text: const TextSpan(
                              text: "Last Maintenance Date",
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
                          _selectLastMaintenanceDate(context);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Start Date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _startingDate,
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
                      const SizedBox(height: 16.0),
                      _buildTextField(_recommendation, 'Recommendation', false),
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

                            String formatDate(String? text, String fieldName) {
                              try {
                                return DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                    .format(
                                        DateTime.parse(text ?? dt.toString()));
                              } catch (e) {
                                throw 'Invalid date format for $fieldName';
                              }
                            }

                            T checkNotNull<T>(T? value, String fieldName) {
                              if (value == null || value == '') {
                                throw '$fieldName is Mandatory.';
                              }
                              return value;
                            }

                            T checkNotSelect<T>(T? value, String fieldName) {
                              if (value == null || value == 0.00) {
                                throw 'Please Select $fieldName.';
                              }
                              return value;
                            }

                            final int dtId = await CallDTApi().fetchMaxDTId();
                            DistributionTransformer dtInfo =
                                DistributionTransformer(
                              zoneId: checkNotSelect(selectedZoneId, 'Zone'),
                              circleId:
                                  checkNotSelect(selectedCircleId, 'Circle'),
                              sndId: checkNotSelect(selectedSnDId, 'SnD'),
                              esuId: selectedEsuId,
                              substationId: checkNotSelect(
                                  selectedSubstationId, 'Substation'),
                              feederLineId: checkNotSelect(
                                  selectedFeederLineId, 'Feeder Line'),
                              poleLeftId: null,
                              poleDetailsLeftId: checkNotSelect(selectedPoleDetailLeftId, 'Pole Detail Left Id'),
                              poleDetailsRightId:
                                  selectedPoleDetailRightId ?? 0,
                              id: dtId,
                              distributionTransformerCode: checkNotNull(_dtCode.text, 'DT Code'),
                              dtLocationName: _dtLocationName.text,
                              dtNumber: _dtNumber.text,
                              dtConditionId: selectedDTConditionId,
                              nameOf33Bs11KvSubstation:
                                  _nameOf33Bs11KvSubstation.text,
                              nameof11KvFeeder: _nameof11KvFeeder.text,
                              sndIdentificationNo: _sndIdentificationNo.text,
                              nearestHoldingHouseNoShop:
                                  _nearestHoldingHouseNoShop.text,
                              existingPoleNumberIfAny:
                                  _existingPoleNumberIfAny.text,
                              installedConditionPadPoleMounted:
                                  selectedInstalledConditionId,
                              installedPlaceIndoorOutdoor:
                                  selectedInstalledPlaceId,
                              transformerOwnerId: selectedTransformerOwnerId,
                              transformerKvaRating:
                                  parseOrZeroDouble(_transformerKvaRating.text),
                              contactNo: _contactNo.text,
                              yearOfManufacturing: _yearOfManufacturing.text,
                              nameofManufacturer: _nameofManufacturer.text,
                              transformerSerialNo: _transformerSerialNo.text,
                              bodyColorConditionId: selectedBodyConditionId,
                              nameOfBodyColor: _nameOfBodyColor.text,
                              oilLeakageYesOrNo: _oilLeakageYesOrNo,
                              placeOfOilLeakageMark:
                                  _placeOfOilLeakageMark.text,
                              platformMaterialId: selectedPlatformMaterial,
                              typeofTransformerSupportPoleLeft:
                                  selectedSupportPoleTypeLeft,
                              conditionofTransformerSupportPoleLeft: selectedSupportPoleConditionLeft,
                              typeofTransformerSupportPoleRight:
                                  selectedSupportPoleTypeRight,
                              conditionofTransformerSupportPoleRight:selectedSupportPoleConditionRight,
                              ratedVoltage: _ratedVoltage.text,
                              ratedHtVoltage: _ratedHtVoltage.text,
                              ratedLTVoltage: _ratedLTVoltage.text,
                              ratedHTCurrent: _ratedHTCurrent.text,
                              ratedLTCurrent: _ratedLTCurrent.text,
                              controlVoltage: _controlVoltage.text,
                              motorVoltageforspringcharge:
                                  _motorVoltageforspringcharge.text,
                              voltage1: _voltage1.text,
                              ryVoltageVolt1: _ryVoltageVolt1.text,
                              ybVoltageVolt1: _ybVoltageVolt1.text,
                              rbVoltageVolt1: _rbVoltageVolt1.text,
                              rnVoltageVolt1: _rnVoltageVolt1.text,
                              ynVoltageVolt1: _ynVoltageVolt1.text,
                              bnVoltageVolt1: _bnVoltageVolt1.text,
                              leakageVoltageBodyEarthVolt1:
                                  _leakageVoltageBodyEarthVolt1.text,
                              voltage2: _voltage2.text,
                              ryVoltageVolt2: _ryVoltageVolt2.text,
                              ybVoltageVolt2: _ybVoltageVolt2.text,
                              rbVoltageVolt2: _rbVoltageVolt2.text,
                              htBushingRPhaseOil: _htBushingBPhaseOil,
                              htBushingRPhaseGood:selectedhtBushingRPhaseOil,
                              htBushingRPhaseColor: _htBushingRPhaseColor.text,
                              htBushingYPhaseOil: _htBushingYPhaseOil,
                              htBushingYPhaseGood:selectedhtBushingYPhaseOil,
                              htBushingYPhaseColor: _htBushingYPhaseColor.text,
                              htBushingBPhaseOil: _htBushingBPhaseOil,
                              htBushingBPhaseGood:selectedhtBushingBPhaseOil,
                              htBushingBPhaseColor: _htBushingBPhaseColor.text,
                              htBushingNPhaseOil: _htBushingNPhaseOil,
                              htBushingNPhaseGood:selectedhtBushingNPhaseOil,
                              htBushingNPhaseColor: _htBushingNPhaseColor.text,
                              ltBushingRPhaseOil: _ltBushingRPhaseOil,
                              ltBushingRPhaseGood:selectedltBushingRPhaseOil,
                              ltBushingRPhaseColor: _ltBushingRPhaseColor.text,
                              ltBushingYPhaseOil: _ltBushingYPhaseOil,
                              ltBushingYPhaseGood:selectedltBushingYPhaseOil,
                              ltBushingYPhaseColor: _ltBushingYPhaseColor.text,
                              ltBushingBPhaseOil: _ltBushingBPhaseOil,
                              ltBushingBPhaseGood:selectedltBushingBPhaseOil,
                              ltBushingBPhaseColor: _ltBushingBPhaseColor.text,
                              ltBushingNPhaseOil: _ltBushingNPhaseOil,
                              ltBushingNPhaseGood:selectedltBushingNPhaseOil,
                              ltBushingNPhaseColor: _ltBushingNPhaseColor.text,
                              wireSizeofHTDrop: _wireSizeofHTDrop.text,
                              conditionofHTDropGoodbsBad: selectedconditionofHTDropGoodbsBad,
                              wirebsCableSizeofLTDropCKT1:
                                  _wirebsCableSizeofLTDropCKT1.text,
                              conditionofLTDropGoodbsBadCKT1: selectedconditionofLTDropGoodbsBadCKT1,
                              wirebsCableSizeofLTDropCKT2:
                                  _wirebsCableSizeofLTDropCKT2.text,
                              conditionofLTDropGoodbsBadCKT2: selectedconditionofLTDropGoodbsBadCKT2,
                              earthingLead1: _earthingLead1.text,
                              earthingLead1Size: _earthingLead1Size.text,
                              earthingLead1Material:
                                  _earthingLead1Material.text,
                              earthingLead1ConditionStandard: selectedearthingLead1ConditionStandard,
                              earthingLead2: _earthingLead2.text,
                              earthingLead2Size: _earthingLead2Size.text,
                              earthingLead2Material:
                                  _earthingLead2Material.text,
                              earthingLead2ConditionStandard: selectedearthingLead2ConditionStandard,
                              dayPeak: _dayPeak.text,
                              dateAndtime1: formatDate(_dateAndTime1.text, 'Date And Time 1'),
                              rPhaseCurrentAmps1Ckt1:
                                  _rPhaseCurrentAmps1Ckt1.text,
                              rPhaseCurrentAmps1Ckt2:
                                  _rPhaseCurrentAmps1Ckt2.text,
                              rPhaseCurrentAmps1Ckt3:
                                  _rPhaseCurrentAmps1Ckt3.text,
                              yPhaseCurrentAmps1Ckt1:
                                  _yPhaseCurrentAmps1Ckt1.text,
                              yPhaseCurrentAmps1Ckt2:
                                  _yPhaseCurrentAmps1Ckt2.text,
                              yPhaseCurrentAmps1Ckt3:
                                  _yPhaseCurrentAmps1Ckt3.text,
                              bPhaseCurrentAmps1Ckt1:
                                  _bPhaseCurrentAmps1Ckt1.text,
                              bPhaseCurrentAmps1Ckt2:
                                  _bPhaseCurrentAmps1Ckt2.text,
                              bPhaseCurrentAmps1Ckt3:
                                  _bPhaseCurrentAmps1Ckt3.text,
                              neutralCurrentAmps1Ckt1:
                                  _neutralCurrentAmps1Ckt1.text,
                              neutralCurrentAmps1Ckt2:
                                  _neutralCurrentAmps1Ckt2.text,
                              neutralCurrentAmps1Ckt3:
                                  _neutralCurrentAmps1Ckt3.text,
                              calculatedDayPeakkVA: _calculatedDayPeakkVA.text,
                              calculatedEveningPeakkVA:
                                  _calculatedEveningPeakkVA.text,
                              eveningPeak: _eveningPeak.text,
                              dateAndTime2: formatDate(_dateAndTime2.text, 'Date And Time 2'),
                              dropOutFuseExistbsNotExistRphase:
                                  _dropOutFuseExistbsNotExistRphase,
                              dropOutFuseExistbsNotExistYphase:
                                  _dropOutFuseExistbsNotExistYphase,
                              dropOutFuseExistbsNotExistBphase:
                                  _dropOutFuseExistbsNotExistBphase,
                              conditionofDropOutFuseRphase:
                                  selectedconditionofDropOutFuseRphase,
                              conditionofDropOutFuseYphase:
                                  selectedconditionofDropOutFuseYphase,
                              conditionofDropOutFuseBphase:
                                  selectedconditionofDropOutFuseBphase,
                              lightningArrestorRphase: _lightningArrestorRphase,
                              lightningArrestorYphase: _lightningArrestorYphase,
                              lightningArrestorBphase: _lightningArrestorBphase,
                              conditionofLightingArrestorRphase:
                                  selectedconditionofLightingArrestorRphase,
                              conditionofLightingArrestorYphase:
                                  selectedconditionofLightingArrestorYphase,
                              conditionofLightingArrestorBphase:
                                  selectedconditionofLightingArrestorBphase,
                              distributionBoxExistbsnotExist:
                                  _distributionBoxExistbsnotExist,
                              conditionofDistributionBox:
                                  selectedconditionofDistributionBox,
                              noOfMCCB: parseOrZero(_noOfMCCB.text),
                              manufacturerTypeOriginofMCCBforCircuit1: _manufacturerTypeOriginofMCCBforCircuit1.text,
                              manufacturerTypeOriginofMCCBforCircuit2: _manufacturerTypeOriginofMCCBforCircuit2.text,
                              ampereRatingasPerNamePlateofMCCBforCKT1:
                                      _ampereRatingasPerNamePlateofMCCBforCKT1.text,
                              ampereRatingasPerNameplateOfMCCBForCKT2:_ampereRatingasPerNameplateOfMCCBForCKT2.text,
                              conditionofMCCBforCircuit1:
                                  selectedconditionofMCCBforCircuit1,
                              conditionofMCCBforCircuit2:
                                  selectedconditionofMCCBforCircuit1,
                              recommendation: _recommendation.text,
                              lastMaintenanceDate:
                                  formatDate(_lastMaintenanceDate.text, 'Last Maintainance Date'),
                              startingDate: formatDate(_startingDate.text, 'Start Date'),
                              remarks: _remarks.text,
                              activationStatusId: 2,
                              verificationStateId: 2,
                            );

                            await CallDTApi().createDT(dtInfo);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FilterDTDetails()),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('DT Created Successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (error) {
                            print(error);
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
          ]),
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

  Future<void> _selectDateTime1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateAndTime1.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectDateTime2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateAndTime2.text = DateFormat('yyyy-MM-dd').format(picked);
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
        _startingDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectLastMaintenanceDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startingDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectYearofManufacturing(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        int currentYear = DateTime.now().year;

        return Dialog(
          shape: RoundedRectangleBorder(
            // Set dialog shape to remove unnecessary padding
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            height: 300, // Adjust the height as necessary
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Add padding if needed
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Select Year of Manufacturing',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: YearPicker(
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      initialDate: DateTime.now(),
                      selectedDate: DateTime(currentYear),
                      onChanged: (DateTime dateTime) {
                        Navigator.pop(
                            context, dateTime); // Return the selected year
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    // Set the selected year to the text field
    if (picked != null) {
      setState(() {
        _yearOfManufacturing.text =
            picked.year.toString(); // Display the selected year
      });
    }
  }

  Widget _buildSwitchButton(
      bool value, ValueChanged<bool> function, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 146, 145, 145)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color.fromARGB(255, 100, 97, 97),
                  fontSize: 16.0,
                ),
              ),
              Switch(
                activeColor: Colors.blue,
                value: value,
                onChanged: function,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _builtDTCondDropdown(int? value, String hint, double deviceFontSize) {
    return FutureBuilder<List<DTCondition>>(
      future: fetchDTCondition,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
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
            value: value,
            hint: RichText(
              text: TextSpan(
                text: hint,
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
            items: snapshot.data!.map((dtCondition) {
              return DropdownMenuItem<int>(
                value: dtCondition.id,
                child: Text(dtCondition.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDTConditionId = value;
              });
            },
          );
        } else {
          return const Text('No DT Condition available');
        }
      },
    );
  }
}
