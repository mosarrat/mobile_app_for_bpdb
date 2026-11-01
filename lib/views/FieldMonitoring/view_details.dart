import 'package:flutter/material.dart';

import '../../api/field_monitoring_api.dart';
import '../../models/field_monitoring/field_monitoring.dart';

class ViewfieldDetails extends StatefulWidget {
  final int id;

  const ViewfieldDetails({
    super.key, 
    required this.id,
    });

  @override
  State<ViewfieldDetails> createState() => _ViewfieldDetailsState();
}

class _ViewfieldDetailsState extends State<ViewfieldDetails> {
  late Future<List<FieldMonitoringData>> _futureFMByDetailsId;

  @override
  void initState() {
    super.initState();
    _futureFMByDetailsId = _fetchFMByDetailsId();
  }

  Future<List<FieldMonitoringData>> _fetchFMByDetailsId() async {
    return CallFieldMonitoringApi().fetchFMByDetailsId(widget.id);
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
              "Field Monitoring Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            //SizedBox(height: 10),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Column(
                children: [
                  FutureBuilder<List<FieldMonitoringData>>(
                    future: _futureFMByDetailsId,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } 
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } 
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No field monitoring data found'));
                      }
                      final fmDetails = snapshot.data!;
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: fmDetails.map((fmData) {
                            return Card(
                              child: Padding(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Application Tracking Number',
                                        value: fmData.applicationTrackingNumber ?? '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Applicant Name',
                                        value: fmData.applicantName ?? '',
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Applicant NID',
                                        value: fmData.applicantNid ?? '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Applicant Mobile',
                                        value: fmData.applicantMobile ?? '',
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Land Document Status',
                                        value: fmData.isLandDocumentOk == true ? 'Yes' : 'No',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Latitude',
                                        value: fmData.meterLatitude.toString(),
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Longitude',
                                        value: fmData.meterLongitude.toString(),
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Previous Connection Status',
                                        value: fmData.hasPreviousConnection == true ? 'Yes' : 'No',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Arrear Status',
                                        value: fmData.arrearStatus ??
                                            '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Distance from Nearest Pole',
                                        value: fmData.distanceFromNearestPole?.toString() ??
                                            '',
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Estimated Load',
                                        value:
                                            fmData.estimatedLoad?.toString() ??
                                                '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Submit Date',
                                        value: fmData.submitDate?.toString() ??
                                            '',
                                        isAlternate: false),
                                    
                                    const SizedBox(height: 20),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                         
                                          Card(
                                            color: const Color.fromARGB(
                                                255, 5, 161, 182),
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                              bottom: 10,
                                            ),
                                            child: TextButton(
                                              child: const Text(
                                                'Close',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                              ),
                            );
                          }).toList(),
                        );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // actions: <Widget>[
      //   TextButton(
      //     child: const Text('Close'),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ],
    );
  }
}

Widget detailContainer(
    {required String label, required String value, bool isAlternate = false}) {
  return Container(
    width: double.infinity,
    height: 40,
    color: isAlternate
        ? const Color.fromARGB(255, 223, 240, 243)
        : const Color.fromARGB(255, 241, 245, 245),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '$label: $value',
        // style: const TextStyle(
        //   fontWeight: FontWeight.bold,
        // ),
      ),
    ),
  );
}
