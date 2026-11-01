import 'package:flutter/material.dart';

import '../../api/field_monitoring_api.dart';
import '../../dashboard.dart';
import '../../models/field_monitoring/field_monitoring.dart';
import 'view_details.dart';

class ViewFieldMonitoringData extends StatefulWidget {
  const ViewFieldMonitoringData({super.key});

  @override
  State<ViewFieldMonitoringData> createState() => _ViewFieldMonitoringDataState();
}

class _ViewFieldMonitoringDataState extends State<ViewFieldMonitoringData> {
  final CallFieldMonitoringApi apiService = CallFieldMonitoringApi();
  // late Future<List<PoleSection>> _futurePoleSections;
  Future<List<FieldMonitoringData>>? _futureData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _futureData = _fetchData();
  }

  Future<List<FieldMonitoringData>> _fetchData() async {
    return CallFieldMonitoringApi().fetchFMData();
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
          'Field Monitoring Data',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<FieldMonitoringData>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Feeder Line available!'));
          } else {
            // Filter the list based on search query

            List<FieldMonitoringData> fmData = snapshot.data!;

            return ListView.builder(
              itemCount: fmData.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Static card at the top
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    color: Colors.lightBlue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total Data: ${fmData.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }
                FieldMonitoringData item = fmData[index - 1];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      "Application Traking Number: ${item.applicationTrackingNumber ?? 'N/A'}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Applicant Name: ${item.applicantName ?? 'N/A'}\n"
                      "Applicant Mobile: ${item.applicantMobile ?? 'N/A'}\n",
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
                                        ViewfieldDetails(
                                          id: item.applicationId!,
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