import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../api/dt_api.dart';
import '../../models/dt_lookup/body_color_condition.dart';
import '../../models/dt_lookup/dt_condition.dart';
import '../../models/dt_lookup/edit_dt_model.dart';
import '../../models/dt_lookup/support_pole_condition.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/pole.dart';
import '../../widgets/widgets/fieldset_legend.dart';

class ShowDtEdit extends StatefulWidget {
  final int dtId;
  const ShowDtEdit({super.key, required this.dtId});

  @override
  State<ShowDtEdit> createState() => _ShowDtEditState();
}

class _ShowDtEditState extends State<ShowDtEdit> {
  late Future<DistributionTransformerEdit> _futureDtData;
  late Future<List<FeederLine>> feederLines;
  late Future<List<Pole>> poleLeft;
  late Future<List<Pole>> poleRight;
  late Future<List<DTCondition>> fetchDTCondition;
  late Future<List<BodyColorCondition>> bodyColorCondition;
  late Future<List<SupportPoleCondition>> supportPoleCondition;

  int? selectedDTConditionId;
  int? selectedBodyConditionId;
  String? selectedSupportPoleConditionLeft;
  String? selectedSupportPoleConditionRight;

  var dt = DateTime.now(); // Date-Time
  bool isLoading = false;
  bool _oilLeakageYesOrNo = false;
  
  final TextEditingController dtLocationName = TextEditingController();
  final TextEditingController dtNumber = TextEditingController();
  final TextEditingController nameof11KvFeeder = TextEditingController();
  final TextEditingController nearestHoldingHouseNoShop =
      TextEditingController();
  final TextEditingController recommendation = TextEditingController();
  final TextEditingController remarks = TextEditingController();

  Future<DistributionTransformerEdit> _fetchDtData() async {
    return CallDTApi().fetchDTForEdit(widget.dtId);
  }

   void itemSwitchoilLeakage(bool value) {
    setState(() {
      _oilLeakageYesOrNo = !_oilLeakageYesOrNo;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureDtData = _fetchDtData();
   
    poleLeft = Future.value([]);
    poleRight = Future.value([]);
    fetchDTCondition = CallDTApi().fetchDTCondition();
    bodyColorCondition = CallDTApi().bodyColorCondition();
    supportPoleCondition = CallDTApi().supportPoleCondition();

    _futureDtData.then((dt) {
      setState(() {
        
        dtLocationName.text = dt.dtLocationName ?? '';
        dtNumber.text = dt.dtNumber ?? '';
        nameof11KvFeeder.text = dt.nameof11KvFeeder ?? '';
        nearestHoldingHouseNoShop.text = dt.nearestHoldingHouseNoShop ?? '';
        recommendation.text = dt.recommendation ?? '';
        remarks.text = dt.remarks ?? '';

        fetchDTCondition = CallDTApi().fetchDTCondition();
        bodyColorCondition = CallDTApi().bodyColorCondition();
        supportPoleCondition = CallDTApi().supportPoleCondition();

        selectedDTConditionId = dt.dtConditionId;
        selectedBodyConditionId = dt.bodyColorConditionId;
        _oilLeakageYesOrNo = dt.oilLeakageYesOrNo ?? false;
        selectedSupportPoleConditionLeft = dt.conditionofTransformerSupportPoleLeft != null
            ? int.tryParse(dt.conditionofTransformerSupportPoleLeft!).toString()
            : null;
        selectedSupportPoleConditionRight= dt.conditionofTransformerSupportPoleRight != null
            ? int.tryParse(dt.conditionofTransformerSupportPoleRight!).toString()
            : null;
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
        child: const Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "DT Update",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
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
                  // width: MediaQuery.of(context).size.width,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  )),
                  //color: const Color.fromARGB(255, 206, 242, 248),
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
                            title: const Text('Distribution Transformer Info'),
                            childrenPadding: const EdgeInsets.all(5),
                            textColor: const Color.fromARGB(255, 5, 161, 182),
                            children: [
                              FieldsetLegend(
                                legendText: 'Distribution Transformer Info',
                                children: [
                                  _buildTextField(
                                      context, dtLocationName, 'Location Name'),
                                  _buildTextField(
                                      context, dtNumber, 'DT Number'),
                                  
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
                                            labelText: 'DT Condition',
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
                            title: const Text('Distribution Transformer Others Information'),
                            childrenPadding: const EdgeInsets.all(5),
                            textColor: const Color.fromARGB(255, 5, 161, 182),
                            children: [
                              FieldsetLegend(
                                legendText: 'Distribution Transformer Others Information',
                                children: [
                                  _buildTextField(
                                      context, nameof11KvFeeder, '11KV Feeder Name'),
                                  _buildTextField(
                                      context, nearestHoldingHouseNoShop, 'Nearest Holding House/Shop'),
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
                                            labelText: 'Body Color Condition',
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
                                  _buildSwitchButton(_oilLeakageYesOrNo,
                                    itemSwitchoilLeakage, 'Oil Leakage Yes or No'),
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
                                            labelText: 'Condition of Transformer Support Pole Left',
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
                                            labelText: 'Condition of Transformer Support Pole Right',
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
                            title: const Text('Remarks/Recommendation'),
                            childrenPadding: const EdgeInsets.all(5),
                            textColor: const Color.fromARGB(255, 5, 161, 182),
                            children: [
                              FieldsetLegend(
                                legendText: 'Remarks/Recommendation',
                                children: [
                                  const SizedBox(height: 16.0),
                                  _buildTextField(
                                      context, recommendation, 'Recommendation'),
                                  _buildTextField(
                                      context, remarks, 'Remarks'),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            DistributionTransformerEdit updatedDtDetails = DistributionTransformerEdit(
                                              id: widget.dtId,
                                              dtLocationName: dtLocationName.text,
                                              dtNumber: dtNumber.text,
                                              nameof11KvFeeder: nameof11KvFeeder.text,
                                              nearestHoldingHouseNoShop: nearestHoldingHouseNoShop.text,
                                              bodyColorConditionId: selectedBodyConditionId,  
                                              oilLeakageYesOrNo: _oilLeakageYesOrNo,
                                              dtConditionId: selectedDTConditionId,
                                              conditionofTransformerSupportPoleLeft: selectedSupportPoleConditionLeft,
                                              conditionofTransformerSupportPoleRight: selectedSupportPoleConditionRight,
                                              recommendation: recommendation.text,
                                              remarks: remarks.text,
                                            );

                                            
                                            await CallDTApi().updateDt(updatedDtDetails);

                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'DT Updated Successfully'),
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
                )
              ]),
        ),
      ),
    );
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