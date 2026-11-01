import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api/api.dart';
import '../../api/pole_api.dart';
import '../../api/region_api.dart';
import '../../models/pole_lookup/add_poledetails.dart';
import '../../models/pole_lookup/line_type.dart';
import '../../models/pole_lookup/sag_condition.dart';
import '../../models/pole_lookup/wire_condition.dart';
import '../../models/pole_lookup/wire_type.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/substation.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';
import 'filter_pole_detail.dart';

class AddPoleDetails extends StatefulWidget {
  final int zoneId;
  final int circleId;
  final int sndId;
  final int esuId;
  final int poleId;

  const AddPoleDetails({
    super.key,
    required this.zoneId,
    required this.circleId,
    required this.sndId,
    required this.esuId,
    required this.poleId,
  });

  @override
  State<AddPoleDetails> createState() => _AddPoleDetailsState();
}

class _AddPoleDetailsState extends State<AddPoleDetails> {
  final _formKey = GlobalKey<FormState>();

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

  var dt = DateTime.now(); // Date-Time
  bool isLoading = false;

  final TextEditingController _feederLineUid = TextEditingController();
  final TextEditingController _feederWiseSerialNo = TextEditingController();
  final TextEditingController _poleId = TextEditingController();
  final TextEditingController _poleCode = TextEditingController();
  final TextEditingController _poleUid = TextEditingController();
  final TextEditingController _poleUniqueCode = TextEditingController();
  final TextEditingController _poleNo = TextEditingController();
  final TextEditingController _previousPoleNo = TextEditingController();
  final TextEditingController _backSpan = TextEditingController();
  final TextEditingController _wireLength = TextEditingController();

  bool _isneutral = false;
  bool _isRightPole = false;
  void itemSwitchNeutral(bool value) {
    setState(() {
      _isneutral = !_isneutral;
    });
  }

  void itemSwitchIsRightPole(bool value) {
    setState(() {
      _isRightPole = !_isRightPole;
    });
  }

  @override
  void initState() {
    super.initState();
    _poleId.text = widget.poleId.toString();
    substations = CallApi().fetchSubstationInfo(widget.sndId);
    feederLines = Future.value([]);

    fetchLineType = CallPoleApi().fetchLineType();
    fetchWireType = CallPoleApi().fetchWireType();
    fetchWireCondition = CallPoleApi().fetchWireCondition();
    fetchSagCondition = CallPoleApi().fetchSagCondition();

    //   Fluttertoast.showToast(
    //   msg: '${widget.esuId}',
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.CENTER,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.red,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
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
            'New Pole Details Info',
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
                                        '${feeder.feederLineCode}: ${feeder.feederlineName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedFeederLineId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No feeder line available!');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(
                            _feederLineUid, 'Feeder Line UId', false),
                        _buildTextField(_feederWiseSerialNo,
                            'Feeder Wise Serial No', false),
                      ],
                    ),
                  ],
                ),
              ),
              ////////////////////////////////////////////////////////////////////////////

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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: _poleId,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:  Color.fromARGB(255, 241, 239, 239),
                              
                              label: RichText(
                                text: const TextSpan(
                                  text: 'Pole Id',
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
                        _buildTextField(_poleCode, 'Pole Code', true),
                        _buildTextField(_poleUid, 'Pole UId', false),
                        _buildTextField(
                            _poleUniqueCode, 'Pole Unique Code', false),
                        _buildTextField(_poleNo, 'Pole No', false),
                        _buildTextField(
                            _previousPoleNo, 'Previous Pole No', false),
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
                                        '${lineType.lineTypeId}: ${lineType.lineTypeName}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedLineTypeId = value;
                                  });
                                },
                              );
                            } else {
                              return const Text('No Line Type available');
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        _buildTextField(_backSpan, 'Back Span', false),
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
                  title: const Text('Wire Information'),
                  childrenPadding: EdgeInsets.zero,
                  textColor: const Color.fromARGB(255, 5, 161, 182),
                  children: [
                    FieldsetLegend(
                      legendText: 'Wire Information',
                      children: [
                        _buildTextField(_wireLength, 'Wire Length', false),
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
                                        '${wireType.id}: ${wireType.name}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedWireTypeId = value;
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
                                        '${wirecondition.id}: ${wirecondition.name}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedWireConditionId = value;
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
                                        '${sagCondition.id}: ${sagCondition.name}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPhaseAId = value;
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
                                        '${sagCondition.id}: ${sagCondition.name}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPhaseBId = value;
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
                                        '${sagCondition.id}: ${sagCondition.name}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPhaseCId = value;
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
                        //Radio Button
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  // Fetch the max poleDetailId
                                  final int poleDetailId = await CallPoleApi()
                                      .fetchMaxPoleDetailId();
                                  int parseOrZero(String? text) {
                                    try {
                                      return int.tryParse(text?.trim() ?? '') ??
                                          0;
                                    } catch (e) {
                                      throw 'Invalid integer for field $text';
                                    }
                                  }

                                  double parseOrZeroDouble(String? text) {
                                    try {
                                      return double.tryParse(
                                              text?.trim() ?? '') ??
                                          0.0;
                                    } catch (e) {
                                      throw 'Invalid double for field $text';
                                    }
                                  }

                                  T checkNotNull<T>(
                                      T? value, String fieldName) {
                                    if (value == null || value == 0.00) {
                                      throw 'Invalid value for $fieldName. PLease Check Again ';
                                    }
                                    return value;
                                  }

                                  T checkNotSelect<T>(
                                      T? value, String fieldName) {
                                    if (value == null || value == 0.00) {
                                      throw 'Please Select $fieldName.';
                                    }
                                    return value;
                                  }

                                  PoleDetailInfo poleDetailInfo =
                                      PoleDetailInfo(
                                    zoneId: widget.zoneId,
                                    circleId: widget.circleId,
                                    sndId: widget.sndId,
                                    esuId: widget.esuId,
                                    substationId: checkNotSelect(
                                        selectedSubstationId, 'Substaion'),
                                    feederLineId: checkNotSelect(
                                        selectedFeederLineId, 'Feeder Line'),
                                    feederLineUid: _feederLineUid.text,
                                    feederWiseSerialNo:
                                        parseOrZero(_feederWiseSerialNo.text),
                                    poleId: parseOrZero(_poleId.text),
                                    poleDetailsId: poleDetailId,
                                    poleCode: checkNotNull(
                                        _poleCode.text, 'Pole Code'),
                                    poleUid: _poleUid.text,
                                    poleUniqueCode: _poleUniqueCode.text,
                                    poleNo: _poleNo.text,
                                    previousPoleNo: _previousPoleNo.text,
                                    lineTypeId: checkNotSelect(
                                        selectedLineTypeId, 'Line Type'),
                                    backSpan: _backSpan.text,
                                    wireLength:
                                        parseOrZeroDouble(_wireLength.text),
                                    typeOfWireId: checkNotSelect(
                                        selectedWireTypeId, 'Wire Type'),
                                    wireConditionId: checkNotSelect(
                                        selectedWireConditionId,
                                        'Wire Condition'),
                                    phaseAId: selectedPhaseAId ?? '',
                                    phaseBId: selectedPhaseBId ?? '',
                                    phaseCId: selectedPhaseCId ?? '',
                                    neutral: _isneutral,
                                    isRightPole: _isRightPole,
                                  );
                                  await CallPoleApi()
                                      .createPoleDetailInfo(poleDetailInfo);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FilterPoleDetails()),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Pole Created Successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (error) {
                                  //print(error);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to Create data: $error'),
                                        backgroundColor: Colors.red),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                              child: const Text('Save',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
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
}
