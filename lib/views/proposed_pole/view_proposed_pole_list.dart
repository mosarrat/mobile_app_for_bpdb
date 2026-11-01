import 'package:bpdb_gis_app/constants/constant.dart';
import 'package:bpdb_gis_app/models/Login/login.dart';
import 'package:flutter/material.dart';

import '../../api/proposed_pole_api.dart';
import '../../dashboard.dart';
import '../../models/proposed_pole/section_info.dart';
import '../../models/proposed_pole/proposed_pole_sec.dart';
import 'proposed_pole_map.dart';
import 'view_pole_list.dart';

class ViewProposedPole extends StatefulWidget {
  const ViewProposedPole({super.key});

  @override
  State<ViewProposedPole> createState() => _ViewProposedPoleState();
}

class _ViewProposedPoleState extends State<ViewProposedPole> {
  final CallProposedPoleApi apiService = CallProposedPoleApi();
  // late Future<List<PoleSection>> _futurePoleSections;
  Future<List<SectionInfo>>? _futurePoleSections;
  bool isLoading = false;
  User? user = globalUser;
  @override
  void initState() {
    super.initState();
    _futurePoleSections = _fetchPoleSection();
  }

  Future<List<SectionInfo>> _fetchPoleSection() async {
    return CallProposedPoleApi().fetchSectionWisePoles();
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
    final adminInfo = [
      user?.ZoneName,
      user?.CircleName,
      user?.SnDName,
      user?.EsuName,
    ].where((e) => e != null && e.isNotEmpty).join(' | ');

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Proposed Pole List',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),

      
      body: FutureBuilder<List<SectionInfo>>(
        future: _futurePoleSections,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Feeder Line available!'));
          } else {
            // Filter the list based on search query

            List<SectionInfo> sections = snapshot.data!;

            return ListView.builder(
              itemCount: sections.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        // 🔹 Count Card
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.lightBlue[50],
                          child: SizedBox(
                            //height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                alignment: Alignment.centerLeft, // 👈 LEFT ALIGN
                                child: Text(
                                  'Total Sections: ${sections.length}',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 🔹 Admin Card
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: const Color.fromARGB(255, 229, 245, 253),
                          child: SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                alignment: Alignment.centerLeft, // 👈 LEFT ALIGN
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start, // 👈 IMPORTANT
                                  children: [
                                    const Text(
                                      "Administrative Information",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                    if (adminInfo.isNotEmpty)
                                      Text(
                                        adminInfo,
                                        style: const TextStyle(height: 1.5),
                                        textAlign: TextAlign.left,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                SectionInfo item = sections[index - 1];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      "Pole Section: ${item.sectionName}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      [
                        item.feederlineName,
                        item.voltLavel
                      ]
                          .where((e) => e != null && e.trim().isNotEmpty)
                          .join(' | '),
                      style: const TextStyle(height: 1.5),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'Add Pole Details',
                          child: Container(
                            height: 27,
                            width: 27,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              iconSize: 12,
                              icon: const Icon(Icons.info, color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewSectionProposedPole(
                                      sec_id: item.poleSectionId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
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
                              icon: const Icon(Icons.map, color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProposedPoleViewer(
                                      title: 'Proposed Pole Map View',
                                      zone: item.zoneId ?? 0,
                                      circle: item.circleId ?? 0,
                                      snd: item.sndId ?? 0,
                                      feederlineId: item.feederlineId ?? 0,
                                      sec_id: item.poleSectionId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
