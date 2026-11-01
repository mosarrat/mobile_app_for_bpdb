import 'package:flutter/material.dart';
import '../../api/region_api.dart';
import '../../models/regions/circle.dart';

Future<void> showCircleDetailDialog(BuildContext context, CallRegionApi api, int? circleId) async {
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
                "Circle Details",
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
        content: FutureBuilder<Circles>(
          future: api.fetchCircleDetails(circleId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              final circleInfo = snapshot.data!;
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
                                label: 'Circle Name', value: circleInfo.circleName.toString(), isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(
                                label: 'Number of S&D', value: circleInfo.totalSnd.toString(), isAlternate: false),
                            const Divider(height: 0),
                             detailContainer(
                                label: 'Number of ESU', value: circleInfo.totalEsu.toString(), isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(
                                label: 'Area',
                                value: '',
                                isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: 'Number of 33KV Feeder Line', value: circleInfo.feeder33KvCount.toString(),  isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(label: 'Number of 11KV Feeder Line', value: circleInfo.feeder11KvCount.toString(),  isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: 'Number of 0.4KV Feeder Line', value: circleInfo.feeder04KvCount.toString(),  isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(label: '33KV Feeder Line Length (m)', value: circleInfo.feeder33KvLength.toString(),  isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: '11KV Feeder Line Length (m)', value: circleInfo.feeder11KvLength.toString(),  isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(label: '0.4KV Feeder Line Length (m)', value: circleInfo.feeder04KvLength.toString(),  isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: 'Total Consumers', value: circleInfo.totalConsumers.toString(),  isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(label: 'Three Phrase Consumers', value: circleInfo.threePhase.toString(),  isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: 'Single Phrase Consumers', value: circleInfo.singlePhase.toString(),  isAlternate: true),
                            const Divider(height: 0),
                            detailContainer(label: 'Number of Pole', value: circleInfo.totalPole.toString(),  isAlternate: false),
                            const Divider(height: 0),
                            detailContainer(label: 'Number of DT', value: circleInfo.totalDT.toString(),  isAlternate: true),
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

