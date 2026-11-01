import 'package:flutter/material.dart';
import '../../api/region_api.dart';
import '../../models/regions/zone.dart';
import 'zone_details.dart';

// import 'edit_feederline.dart';

class ViewZone extends StatefulWidget {
  const ViewZone({super.key});
  @override
  _ViewZoneState createState() => _ViewZoneState();
}

class _ViewZoneState extends State<ViewZone> {
  final CallRegionApi api = CallRegionApi();
  late Future<List<Zone>> _futureZones;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    _futureZones = _fetchZones();
  }

  Future<List<Zone>> _fetchZones() async {
    return CallRegionApi().fetchZoneInfo();
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

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text('Zones Information',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<Zone>>(
        future: _futureZones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Zone available!'));
          } else {
            // Filter the list based on search query

            List<Zone> Zones = snapshot.data!;

            return ListView.builder(
              itemCount: Zones.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Static card at the top
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    color: Colors.lightBlue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total Zones: ${Zones.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }
                Zone zoneInfo = Zones[index-1];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    title: Text("Zone Name: ${zoneInfo.zoneName}",
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
                                // showDetailDialog(zoneInfo);
                                showZoneDetailDialog(context, api, zoneInfo.zoneId);
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
