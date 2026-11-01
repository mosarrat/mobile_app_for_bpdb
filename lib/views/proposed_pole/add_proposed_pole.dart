import 'package:bpdb_gis_app/api/feederline_api.dart';
import 'package:bpdb_gis_app/models/regions/feederlinetype.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/api.dart';
import '../../api/pole_api.dart';
import '../../api/proposed_pole_api.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';
import '../../models/pole_lookup/pole_type.dart';
import '../../models/proposed_pole/proposed_pole.dart';
import '../../models/proposed_pole/proposed_pole_sec.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/substation.dart'; // TODO: adjust to your real Substation model path
import '../../models/regions/zone.dart';
import 'location_info.dart';
import 'verify_info.dart';
import 'view_proposed_pole_list.dart';

class AddProposedPole extends StatefulWidget {
  const AddProposedPole({super.key});

  @override
  State<AddProposedPole> createState() => _AddProposedPoleState();
}

class _AddProposedPoleState extends State<AddProposedPole> {
  int _currentStep = 0;
  final List<String> _stepTitles = ['Propose', 'Location', 'Verify & Submit'];
  late double deviceFontSize;
  bool isLoading = false;
  bool isReadOnly = false;
  bool isFeederLineDropdownEnabled = true;

  // ---------- lookups ----------
  late Future<List<PoleType>> fetchPoleType;
  late Future<List<FeederLineType>> feederlinetype;

  // ---------- hierarchy: Zone > Circle > SnD > Substation > Feeder ----------
  late Future<List<Zone>> zones;
  Future<List<Circles>> circles = Future.value([]);
  Future<List<SndInfo>> snds = Future.value([]);
  Future<List<Substation>> substations = Future.value([]);
  Future<List<FeederLine>> feederLines = Future.value([]);

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSndId;
  int? selectedSubstationId;
  int? selectedFeederLineId;
  String? selectedSndName;
  String nextSectionNo = '';

  // ---------- form fields ----------
  final TextEditingController pole_no = TextEditingController();
  final TextEditingController area = TextEditingController();
  final TextEditingController pole_height = TextEditingController();
  final TextEditingController dt_rating = TextEditingController();
  final TextEditingController comment = TextEditingController();
  final TextEditingController latitude = TextEditingController();
  final TextEditingController longitude = TextEditingController();
  int? selectedPoleTypeId;
  int? selectedFeederlineTypeId;
  User? user = globalUser;
  final todayDateOnly = DateFormat('yyyy').format(DateTime.now());
  int poleExt = 0;
  PoleSection? _poleSectionData;
  final List<ProposedPole> _proposedPoles = [];
  bool dt_exist = false;

  String get _sndName => selectedSndName ?? user?.SnDName ?? '';

  @override
  void initState() {
    super.initState();
    fetchPoleType = CallPoleApi().fetchPoleType();
    feederlinetype = CallApiService().fetchFeederLineTypeInfo();

    selectedZoneId = user?.ZoneId;
    selectedCircleId = user?.CircleId;
    selectedSndId = user?.SndId;

    // Only fetch the levels the user actually has to choose.
    zones = user?.ZoneId == null ? CallApi().fetchZoneInfo() : Future.value([]);
    if (selectedZoneId != null && user?.CircleId == null) {
      circles = CallApi().fetchCircleInfo(selectedZoneId!);
    }
    if (selectedCircleId != null && user?.SndId == null) {
      snds = CallApi().fetchSnDInfo(selectedCircleId!);
    }
    if (selectedSndId != null) {
      _loadSndDependents(selectedSndId!);
    }
  }

  // ------------------------------------------------------------------
  // Cascade handlers
  // ------------------------------------------------------------------
  void _onZoneChanged(int? v) {
    setState(() {
      selectedZoneId = v;
      selectedCircleId = null;
      selectedSndId = null;
      selectedSndName = null;
      selectedSubstationId = null;
      selectedFeederLineId = null;
      circles = v == null ? Future.value([]) : CallApi().fetchCircleInfo(v);
      snds = Future.value([]);
      substations = Future.value([]);
      feederLines = Future.value([]);
      pole_no.clear();
      nextSectionNo = '';
    });
  }

  void _onCircleChanged(int? v) {
    setState(() {
      selectedCircleId = v;
      selectedSndId = null;
      selectedSndName = null;
      selectedSubstationId = null;
      selectedFeederLineId = null;
      snds = v == null ? Future.value([]) : CallApi().fetchSnDInfo(v);
      substations = Future.value([]);
      feederLines = Future.value([]);
      pole_no.clear();
      nextSectionNo = '';
    });
  }

  void _onSndChanged(int? v, List<SndInfo> list) {
    if (v == null) return;
    setState(() {
      selectedSndId = v;
      selectedSndName = list.firstWhere((s) => s.sndId == v).snDName;
      _loadSndDependents(v);
    });
  }

  void _onSubstationChanged(int? v) {
    setState(() {
      selectedSubstationId = v;
      _loadFeeders();
    });
  }

  void _loadSndDependents(int sndId) {
    selectedSubstationId = null;
    substations = CallApi().fetchSubstationInfo(sndId); // TODO: placeholder API
    _loadFeeders();
    _loadNextNumbers(sndId);
  }

  void _loadFeeders() {
    selectedFeederLineId = null;
    final api = CallProposedPoleApi();
    if (user?.EsuId != null) {
      feederLines = api.fetchFeederLineByEsu(user!.EsuId!);
    } else if (selectedSubstationId != null) {
      // TODO: placeholder API
      feederLines = CallApi().fetchFeederLineInfo(selectedSubstationId!);
    } else {
      feederLines = api.fetchFeederLineBySnD(selectedSndId ?? 0);
    }
  }

  Future<void> _loadNextNumbers(int sndId) async {
    try {
      final pole = await CallProposedPoleApi().fetchNextPoleBySnD(sndId);
      final sec = await CallProposedPoleApi().fetchNextSecBySnD(sndId);
      if (!mounted) return;
      setState(() {
        pole_no.text = pole.nextPoleNo;
        poleExt = int.tryParse(pole.nextPoleNo) ?? 0;
        nextSectionNo = '${sec.nextNumber}';
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load next pole number: $e')),
      );
    }
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void itemSwitchDtExist(bool value) {
    setState(() {
      dt_exist = value;
    });
  }

  // ------------------------------------------------------------------
  // Reusable hierarchy dropdown
  // ------------------------------------------------------------------
  Widget _hierarchyDropdown<T>({
    required String label,
    required Future<List<T>> future,
    required int? value,
    required int? Function(T) idOf,
    required String Function(T) nameOf,
    required void Function(int?, List<T>) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FutureBuilder<List<T>>(
        future: future,
        builder: (context, snapshot) {
          final data = snapshot.data ?? <T>[];
          final valid = data.where((e) => idOf(e) != null).toList();
          final ids = valid.map((e) => idOf(e)!).toSet();
          return DropdownButtonFormField<int>(
            isExpanded: true,
            value: ids.contains(value) ? value : null,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.blue,
                fontSize: deviceFontSize + 3,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            hint: Text('Select $label'),
            items: valid
                .map((e) => DropdownMenuItem<int>(
                      value: idOf(e)!,
                      child: Text(nameOf(e)),
                    ))
                .toList(),
            onChanged: isFeederLineDropdownEnabled
                ? (v) => onChanged(v, data)
                : null,
          );
        },
      ),
    );
  }

  Widget _buildGeneralInfoForm() {
    final adminInfo = [
      user?.ZoneName,
      user?.CircleName,
      user?.SnDName,
      user?.EsuName,
    ].where((e) => e != null && e.isNotEmpty).join(' | ');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Proposed Pole Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Divider(color: Color.fromARGB(255, 5, 161, 182)),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                //contentPadding: const EdgeInsets.all(15),
                title: const Text(
                  "Administrative Information",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: adminInfo.isNotEmpty
                    ? Text(
                        adminInfo,
                        style: const TextStyle(height: 1.5),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // ---- Zone > Circle > SnD > Substation (shown by user level) ----
            if (user?.ZoneId == null)
              _hierarchyDropdown<Zone>(
                label: 'Zone',
                future: zones,
                value: selectedZoneId,
                idOf: (z) => z.zoneId,
                nameOf: (z) => z.zoneName,
                onChanged: (v, _) => _onZoneChanged(v),
              ),
            if (user?.CircleId == null)
              _hierarchyDropdown<Circles>(
                label: 'Circle',
                future: circles,
                value: selectedCircleId,
                idOf: (c) => c.circleId,
                nameOf: (c) => c.circleName ?? '',
                onChanged: (v, _) => _onCircleChanged(v),
              ),
            if (user?.SndId == null)
              _hierarchyDropdown<SndInfo>(
                label: 'SnD',
                future: snds,
                value: selectedSndId,
                idOf: (s) => s.sndId,
                nameOf: (s) => s.snDName ?? '',
                onChanged: (v, list) => _onSndChanged(v, list),
              ),
            if (user?.EsuId == null)
              _hierarchyDropdown<Substation>(
                label: 'Substation',
                future: substations,
                value: selectedSubstationId,
                idOf: (s) => s.substationId,
                nameOf: (s) => s.substationName ?? '',
                onChanged: (v, _) => _onSubstationChanged(v),
              ),

            // ---- Voltage level ----
            FutureBuilder<List<FeederLineType>>(
              future: feederlinetype,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.blue,
                        fontSize: deviceFontSize + 3,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    value: selectedFeederlineTypeId,
                    hint: const Text('Select a Volage Level'),
                    items: snapshot.data!.map((t) {
                      return DropdownMenuItem<int>(
                        value: t.feederLineTypeId,
                        child: Text(t.feederLineTypeName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFeederlineTypeId = value;
                      });
                    },
                  );
                } else {
                  return const Text('No Feeder Line Type available');
                }
              },
            ),
            const SizedBox(height: 16.0),

            // ---- Feeder line ----
            FutureBuilder<List<FeederLine>>(
              future: feederLines,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(selectedSndId == null
                      ? 'Select an SnD to load feeder lines'
                      : 'No Feeder Lines available');
                }

                final ids =
                    snapshot.data!.map((f) => f.feederLineId).toSet();

                return DropdownButtonFormField<int>(
                  isExpanded: true,
                  value: ids.contains(selectedFeederLineId)
                      ? selectedFeederLineId
                      : null,
                  decoration: InputDecoration(
                    labelText: "Feeder Line",
                    labelStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: deviceFontSize + 3,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  hint: RichText(
                    text: const TextSpan(
                      text: 'Select a Feeder Line',
                      style: TextStyle(
                        color: Color.fromARGB(255, 100, 97, 97),
                        fontSize: 16.0,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  disabledHint: selectedFeederLineId != null
                      ? Text(
                          snapshot.data!
                                  .firstWhere((f) =>
                                      f.feederLineId == selectedFeederLineId)
                                  .feederlineName ??
                              '',
                          style: const TextStyle(color: Colors.black),
                        )
                      : const Text('Feeder Line locked'),
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
                  onChanged: isFeederLineDropdownEnabled
                      ? (value) {
                          setState(() {
                            selectedFeederLineId = value;
                          });
                        }
                      : null,
                );
              },
            ),
            const SizedBox(height: 16.0),

            // ---- Pole no ----
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                readOnly: true,
                controller: pole_no,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 241, 239, 239),
                  label: RichText(
                    text: const TextSpan(
                      text: 'Pole No',
                      style: TextStyle(
                        color: Color.fromARGB(255, 78, 75, 75),
                        fontSize: 16.0,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            _buildTextField(pole_height, 'Pole Height', false),

            // ---- Pole type ----
            FutureBuilder<List<PoleType>>(
              future: fetchPoleType,
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
                    value: selectedPoleTypeId,
                    hint: RichText(
                      text: const TextSpan(
                        text: 'Select a Pole Type',
                        style: TextStyle(
                          color: Color.fromARGB(255, 100, 97, 97),
                          fontSize: 16.0,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    items: snapshot.data!.map((poleType) {
                      return DropdownMenuItem<int>(
                        value: poleType.poleTypeId,
                        child: Text('${poleType.poleTypeName}'),
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

            // ---- DT exist ----
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'DT Exist',
                          style: TextStyle(
                            color: Color.fromARGB(255, 100, 97, 97),
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Switch(
                        activeColor: Colors.blue,
                        value: dt_exist,
                        onChanged: (value) {
                          itemSwitchDtExist(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (dt_exist) _buildTextField(dt_rating, 'DT Rating', false),
            _buildTextField(area, 'Area Name', true),
            _buildTextField(comment, 'Comment', false),
          ],
        ),
      ),
    );
  }

  Widget _buildStepPage(int step) {
    switch (step) {
      case 0:
        return _buildGeneralInfoForm();
      case 1:
        return MapLocationSection(
          latitude: latitude,
          longitude: longitude,
          area: area,
          buildTextField: _buildTextField,
          onLocationSelected: (lat, lng) {
            if (_proposedPoles.isNotEmpty) {
              _proposedPoles.last.latitude = lat;
              _proposedPoles.last.longitude = lng;
            }
          },
          proposedPole: _proposedPoles,
        );
      case 2:
        return VerificationSection(
            proposedPole: _proposedPoles, poleSectionData: _poleSectionData);
      default:
        return const Center(child: Text("Unknown Step"));
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Proposed Pole",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 8, 123, 143),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  _buildStepIndicator(),
                  const Divider(height: 1, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildStepPage(_currentStep),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_currentStep == 2)
                          Card(
                            color: const Color.fromARGB(255, 5, 161, 182),
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: TextButton(
                              child: const Text(
                                'Next Pole',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                setState(() {
                                  _currentStep = 0;
                                  poleExt++;
                                  pole_no.text =
                                      poleExt.toString().padLeft(3, '0');
                                  pole_height.clear();
                                  latitude.clear();
                                  longitude.clear();
                                  selectedPoleTypeId = null;
                                  // lock Zone/Circle/SnD/Substation/Feeder so
                                  // all poles stay in the same section
                                  isFeederLineDropdownEnabled = false;
                                });
                              },
                            ),
                          ),
                        Card(
                          color: const Color.fromARGB(255, 5, 161, 182),
                          margin: const EdgeInsets.only(right: 10, bottom: 10),
                          child: TextButton(
                            child: Text(
                              _currentStep == 0
                                  ? "Select Location"
                                  : _currentStep == 1
                                      ? "Confirm Location"
                                      : "Finish & Submit",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if (_currentStep == 0) {
                                if (selectedPoleTypeId == null ||
                                    selectedSndId == null ||
                                    selectedFeederLineId == null ||
                                    pole_no.text.isEmpty ||
                                    area.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please fill all required fields.')),
                                  );
                                  return;
                                }
                                _poleSectionData ??= PoleSection(
                                  zoneId: selectedZoneId,
                                  circleId: selectedCircleId,
                                  sndId: selectedSndId,
                                  esuId: user?.EsuId,
                                  feederLineId: selectedFeederLineId,
                                  sectionName:
                                      '${_sndName}_${todayDateOnly}_$nextSectionNo',
                                  surveyDate: DateTime.now(),
                                  areaName: area.text,
                                  dtExist: dt_exist,
                                  dtRating: dt_exist ? dt_rating.text : null,
                                  voltLavel: selectedFeederlineTypeId,
                                );
                                ProposedPole proposedPole = ProposedPole(
                                  poleNo: pole_no.text,
                                  poleHeight: double.tryParse(pole_height.text),
                                  poleTypeId: selectedPoleTypeId,
                                  areaName: area.text,
                                  remarks: comment.text,
                                  latitude: double.tryParse(latitude.text),
                                  longitude: double.tryParse(longitude.text),
                                  activationStatusId: 2,
                                );
                                _proposedPoles.add(proposedPole);
                                isReadOnly = true;
                              }
                              if (_currentStep < _stepTitles.length - 1) {
                                setState(() {
                                  _currentStep++;
                                });
                              } else {
                                setLoading(true);
                                CallProposedPoleApi()
                                    .addProposedPole(
                                        _proposedPoles, _poleSectionData!)
                                    .then((value) {
                                  setLoading(false);
                                  if (value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewProposedPole()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Failed to add pole.')),
                                    );
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _stepTitles.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isActive = index == _currentStep;

          return Column(
            children: [
              CircleAvatar(
                radius: isActive ? 18 : 15,
                backgroundColor: isActive
                    ? const Color.fromARGB(255, 5, 161, 182)
                    : Colors.grey.shade400,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          );
        }).toList(),
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
                    style: TextStyle(color: Colors.red),
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