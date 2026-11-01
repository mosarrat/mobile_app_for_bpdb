import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import 'view_consumers.dart';

class FilterConsumers extends StatefulWidget {
  const FilterConsumers({super.key});

  @override
  State<FilterConsumers> createState() => _FilterConsumersState();
}

class _FilterConsumersState extends State<FilterConsumers> {
  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<EsuInfo>> esu;
  late Future<List<Substation>> substations;
  late Future<List<FeederLine>> feederLines;
  // Dropdown items
  final Map<String, String> filterOptions = {
    'FeederLineId': 'Feeder',
    'ConsumerNo': 'Consumer No',
    'CustomerNid': 'Consumer NID',
    'MobileNo': 'Mobile No',
    'MeterNumber': 'Meter No',
  };

  // Currently selected filter
  double? deviceFontSize;
  double? width;
  double? height;
  String? selectedFilter;
  String? selectedFilterValue;
  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedEsuId;
  int? selectedSubstationId;
  int? selectedFeederLineId;

  final TextEditingController consumerNoController = TextEditingController();
  final TextEditingController consumerNidController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController meterNoController = TextEditingController();

  bool isLoading = false;
  User? user = globalUser;

  @override
  void dispose() {
    // Dispose controllers
    consumerNoController.dispose();
    consumerNidController.dispose();
    mobileNoController.dispose();
    meterNoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    zones = CallApi().fetchZoneInfo();
    circles = Future.value([]);
    snds = Future.value([]);
    esu = Future.value([]);
    substations = Future.value([]);
    feederLines = Future.value([]);
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
    circles = CallApi().fetchCircleInfo(value!).whenComplete(() {
      setLoading(false);
    });
    snds = Future.value([]);
    substations = Future.value([]);
    feederLines = Future.value([]);
  }

  void onCircleChanged(int? value) {
    setLoading(true);
    selectedCircleId = value;
    selectedSnDId = null;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
      setLoading(false);
    });
    substations = Future.value([]);
    feederLines = Future.value([]);
  }

  Future<void> onSnDChanged(int? value) async {
    setLoading(true);
    selectedSnDId = value;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    try {
      List<EsuInfo> esudata = await CallConsumerApi().fetchEsuInfo(value!);
      if (esudata.isEmpty) {
        // print("No ESU data found for SnD ID: $value");
        substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
          setLoading(false);
        });
      } else {
        // print("ESU data found for SnD ID: $value");
        esu = CallConsumerApi().fetchEsuInfo(value!).whenComplete(() {
          setLoading(false);
        });
        substations = Future.value([]);
      }
    } catch (e) {
      print('Error fetching ESU info: $e');
      substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
        setLoading(false);
      });
    }
    feederLines = Future.value([]);
  }

  void onEsuChanged(int? value) {
    setLoading(true);
    selectedEsuId = value;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    substations = CallApi().fetchSubstationInfoByEsu(value!).whenComplete(() {
      setLoading(false);
    });
  }

  void onSubstationChanged(int? value) {
    setLoading(true);
    selectedSubstationId = value;
    selectedFeederLineId = null;
    feederLines = CallApi().fetchFeederLineInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  Widget _buildInputField() {
    switch (selectedFilter) {
      case 'FeederLineId':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Zone>>(
              future: zones,
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
                      labelText: 'Zone',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        fontSize: deviceFontSize! + 6,
                        fontWeight: FontWeight.bold,
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
                      labelText: 'Circle',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        fontSize: deviceFontSize! + 6,
                        fontWeight: FontWeight.bold,
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
                      labelText: 'Circle',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        fontSize: deviceFontSize! + 6,
                        fontWeight: FontWeight.bold,
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
                      labelText: 'SnD',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        fontSize: deviceFontSize! + 6,
                        fontWeight: FontWeight.bold,
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
                        labelText: 'SnD',
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 5, 161, 182),
                          fontSize: deviceFontSize! + 6,
                          fontWeight: FontWeight.bold,
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
                              onSnDChanged(value);
                            }
                          : null);
                } else {
                  return const Text('No SnDs available!');
                }
              },
            ),
            const SizedBox(height: 16.0),
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
                      labelText: 'ESU',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        fontSize: deviceFontSize! + 6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: null,
                    hint: const Text('No ESU available!'),
                    items: [],
                    onChanged: null,
                  );
                } else if (snapshot.hasData) {
                  return DropdownButtonFormField<int>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'ESU',
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 5, 161, 182),
                          fontSize: deviceFontSize! + 6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: selectedEsuId,
                      hint: const Text('Select a ESU'),
                      items: snapshot.data!.map((esu) {
                        return DropdownMenuItem<int>(
                          value: esu.esuId,
                          child: Text(esu.esuName),
                        );
                      }).toList(),
                      onChanged: user?.EsuId == null
                      ? (value) {
                          selectedEsuId = value;
                          onEsuChanged(value);
                        }
                      : null);
                } else {
                  return const Text('No ESU available!');
                }
              },
            ),
            const SizedBox(height: 16.0),
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
                      labelText: 'Substation',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        fontSize: deviceFontSize! + 6,
                        fontWeight: FontWeight.bold,
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
                      labelText: 'Substation',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        fontSize: deviceFontSize! + 6,
                        fontWeight: FontWeight.bold,
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
                      labelText: 'Feeder Line',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        fontSize: deviceFontSize! + 6,
                        fontWeight: FontWeight.bold,
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
                      labelText: 'Feeder Line',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        fontSize: deviceFontSize! + 6,
                        fontWeight: FontWeight.bold,
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
                      });
                    },
                  );
                } else {
                  return const Text('No feeder line available!');
                }
              },
            ),
          ],
        );
      case 'ConsumerNo':
        return TextFormField(
          controller: consumerNoController,
          decoration: const InputDecoration(
            labelText: 'Enter Consumer No',
            border: OutlineInputBorder(),
          ),
        );
      case 'CustomerNid':
        return TextFormField(
          controller: consumerNidController,
          decoration: const InputDecoration(
            labelText: 'Enter Consumer NID',
            border: OutlineInputBorder(),
          ),
        );
      case 'MobileNo':
        return TextFormField(
          controller: mobileNoController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Enter Mobile No',
            border: OutlineInputBorder(),
          ),
        );
      case 'MeterNumber':
        return TextFormField(
          controller: meterNoController,
          decoration: const InputDecoration(
            labelText: 'Enter Meter No',
            border: OutlineInputBorder(),
          ),
        );
      default:
        return const SizedBox(); // Empty if nothing selected
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
      substations =
          CallApi().fetchSubstationInfo(selectedSnDId!).whenComplete(() {
        setLoading(false);
      });
    }
    if (user?.EsuId != null) {
      //print("ESU ID: ${user!.EsuId}");
      selectedEsuId = user?.EsuId;
      substations =
          CallApi().fetchSubstationInfoByEsu(selectedEsuId!).whenComplete(() {
        setLoading(false);
      });
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Filter Consumers',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search Consumer By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedFilter,
              hint: const Text('Select Filter'),
              items: filterOptions.entries
                  .map((entry) => DropdownMenuItem(
                        value: entry.key, // this is the value
                        child: Text(entry.value), // this is the displayed text
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField(),
            const SizedBox(height: 20),
            // -- Button -- //
            Center(
              child: SizedBox(
                width: width! * 0.4,
                height: height! * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    /*
                     final Map<String, String> filterOptions = {
                      'FeederLineId': 'Feeder',
                      'ConsumerNo': 'Consumer No',
                      'CustomerNid': 'Consumer NID',
                      'MobileNo': 'Mobile No',
                      'MeterNumber': 'Meter No',
                    };
                    */
                    if (selectedFilter == "ConsumerNo" &&
                        consumerNoController.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsumerListView(
                            field: selectedFilter!,
                            value: consumerNoController.text,
                          ),
                        ),
                      );
                    } 
                    else if (selectedFilter == "CustomerNid" &&
                        consumerNidController.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsumerListView(
                            field: selectedFilter!,
                            value: consumerNidController.text,
                          ),
                        ),
                      );
                    } else if (selectedFilter == "MobileNo" &&
                        mobileNoController.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsumerListView(
                            field: selectedFilter!,
                            value: mobileNoController.text,
                          ),
                        ),
                      );
                    } else if (selectedFilter == "MeterNumber" &&
                        meterNoController.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsumerListView(
                            field: selectedFilter!,
                            value: meterNoController.text,
                          ),
                        ),
                      );
                    } else if (selectedFilter == "FeederLineId" &&
                        selectedFeederLineId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsumerListView(
                            field: selectedFilter!,
                            value: selectedFeederLineId.toString(),
                          ),
                        ),
                      );
                    }
                    else {
                      showMessage(
                          'Please enter a Consumer No or select a Feeder Line',
                          'error');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      // Adjust the color based on the button state
                      if (states.contains(MaterialState.pressed)) {
                        return const Color.fromARGB(255, 5, 161, 182)
                            .withOpacity(0.5);
                      }
                      return const Color.fromARGB(255, 5, 161, 182);
                    }),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 5, 161, 182)),
                    )),
                    elevation: MaterialStateProperty.all(4),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
