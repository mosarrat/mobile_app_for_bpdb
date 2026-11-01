import 'package:bpdb_gis_app/api/pole_api.dart';
import 'package:flutter/material.dart';
import '../../models/pole_lookup/pole.dart';
import '../../models/pole_lookup/feederwise_pole_data.dart';
import '../../models/pole_lookup/pole_data.dart';
import 'add_feeder_wise_pole.dart';
import 'add_new_pole_details.dart';
import 'filter_pole_detail.dart';

class AddNewPole extends StatefulWidget {
  const AddNewPole({super.key});

  @override
  State<AddNewPole> createState() => _AddNewPoleState();
}

class _AddNewPoleState extends State<AddNewPole> {
  final List<String> _stepTitles = ['Pole Info', 'Feeder wise Pole'];
  int _currentStep = 0;
  Poles? _currentPole;
  List<int> feederPoleForms = [0];
  List<FeederWireFormData> feederForms = [
    FeederWireFormData()
  ];
  PoleFormData? poleFormData;

  bool isPoleFormValid(PoleFormData data) {
    return data.zoneId != null &&
        data.circleId != null &&
        data.sndId != null &&
        data.poleTypeId != null &&
        data.poleConditionId != null &&
        data.latitude != null &&
        data.longitude != null;
  }
  Widget _buildStepPage(int step) {
    switch (step) {
      case 0:
        return AddNewPoleData(
          onChanged: (data) {
            poleFormData = data;
          },
        );
      case 1:
        return Column(
          children: feederForms.asMap().entries.map((entry) {
            int index = entry.key;
            FeederWireFormData data = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AddFeederWisePole(
                index: index,
                zoneId: poleFormData?.zoneId ?? 0,
                circleId: poleFormData?.circleId ?? 0,
                sndId: poleFormData?.sndId ?? 0,
                esuId: poleFormData?.esuId ?? 0,
                poleId: poleFormData?.poleId ?? 0,
                data: data,
                onAdd: () {
                  setState(() {
                    feederForms.add(FeederWireFormData());
                  });
                },
                onRemove: () {
                  setState(() {
                    feederForms.removeAt(index);
                  });
                },
                onChanged: (updatedData) {
                  feederForms[index] = updatedData;
                },
              ),
            );
          }).toList(),
        );
      default:
        return const Center(child: Text("Unknown Step"));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          "Add Pole",
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
                        if (_currentStep > 0)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                feederForms.add(FeederWireFormData());
                              });
                            },
                            child: const Text('Add More'),
                          ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            if (_currentStep < _stepTitles.length - 1) {
                              if (poleFormData != null && isPoleFormValid(poleFormData!)) {
                                setState(() {
                                  _currentStep++;
                                });
                              }else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please complete the Pole Info form before proceeding.'),
                                    backgroundColor: Colors.red
                                  ),
                                );
                              }
                              
                            } else {
                              // Final submission logic here
                              // if (poleFormData != null) {
                              // }
                              // for (var form in feederForms) {
                              //   print('Feeder ID: ${form.feederId}, Pole Count: ${form.poleCount}');  
                              // }
                              //CallPoleApi().submitForm(poleFormData, feederForms);

                              final success = await CallPoleApi().submitForm(
                                  poleFormData,
                                  feederForms,
                                );

                                if (!mounted) return;

                                if (success) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const FilterPoleDetails(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Failed to save data")),
                                  );
                                }
                            }
                          },
                          child: Text(
                              _currentStep < _stepTitles.length - 1
                                  ? 'Next'
                                  : 'Submit'
                          ),
                        ),
                      ]
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
}