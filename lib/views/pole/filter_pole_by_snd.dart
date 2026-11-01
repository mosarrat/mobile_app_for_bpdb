// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../models/regions/snd_info.dart';
import '../../widgets/noti/notifications.dart';
import 'view_pole.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';



class FilterPoleBySnd extends StatefulWidget {
  const FilterPoleBySnd({super.key});

  @override
  _FilterPoleBySndState createState() => _FilterPoleBySndState();
}

class _FilterPoleBySndState extends State<FilterPoleBySnd> {
  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<Substation>> substations;
  late Future<List<FeederLine>> feederLines;


  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedSubstationId;
  int? selectedFeederLineId;
  //int? consumerNo;

  bool isLoading = false;
  User? user = globalUser;

  @override
  void initState() {
    super.initState();
    zones = CallApi().fetchZoneInfo();
    circles = Future.value([]);
    snds = Future.value([]);
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
    selectedSubstationId = null;
    selectedFeederLineId = null;
    snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
      setLoading(false);
    });
    substations = Future.value([]);
    feederLines = Future.value([]);
  }

  void onSnDChanged(int? value) {
    setLoading(true);
    selectedSnDId = value;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
      setLoading(false);
    });
    feederLines = Future.value([]);
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
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text('Filter Poles Info',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 8),
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              labelText: 'Zone',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: selectedZoneId,
                            hint: const Text('Select a Zone'),
                            items: snapshot.data!.map((zone) {
                              return DropdownMenuItem<int>(
                                value: zone.zoneId,
                                child:
                                    Text(zone.zoneName),
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
                              labelText: 'Circle',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
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
                                fontSize: deviceFontSize + 6,
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
                              labelText: 'SnD',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 5, 161, 182),
                                fontSize: deviceFontSize + 6,
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
                                fontSize: deviceFontSize + 6,
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
                                : null
                          );
                        } else {
                          return const Text('No SnDs available!');
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: SizedBox(
                        width: width * 0.4,
                        height: height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedSnDId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewPoles(
                                    sndId: selectedSnDId!,
                                  ),
                                ),
                              );
                            } else {
                              showMessage('Please enter select a SND', 'error');
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              // Adjust the color based on the button state
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(255, 5, 161, 182).withOpacity(0.5);
                              }
                              return const Color.fromARGB(255, 5, 161, 182);
                            }),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Color.fromARGB(255, 5, 161, 182),),
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
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),

                const SizedBox(height: 16.0),
            ],
          ))),
    );
  }
}
