import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../api/region_api.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/zone.dart';
import 'circle_details.dart';

class CircleFilterPage extends StatefulWidget {
  const CircleFilterPage({super.key});

  @override
  State<CircleFilterPage> createState() => _CircleFilterPageState();
}

class _CircleFilterPageState extends State<CircleFilterPage> {
  late Future<List<Zone>> zones;
  Future<List<Circles>>? futureCircles; // <-- nullable now
  final CallRegionApi api = CallRegionApi();
  int? selectedZoneId;
  String? selectedZoneName;

  bool isLoading = false;
  User? user = globalUser;

  @override
  void initState() {
    super.initState();
    zones = CallApi().fetchZoneInfo();

    // Preload circles if user already has a Zone
    if (user?.ZoneId != null) {
      selectedZoneId = user!.ZoneId;
      selectedZoneName = user?.ZoneName;
      futureCircles = CallRegionApi().fetchCircleInfo(selectedZoneId!);
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
    setState(() {
      selectedZoneId = value;
       // Reset to user's zone name if needed
      futureCircles = CallRegionApi().fetchCircleInfo(selectedZoneId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Filter Circle Info',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// --- Zone Dropdown ---
              FutureBuilder<List<Zone>>(
                future: zones,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
                      // onChanged: user?.ZoneId == null ? onZoneChanged : null,
                      onChanged: user?.ZoneId == null
                        ? (value) {
                            final selectedZone = snapshot.data!
                                .firstWhere((zone) => zone.zoneId == value);

                            setState(() {
                              selectedZoneId = selectedZone.zoneId;
                              selectedZoneName = selectedZone.zoneName; // <-- save name here
                              futureCircles = CallRegionApi().fetchCircleInfo(selectedZoneId!);
                            });
                          }
                        : null,
                    );
                  } else {
                    return const Text('No zones available');
                  }
                },
              ),
              const SizedBox(height: 20.0),
              

              /// --- Circles List ---//
              if (futureCircles != null)
                Center(
                  child: Text(
                    'Circles for $selectedZoneName Zone',
                    style: TextStyle(
                      fontSize: deviceFontSize + 4,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 5, 161, 182),
                    ),
                  ),
                ),
                const Divider(),
                FutureBuilder<List<Circles>>(
                  future: futureCircles,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No Circle available yet!'),
                      );
                    } else {
                      List<Circles> circles = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: circles.length + 1,
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
                                  'Total Circles: ${circles.length}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }
                          Circles circlesInfo = circles[index - 1];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              title: Text("${circlesInfo.circleName}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
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
                                          showCircleDetailDialog(
                                            context,
                                            api,
                                            circlesInfo.circleId,
                                          );
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
      ),
    );
  }
}