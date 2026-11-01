import 'package:bpdb_gis_app/models/regions/pole.dart';
import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../api/pole_api.dart';
import '../../models/pole_lookup/line_type.dart';
import '../../models/pole_lookup/pole_condition.dart';
import '../../models/pole_lookup/pole_details_update.dart';
import '../../models/pole_lookup/pole_update.dart';
import '../../models/pole_lookup/wire_type.dart';
import '../../models/region_delails_lookup/poleDetailsId.dart';
import '../../models/region_delails_lookup/poleId.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/feeder_line.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';

class EditPolePopup extends StatefulWidget {
  final int poleId;
  final int poleDetailsId;
  const EditPolePopup({
    super.key,
    required this.poleId,
    required this.poleDetailsId,
  });

  @override
  State<EditPolePopup> createState() => _EditPolePopupState();
}

class _EditPolePopupState extends State<EditPolePopup> {
  late Future<List<PoleDetails>> _futurePolesByDetailsId;
  late Future<List<PoleDetailByID>> _futurePolesById;

  late Future<List<Substation>> substations;
  late Future<List<FeederLine>> feederLines;
  late Future<List<LineType>> fetchLineType;
  late Future<List<WireType>> fetchWireType;
  late Future<List<PoleCondition>> fetchPoleCondition;

  int? selectedSubstationId;
  int? selectedFeederLineId;
  int? selectedLineTypeId;
  int? selectedWireTypeId;
  int? selectedPoleConditionId;
  bool isLoading = false;
  bool streetLight = false;
  bool commonPole = false;
  bool tap = false;

  late TextEditingController poleNo = TextEditingController();
  late TextEditingController previousPoleNo = TextEditingController();
  late TextEditingController wireLendth = TextEditingController();
  late TextEditingController backSpan = TextEditingController();

  late TextEditingController htWireNo = TextEditingController();
  late TextEditingController ltWireNo = TextEditingController();
  late TextEditingController poleHeight = TextEditingController();
  late TextEditingController lineElevKv = TextEditingController();
  late TextEditingController lineThirtyKv = TextEditingController();
  late TextEditingController lineFourKv = TextEditingController();
  late TextEditingController latitude = TextEditingController();
  late TextEditingController longitude = TextEditingController();

  Future<List<PoleDetails>> _fetchPolesByDetailsId() async {
    return CallPoleApi().fetchPolesByDetailsId(widget.poleDetailsId);
  }

  Future<List<PoleDetailByID>> _fetchPolesById() async {
    return CallPoleApi().fetchPolesById(widget.poleId);
  }

  @override
  void initState() {
    super.initState();
    _futurePolesByDetailsId = _fetchPolesByDetailsId();
    _futurePolesById = _fetchPolesById();

    substations = Future.value([]);
    feederLines = Future.value([]);
    fetchLineType = Future.value([]);
    fetchWireType = Future.value([]);
    fetchPoleCondition = Future.value([]);

    _futurePolesByDetailsId.then((poles) {
      setState(() {
        substations = CallApi().fetchSubstationInfo(poles.first.sndId);
        feederLines = CallApi().fetchFeederLineInfo(poles.first.substationId);
        fetchLineType = CallPoleApi().fetchLineType();
        fetchWireType = CallPoleApi().fetchWireType();

        if (poles.isNotEmpty) {
          selectedSubstationId = poles.first.substationId;
          selectedFeederLineId = poles.first.feederLineId;
          selectedLineTypeId = poles.first.lineTypeId;
          selectedWireTypeId = poles.first.typeOfWireId;
          poleNo.text = poles.first.poleNo;
          previousPoleNo.text = poles.first.previousPoleNo ?? '';
          wireLendth.text = poles.first.wireLength?.toString() ?? '';
          backSpan.text = poles.first.backSpan?.toString() ?? '';
        } else {
          print('No poles found for this details ID.');
        }
      });
    });

    _futurePolesById.then((poles) {
      setState(() {
        fetchPoleCondition = CallPoleApi().fetchPoleCondition();
        if (poles.isNotEmpty) {
          selectedPoleConditionId = poles.first.poleConditionId;
          htWireNo.text = poles.first.noOfWireHt?.toString() ?? '';
          ltWireNo.text = poles.first.noOfWireLt?.toString() ?? '';
          poleHeight.text = poles.first.poleHeight?.toString() ?? '';
          lineElevKv.text = poles.first.noOfLine11Kv?.toString() ?? '';
          lineThirtyKv.text = poles.first.noOfLine33Kv?.toString() ?? '';
          lineFourKv.text = poles.first.noOfLineP4Kv?.toString() ?? '';
          latitude.text = poles.first.latitude.toString();
          longitude.text = poles.first.longitude.toString();
          commonPole = poles.first.commonPole;
          streetLight = poles.first.streetLight;
          tap = poles.first.tap;
        } else {
          print('No poles found for this details ID.');
        }
      });
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

  void itemSwitchStreetLight(bool value) {
    setState(() {
      streetLight = !streetLight;
    });
  }

    void itemSwitchCommonPole(bool value) {
    setState(() {
      commonPole = !commonPole;
    });
  }

  void itemSwitchTap(bool value) {
    setState(() {
      tap = !tap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3))),
        contentPadding: const EdgeInsets.all(0),
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        // title: const Text('FeederLine Details'),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: const Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pole Details Edit",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  shadowColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  )),
                  color: Colors.white,
                  margin: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ////////////////////////////////////////Theme_1//////////////////////////////////
                        Theme(
                          data: ThemeData().copyWith(
                            dividerColor: Colors.transparent,
                            iconTheme: const IconThemeData(color: Colors.white),
                          ),
                          child: ExpansionTile(
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
                                        showMessage('Error: ${snapshot.error}',
                                            'error');
                                        return DropdownButtonFormField<int>(
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                            labelText: 'Substation',
                                            labelStyle: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          value: null,
                                          hint: const Text(
                                              'No substations available!'),
                                          items: [],
                                          onChanged: null,
                                        );
                                      } else if (snapshot.hasData) {
                                        return DropdownButtonFormField<int>(
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                            labelText: 'Substation',
                                            labelStyle: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          value: selectedSubstationId,
                                          hint:
                                              const Text('Select a Substation'),
                                          items:
                                              snapshot.data!.map((substation) {
                                            return DropdownMenuItem<int>(
                                              value: substation.substationId,
                                              child: Text(
                                                  substation.substationName),
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
                                        return const Text(
                                            'No substations available!');
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
                                        showMessage('Error: ${snapshot.error}',
                                            'error');
                                        return DropdownButtonFormField<int>(
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                            labelText: 'Feeder Line',
                                            labelStyle: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          value: null,
                                          hint: const Text(
                                              'No feeder line available!'),
                                          items: [],
                                          onChanged: null,
                                        );
                                      } else if (snapshot.hasData) {
                                        return DropdownButtonFormField<int>(
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                            labelText: 'Feeder Line',
                                            labelStyle: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          value: selectedFeederLineId,
                                          hint: const Text(
                                              'Select a Feeder Line'),
                                          items: snapshot.data!.map((feeder) {
                                            return DropdownMenuItem<int>(
                                              value: feeder.feederLineId,
                                              child: Text(
                                                  '${feeder.feederlineName}'),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedFeederLineId = value;
                                            });
                                          },
                                        );
                                      } else {
                                        return const Text(
                                            'No feeder line available!');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ////////////////////////////////////////Theme_1//////////////////////////////////

                        ////////////////////////////////////////Theme_2//////////////////////////////////
                        Theme(
                          data: ThemeData().copyWith(
                            dividerColor: Colors.transparent,
                            iconTheme: const IconThemeData(color: Colors.white),
                          ),
                          child: ExpansionTile(
                            collapsedBackgroundColor:
                                const Color.fromARGB(255, 241, 245, 245),
                            title: const Text('Feeder Wise Pole Information'),
                            childrenPadding: const EdgeInsets.all(5),
                            textColor: const Color.fromARGB(255, 5, 161, 182),
                            children: [
                              FieldsetLegend(
                                legendText: 'Feeder Wise Pole Information',
                                children: [
                                  _buildTextField(context, poleNo, 'Pole No'),
                                  _buildTextField(context, previousPoleNo,
                                      'Previous Pole No'),
                                  // -- Dropdown for Line Type -- //
                                  FutureBuilder<List<LineType>>(
                                    future: fetchLineType,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox.shrink();
                                      }
                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (snapshot.hasData) {
                                        return DropdownButtonFormField<int>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            labelText: 'Line Type',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                          value: selectedLineTypeId,
                                          hint: RichText(
                                            text: const TextSpan(
                                              text: 'Select a Line Type',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 100, 97, 97),
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
                                              child:
                                                  Text(lineType.lineTypeName),
                                            );
                                          }).toList(),
                                          selectedItemBuilder: (context) {
                                            return snapshot.data!
                                                .map((lineType) {
                                              return Text(
                                                lineType.lineTypeName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight
                                                      .normal, // 👈 removes bold
                                                  color: Colors.black,
                                                ),
                                              );
                                            }).toList();
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              selectedLineTypeId = value;
                                            });
                                          },
                                        );
                                      } else {
                                        return const Text(
                                            'No Line Type available');
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 12.0),

                                  FutureBuilder<List<WireType>>(
                                    future: fetchWireType,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox.shrink();
                                      }

                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (snapshot.hasData) {
                                        return DropdownButtonFormField<int>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            labelText: 'Wire Type',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                          value: selectedWireTypeId,
                                          hint: RichText(
                                            text: const TextSpan(
                                              text: 'Select a Wire Type',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 100, 97, 97),
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
                                              child: Text(wireType.name),
                                            );
                                          }).toList(),
                                          selectedItemBuilder: (context) {
                                            return snapshot.data!
                                                .map((wireType) {
                                              return Text(
                                                wireType.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight
                                                      .normal, // 👈 removes bold
                                                  color: Colors.black,
                                                ),
                                              );
                                            }).toList();
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              selectedWireTypeId = value;
                                            });
                                          },
                                        );
                                      } else {
                                        return const Text(
                                            'No Wire Type available');
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 12.0),
                                  // -- Dropdown for Line Type -- //
                                  _buildTextField(
                                      context, wireLendth, 'Wire Length (m)'),
                                  // _buildTextField(
                                  //     context, backSpan, 'Back Span'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ////////////////////////////////////////Theme_2//////////////////////////////////

                        ////////////////////////////////////////Theme_3//////////////////////////////////
                        Theme(
                          data: ThemeData().copyWith(
                            dividerColor: Colors.transparent,
                            iconTheme: const IconThemeData(color: Colors.white),
                          ),
                          child: ExpansionTile(
                            collapsedBackgroundColor:
                                const Color.fromARGB(255, 223, 240, 243),
                            title: const Text('Pole Unique Information'),
                            childrenPadding: const EdgeInsets.all(5),
                            textColor: const Color.fromARGB(255, 5, 161, 182),
                            children: [
                              FieldsetLegend(
                                legendText: 'Pole Unique Information',
                                children: [
                                  FutureBuilder<List<PoleCondition>>(
                                    future: fetchPoleCondition,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox.shrink();
                                      }

                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (snapshot.hasData) {
                                        return DropdownButtonFormField<int>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            labelText: "Pole Condition",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                          value: selectedPoleConditionId,
                                          hint: RichText(
                                            text: const TextSpan(
                                              text: 'Select a Pole Condition',
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 100, 97, 97),
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
                                          items: snapshot.data!
                                              .map((poleCondition) {
                                            return DropdownMenuItem<int>(
                                              value:
                                                  poleCondition.poleConditionId,
                                              child: Text(
                                                  '${poleCondition.conditionName}'),
                                            );
                                          }).toList(),
                                          selectedItemBuilder: (context) {
                                            return snapshot.data!
                                                .map((poleCondition) {
                                              return Text(
                                                '${poleCondition.conditionName}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight
                                                      .normal, // 👈 removes bold
                                                  color: Colors.black,
                                                ),
                                              );
                                            }).toList();
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              selectedPoleConditionId = value;
                                            });
                                          },
                                        );
                                      } else {
                                        return const Text(
                                            'No Pole Condition available');
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                  _buildTextField(
                                      context, htWireNo, 'No of Wire HT'),
                                  _buildTextField(
                                      context, ltWireNo, 'No of Wire LT'),
                                  _buildTextField(
                                      context, poleHeight, 'Pole Height'),
                                  _buildTextField(
                                      context, lineElevKv, 'No of Line 11 KV'),
                                  _buildTextField(context, lineThirtyKv,
                                      'No of Line 33 KV'),
                                  _buildTextField(
                                      context, lineFourKv, 'No of Line 0.4 KV'),
                                  
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
                                              text: TextSpan(
                                                text: 'Street Light',
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 100, 97, 97),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            Switch(
                                              value: streetLight,
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
                                                text: 'Common Pole',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(255, 100, 97, 97),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            Switch(
                                              value: commonPole,
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
                                              value: tap,
                                              onChanged: itemSwitchTap,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  _buildTextField(
                                      context, latitude, 'Latitude'),
                                  _buildTextField(
                                      context, longitude, 'Longitude'),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            PoleDetailsUpdate updatedPoleDetails = PoleDetailsUpdate(
                                              poleDetailsId:
                                                  widget.poleDetailsId,
                                              substationId:
                                                  selectedSubstationId!,
                                              feederLineId:
                                                  selectedFeederLineId!,
                                              lineTypeId: selectedLineTypeId!,
                                              typeOfWireId: selectedWireTypeId!,
                                              poleNo: poleNo.text,
                                              previousPoleNo:
                                                  previousPoleNo.text.isEmpty
                                                      ? ''
                                                      : previousPoleNo.text,
                                              wireLength:
                                                  wireLendth.text.isEmpty
                                                      ? null
                                                      : double.parse(
                                                          wireLendth.text),
                                              backSpan: backSpan.text.isEmpty
                                                  ? null
                                                  : double.parse(
                                                      backSpan.text),
                                            );

                                            PoleUpdate updatePole = PoleUpdate(
                                              poleId:
                                                  widget.poleId,
                                              poleConditionId:
                                                  selectedPoleConditionId!,
                                              noOfWireHt: htWireNo.text.isEmpty
                                                  ? null
                                                  : int.parse(htWireNo.text),
                                              noOfWireLt: ltWireNo.text.isEmpty
                                                  ? null
                                                  : int.parse(ltWireNo.text),
                                              poleHeight: poleHeight.text.isEmpty
                                                  ? null
                                                  : double.parse(
                                                      poleHeight.text),
                                              noOfLine11Kv:
                                                  lineElevKv.text.isEmpty
                                                      ? null
                                                      : int.parse(
                                                          lineElevKv.text),
                                              noOfLine33Kv:
                                                  lineThirtyKv.text.isEmpty
                                                      ? null
                                                      : int.parse(
                                                          lineThirtyKv.text),
                                              noOfLineP4Kv:
                                                  lineFourKv.text.isEmpty
                                                      ? null
                                                      : int.parse(
                                                          lineFourKv.text),
                                              latitude:
                                                  double.parse(latitude.text),
                                              longitude:
                                                  double.parse(longitude.text),
                                              streetLight: streetLight,
                                              commonPole: commonPole, 
                                              tap: tap, 
                                            );
                                            await CallPoleApi().updatePole(updatedPoleDetails, updatePole);

                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Pole Updated Successfully'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (error) {
                                            // Handle Error
                                            //print(error);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Failed to update data: $error'),
                                                backgroundColor: Colors.red,
                                                duration:
                                                    const Duration(seconds: 20),
                                              ),
                                            );
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blue),
                                        ),
                                        child: const Text('Save Update',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                   Container(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Card(
                                          color: const Color.fromARGB(255, 5, 161, 182),
                                          margin: const EdgeInsets.only(
                                            right: 10,
                                            bottom: 10,
                                          ),
                                          child: TextButton(
                                            child: const Text(
                                              'Close',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ////////////////////////////////////////Theme_3//////////////////////////////////
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Widget _buildTextField(
    BuildContext context, TextEditingController controller, String label) {
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
