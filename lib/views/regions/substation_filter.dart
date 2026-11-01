import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../api/region_api.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';
import '../../models/region_delails_lookup/substation.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import 'substation_details.dart';

class SubstationFilterPage extends StatefulWidget {
  const SubstationFilterPage({super.key});

  @override
  State<SubstationFilterPage> createState() => _SubstationFilterPageState();
}

class _SubstationFilterPageState extends State<SubstationFilterPage> {
  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  final CallRegionApi api = CallRegionApi();
  Future<List<Substations>>? futureSubstations;
  Future<List<EsuInfo>>? esudata;

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedEsuId;
  String? selectedSnDName;
  String? selectedEsuName;
  bool viewWithinEsu = false;
  bool viewWithoutEsu = false;

  bool isLoading = false;
  User? user = globalUser;

  @override
  void initState() {
    super.initState();
    zones = CallApi().fetchZoneInfo();
    circles = Future.value([]);
    snds = Future.value([]);
    if (user?.SndId != null) {
      selectedSnDId = user!.SndId;
      selectedSnDName = user?.SnDName;
      futureSubstations =
          CallRegionApi().fetchSubstationInfo('snd_${selectedSnDId!}');
    }
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
    futureSubstations = Future.value([]);
    viewWithinEsu = false;
    viewWithoutEsu = false;
    circles = CallApi().fetchCircleInfo(value!).whenComplete(() {
      setLoading(false);
    });
    snds = Future.value([]);
    
  }

  void onCircleChanged(int? value) {
    setLoading(true);
    selectedCircleId = value;
    selectedSnDId = null;
    futureSubstations = Future.value([]);
    viewWithinEsu = false;
    viewWithoutEsu = false;
    snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
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
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          'Filter Substation Info',
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
                            onChanged: user?.SndId == null
                                ? (value) {
                                    final selectedSnd = snapshot.data!
                                        .firstWhere(
                                            (snd) => snd.sndId == value);

                                    setState(() {
                                      selectedSnDId = selectedSnd.sndId;
                                      selectedSnDName = selectedSnd.snDName;
                                      futureSubstations = CallRegionApi()
                                          .fetchSubstationInfo(
                                              'snd_${selectedSnDId!}');
                                    });
                                  }
                                : null,
                          );
                        } else {
                          return const Text('No SnDs available!');
                        }
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Without ESU"),
                            value: viewWithoutEsu,
                            onChanged: (value) {
                              setState(() {
                                viewWithoutEsu = value ?? false;
                                if(viewWithoutEsu){
                                  futureSubstations = CallRegionApi()
                                      .fetchSubstationInfo('noesu_${selectedSnDId!}');
                                } else {
                                  futureSubstations = CallRegionApi()
                                      .fetchSubstationInfo('snd_${selectedSnDId!}');
                                }
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20.0),

                    /// --- Circles List ---//
                    if (futureSubstations != null)
                      Center(
                        child: Text(
                          'Substation for $selectedSnDName S&D',
                          style: TextStyle(
                            fontSize: deviceFontSize + 4,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 5, 161, 182),
                          ),
                        ),
                      ),
                    const Divider(),
                    FutureBuilder<List<Substations>>(
                      future: futureSubstations,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No Substation available yet!'),
                          );
                        } else {
                          List<Substations> substations = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: substations.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // Static card showing total count
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  color: Colors.lightBlue[50],
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'Total Substations: ${substations.length}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              Substations substationInfo =
                                  substations[index - 1];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  title: Text(
                                    "${substationInfo.substationName}\n${substationInfo.operatingSndName ?? ''}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Tooltip(
                                        message: 'View Details',
                                        child: Container(
                                          height: 27,
                                          width: 27,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            iconSize: 12,
                                            icon: const Icon(
                                              Icons.info,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              showSubstationDetailDialog(
                                                  context,
                                                  api,
                                                  substationInfo.substationId);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Handle list tap if needed
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ))),
    );
  }
}
