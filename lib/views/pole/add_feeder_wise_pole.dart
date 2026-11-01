import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../api/pole_api.dart';
import '../../models/pole_lookup/feederwise_pole_data.dart';
import '../../models/pole_lookup/line_type.dart';
import '../../models/pole_lookup/sag_condition.dart';
import '../../models/pole_lookup/wire_condition.dart';
import '../../models/pole_lookup/wire_type.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/substation.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';

class AddFeederWisePole extends StatefulWidget {
  final int index;
  final int zoneId;
  final int circleId;
  final int sndId;
  final int esuId;
  final int poleId;
  final FeederWireFormData data;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final ValueChanged<FeederWireFormData> onChanged;

  const AddFeederWisePole({
    super.key,
    required this.zoneId,
    required this.circleId,
    required this.sndId,
    required this.esuId,
    required this.poleId,
    required this.index,
    required this.data,
    required this.onAdd,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<AddFeederWisePole> createState() => _AddFeederWisePoleState();
}

class _AddFeederWisePoleState extends State<AddFeederWisePole> {
  final TextEditingController _feederLineUid = TextEditingController();
  final TextEditingController _feederWiseSerialNo = TextEditingController();
  final TextEditingController _poleId = TextEditingController();
  final TextEditingController _poleDetailedId = TextEditingController();
  final TextEditingController _poleCode = TextEditingController();
  final TextEditingController _poleUid = TextEditingController();
  final TextEditingController _poleUniqueCode = TextEditingController();
  final TextEditingController _poleNo = TextEditingController();
  final TextEditingController _previousPoleNo = TextEditingController();
  final TextEditingController _backSpan = TextEditingController();
  final TextEditingController _wireLength = TextEditingController();

  late Future<List<Substation>> substations;
  late Future<List<FeederLine>> feederLines;
  late Future<List<LineType>> fetchLineType;
  late Future<List<WireType>> fetchWireType;
  late Future<List<WireCondition>> fetchWireCondition;
  late Future<List<SagCondition>> fetchSagCondition;

  int? selectedSubstationId;
  int? selectedFeederLineId;
  int? selectedLineTypeId;
  int? selectedWireTypeId;
  int? selectedWireConditionId;
  String? selectedPhaseAId;
  String? selectedPhaseBId;
  String? selectedPhaseCId;

  var dt = DateTime.now(); 
  bool isLoading = false;
  bool _isneutral = false;
  bool _isRightPole = false;
  String feederLineCode = '';

  void itemSwitchNeutral(bool value) {
    setState(() {
      _isneutral = value;
    });

    widget.data.neutral = value; 
    widget.onChanged(widget.data);
  }

  void itemSwitchIsRightPole(bool value) {
    setState(() {
      _isRightPole = value;
    });

    widget.data.isRightPole = value; 
    widget.onChanged(widget.data); 
  }

  Future<void> _loadPoleDetailsId() async {
    try {
      final int maxId = await CallPoleApi().fetchMaxPoleDetailId();
      setState(() {
        widget.data.poleDetailsId = maxId;
        _poleDetailedId.text = maxId.toString();
      });
    } catch (e) {
      debugPrint("Error loading poleDetailsId: $e");
    }
  }
  @override
  void initState() {
    super.initState();
    widget.data.zoneId = widget.zoneId;
    widget.data.circleId = widget.circleId;
    widget.data.sndId = widget.sndId;
    widget.data.esuId = widget.esuId;
    widget.data.poleId = widget.poleId;
    //widget.data.poleDetailsId = widget.poleId;
    _feederLineUid.text = widget.data.feederLineUid ?? '';
    _feederWiseSerialNo.text = widget.data.feederWiseSerialNo?.toString() ?? '';
    _poleDetailedId.text = widget.data.poleDetailsId?.toString() ?? '';
    _poleCode.text = widget.data.poleCode ?? '';
    _poleUid.text = widget.data.poleUid ?? '';
    _poleUniqueCode.text = widget.data.poleUniqueCode ?? '';
    _poleNo.text = widget.data.poleNo ?? '';
    _previousPoleNo.text = widget.data.previousPoleNo ?? '';
    _backSpan.text = widget.data.backSpan ?? '';
    _wireLength.text = widget.data.wireLength?.toString() ?? '';
    _isneutral = widget.data.neutral ?? false;
    _isRightPole = widget.data.isRightPole ?? false;
    
    selectedSubstationId = widget.data.substationId;
    selectedFeederLineId = widget.data.feederLineId;
    selectedLineTypeId = widget.data.lineTypeId;
    selectedWireTypeId = widget.data.typeOfWireId;
    selectedWireConditionId = widget.data.wireConditionId;
    selectedPhaseAId = widget.data.phaseAId;
    selectedPhaseBId = widget.data.phaseBId;
    selectedPhaseCId = widget.data.phaseCId;

    
    substations = CallApi().fetchSubstationInfo(widget.sndId);
    feederLines = Future.value([]);
    fetchLineType = CallPoleApi().fetchLineType();
    fetchWireType = CallPoleApi().fetchWireType();
    fetchWireCondition = CallPoleApi().fetchWireCondition();
    fetchSagCondition = CallPoleApi().fetchSagCondition();
    // ✅ async call AFTER init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPoleDetailsId();
    });
  }
  

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void onSubstationChanged(int? value) {
    setLoading(true);
    selectedSubstationId = value;
    selectedFeederLineId = null;
    feederLines = CallApi().fetchFeederLineInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  Future<void> onFeederLineChanged(int? value) async {
    setLoading(true);

    selectedFeederLineId = value;
    print('Selected Feeder Line ID: $selectedFeederLineId');

    final int maxPoleNo =
        await CallPoleApi().fetchMaxPoleNo(selectedFeederLineId!);

    // Set controller values
    _previousPoleNo.text = maxPoleNo.toString();
    _poleNo.text = (maxPoleNo + 1).toString();

    // ✅ Update model
    widget.data.previousPoleNo = maxPoleNo.toString();
    widget.data.poleNo = (maxPoleNo + 1).toString();

    // ✅ Generate pole code automatically
    GeneratePoleCode(_poleNo.text);

    // ✅ Notify parent
    widget.onChanged(widget.data);
  }

  void GeneratePoleCode(String PoleNo) {
    String poleCode = '${feederLineCode}${PoleNo}';
    _poleCode.text = poleCode;
    widget.data.poleCode = poleCode;
    widget.onChanged(widget.data);
  }


  @override
  void dispose() {
    _wireLength.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //////////---- Addministration Fieldset ----//////////
            // Text('Feeder Wise Pole Information #${widget.index + 1}',
            // style: TextStyle(
            //   fontSize: deviceFontSize + 2,
            //   fontWeight: FontWeight.bold,
            //   color: const Color.fromARGB(255, 5, 161, 182),
            // )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Pole Details Information #${widget.index + 1}',
                  style: TextStyle(
                    fontSize: deviceFontSize + 2,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 5, 161, 182),
                  ),
                ),

                if (widget.index > 0)
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: widget.onRemove,
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
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
                                  child: Text(
                                      substation.substationName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSubstationId = value;
                                  widget.data.substationId = value;
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
                              onChanged: (value) async {
                                setState(() {
                                  selectedFeederLineId = value;
                                  widget.data.feederLineId = value;
                                  feederLineCode = snapshot.data!
                                      .firstWhere((feeder) =>
                                          feeder.feederLineId == value)
                                      .feederLineCode!;
                                });
                                await onFeederLineChanged(value);
                              },
                            );
                          } else {
                            return const Text('No feeder line available!');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      /*
                      _buildTextField(
                        _feederLineUid,
                        'Feeder Line UId',
                        false,
                        onChanged: (value) {
                          widget.data.feederLineUid  = value;
                          widget.onChanged(widget.data);
                        },
                      ),
                      _buildTextField(
                        _feederWiseSerialNo,
                        'Feeder Wise Serial No',
                        false,
                        onChanged: (value) {
                          final parsedValue = int.tryParse(value);
                          widget.data.feederWiseSerialNo = parsedValue;
                          widget.onChanged(widget.data);
                        },
                      ),
                      */
                    ],
                  ),
                ],
              ),
            ),
            //////////---- Addministration Fieldset ----//////////
            
            //////////---- Pole Fieldset ----//////////
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
                      _buildTextField(
                        _poleNo,
                        'Pole No (Ex - 111, 112, etc...)',
                        true,
                        onChanged: (value) {
                          widget.data.poleNo = value;
                          widget.onChanged(widget.data);
                          GeneratePoleCode(value);
                        },
                      ),

                      _buildTextField(
                        _previousPoleNo,
                        'Previous Pole No',
                        true,
                        onChanged: (value) {
                          widget.data.previousPoleNo = value;
                          widget.onChanged(widget.data);
                        },
                      ),

                      // _buildTextField(
                      //   _poleCode,
                      //   'Pole Code',
                      //   true,
                      //   onChanged: (value) {
                      //     widget.data.poleCode = value;
                      //     widget.onChanged(widget.data);
                      //   },
                      // ),

                      ///
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _poleCode,
                          onChanged: (value) {
                            widget.data.poleCode = value;
                            widget.onChanged(widget.data);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 241, 239, 239),
                            label: RichText(
                              text: const TextSpan(
                                text: 'Pole Code',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 78, 75, 75),
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      ///
                      /*
                      _buildTextField(
                        _poleUid,
                        'Pole UId',
                        false,
                        onChanged: (value) {
                          widget.data.poleUid = value;
                          widget.onChanged(widget.data);
                        },
                      ),
                      _buildTextField(
                        _poleUniqueCode,
                        'Pole Unique Code',
                        false,
                        onChanged: (value) {
                          widget.data.poleUniqueCode = value;
                          widget.onChanged(widget.data);
                        },
                      ),
                      */
                      FutureBuilder<List<LineType>>(
                        future: fetchLineType,
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
                              value: selectedLineTypeId,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Line Type',
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
                              items: snapshot.data!.map((lineType) {
                                return DropdownMenuItem<int>(
                                  value: lineType.lineTypeId,
                                  child: Text(
                                      lineType.lineTypeName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedLineTypeId = value;
                                  widget.data.lineTypeId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Line Type available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // _buildTextField(
                      //   _backSpan,
                      //   'Back Span',
                      //   false,
                      //   onChanged: (value) {
                      //     widget.data.backSpan = value;
                      //     widget.onChanged(widget.data);
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            //////////---- Pole Fieldset ----//////////
            
            //////////---- Wire Fieldset ----//////////
            Theme(
              data: ThemeData().copyWith(
                dividerColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: ExpansionTile(
                ////minTileHeight: 25,
                collapsedBackgroundColor:
                    const Color.fromARGB(255, 223, 240, 243),
                title: const Text('Wire Information'),
                childrenPadding: EdgeInsets.zero,
                textColor: const Color.fromARGB(255, 5, 161, 182),
                children: [
                  FieldsetLegend(
                    legendText: 'Wire Information',
                    children: [
                      _buildTextField(
                        _wireLength,
                        'Wire Length (m)',
                        false,
                        onChanged: (value) {
                          widget.data.wireLength = double.tryParse(value);
                          widget.onChanged(widget.data);
                        },
                      ),
                      FutureBuilder<List<WireType>>(
                        future: fetchWireType,
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
                              value: selectedWireTypeId,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Wire Type',
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
                              items: snapshot.data!.map((wireType) {
                                return DropdownMenuItem<int>(
                                  value: wireType.id,
                                  child: Text(
                                      wireType.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedWireTypeId = value;
                                  widget.data.typeOfWireId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Wire Type available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<WireCondition>>(
                        future: fetchWireCondition,
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
                              value: selectedWireConditionId,
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Wire Condition',
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
                              items: snapshot.data!.map((wirecondition) {
                                return DropdownMenuItem<int>(
                                  value: wirecondition.id,
                                  child: Text(
                                      wirecondition.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedWireConditionId = value;
                                  widget.data.wireConditionId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Wire Condition available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<SagCondition>>(
                        future: fetchSagCondition,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<String>(
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
                              value: selectedPhaseAId,
                              // hint: const Text('Select a Phase A'),
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Phase A',
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
                              items: snapshot.data!.map((sagCondition) {
                                return DropdownMenuItem<String>(
                                  value: sagCondition.id,
                                  child: Text(
                                      sagCondition.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedPhaseAId = value;
                                  widget.data.phaseAId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Sag Condition available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<SagCondition>>(
                        future: fetchSagCondition,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<String>(
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
                              value: selectedPhaseBId,
                              // hint: const Text('Select a Phase B'),
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Phase B',
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
                              items: snapshot.data!.map((sagCondition) {
                                return DropdownMenuItem<String>(
                                  value: sagCondition.id,
                                  child: Text(
                                      sagCondition.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedPhaseBId = value;
                                  widget.data.phaseBId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Sag Condition available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<SagCondition>>(
                        future: fetchSagCondition,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            return DropdownButtonFormField<String>(
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
                              value: selectedPhaseCId,
                              // hint: const Text('Select a Phase C'),
                              hint: RichText(
                                text: const TextSpan(
                                  text: 'Select a Phase C',
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
                              items: snapshot.data!.map((sagCondition) {
                                return DropdownMenuItem<String>(
                                  value: sagCondition.id,
                                  child: Text(
                                      sagCondition.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedPhaseCId = value;
                                  widget.data.phaseCId = value;
                                });
                              },
                            );
                          } else {
                            return const Text('No Sag Condition available');
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
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
                                    text: 'Is Neutral',
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
                                  activeColor: Colors.blue,
                                  value: _isneutral,
                                  onChanged: itemSwitchNeutral,
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
                                    text: 'Is Right Pole',
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
                                  activeColor: Colors.blue,
                                  value: _isRightPole,
                                  onChanged: itemSwitchIsRightPole,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
            //////////---- Wire Fieldset ----//////////
            
          ],
        ),
      ),
    );
  }

Widget _buildTextField(
  TextEditingController controller,
  String label,
  bool mandatory, {
  ValueChanged<String>? onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: TextFormField(
      controller: controller,
      onChanged: onChanged, // ✅ delegate handling
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