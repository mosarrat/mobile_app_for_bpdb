import 'package:flutter/material.dart';
import '../../api/region_api.dart';
import '../../models/region_delails_lookup/substation.dart';

Future<void> showSubstationDetailDialog(BuildContext context, CallRegionApi api, int? substationId) async {
  showDialog(
    context: context,
    builder: (context) {
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
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Substation Details",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
        content: FutureBuilder<Substations>(
          future: api.fetchSubstationDetails(substationId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              final substationInfo = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      shadowColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2),
                          topRight: Radius.circular(2),
                        ),
                      ),
                      color: Colors.white,
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Divider(height: 0),
                            detailContainer(
                                label: 'Substation Name', value: substationInfo.substationName.toString(), isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(
                                label: 'Substation Type', value: substationInfo.substationTypeName.toString(), isAlternate: false),
                            const Divider(height: 0),
                             detailContainer(
                                label: 'Nominal Voltage (KV)', value: substationInfo.nominalVoltage ?? '', isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(
                                label: 'Installed Capacity (MVA)', value: substationInfo.installedCapacity ?? '', isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: 'Maximum Demand (MW)', value: substationInfo.maximumDemand.toString() ?? '',  isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(label: 'Peak Load (MW)', value: substationInfo.peakLoad.toString() ?? '',  isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: 'Location', value: substationInfo.location.toString() ?? '',  isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(label: 'Area of Substation', value: '',  isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: 'Latitude', value: substationInfo.latitude.toString(),  isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(label: 'Longitude', value: substationInfo.longitude.toString(),  isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: 'Year of Commissioning', value: substationInfo.yearOfComissioning ?? '',  isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(label: 'Number of 11KV Feeder Line', value: substationInfo.feeder11KvCount.toString(),  isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: 'Number of 0.4KV Feeder Line', value: substationInfo.feeder04KvCount.toString(),  isAlternate: true),
                            // const Divider(height: 0),
                            // detailContainer(label: 'Number of Power Transformer', value: '',  isAlternate: false),
                            const Divider(height: 0),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Card(
                                color: const Color.fromARGB(255, 5, 161, 182),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
    },
  );
}


Widget detailContainer({required String label, required String value, bool isAlternate = false}) {
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

