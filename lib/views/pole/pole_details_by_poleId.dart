import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/pole_api.dart';
import '../../models/region_delails_lookup/poleId.dart';


class ShowDetailDialog extends StatefulWidget {
  final int poleId;

  const ShowDetailDialog({
    super.key,
    required this.poleId,
  });

  @override
  State<ShowDetailDialog> createState() => _ShowDetailDialogState();
}

class _ShowDetailDialogState extends State<ShowDetailDialog> {
  late Future<List<PoleDetailByID>> _futurePolesById;


  @override
  void initState() {
    super.initState();
    _futurePolesById = _fetchPolesById();
  }

  Future<List<PoleDetailByID>> _fetchPolesById() async {
    return CallPoleApi().fetchPolesById(widget.poleId);
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
              "Pole Details",
              style: TextStyle(
                fontSize: 25,
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
          mainAxisSize: MainAxisSize.min,
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
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                children: [
                  FutureBuilder<List<PoleDetailByID>>(
                    future: _futurePolesById,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final poles = snapshot.data!;
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: poles.map((pole) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ////////////////////////////////// -------- Pole Unique Information -------- ///////////////////////////////
                                Container(
                                        // margin: const EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   'Pole Id: ${pole.poleId.toString()}',
                                            //   style: const TextStyle(
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Pole Id', value: pole.poleId.toString(), isAlternate: true),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Pole Type', value: '${pole.poleTypeName}', isAlternate: false),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Pole Condition', value: '${pole.conditionName}', isAlternate: true),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Pole Number', value: pole.poleNumber ?? '', isAlternate: false),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Pole Height', value: pole.poleHeight?.toString() ?? '', isAlternate: true),
                                            const Divider(height: 0),
                                            detailContainer(label: 'No of Wire Ht', value: pole.noOfWireHt?.toString() ?? '', isAlternate: false),
                                            const Divider(height: 0),
                                            detailContainer(label: 'No of Wire Lt', value: pole.noOfWireLt?.toString() ?? '', isAlternate: true),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Msj No.', value: pole.msjNo ?? '', isAlternate: false),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Sleeve No.', value: pole.sleeveNo ?? '', isAlternate: true),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Twist No.', value: pole.twistNo ?? '', isAlternate: false),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Street Light', value: pole.streetLight.toString() == true ? "Yes" : "No", isAlternate: true),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Transformer Exist', value: pole.transformerExist.toString() == true ? "Yes" : "No", isAlternate: false),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Common Pole', value: pole.commonPole.toString() == true ? "Yes" : "No", isAlternate: true),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Tap', value: pole.tap.toString() == true ? "Yes" : "No", isAlternate: false),
                                            const Divider(height: 0),
                                            
                                            detailContainer(label: 'No of Line 11Kv', value: pole.noOfLine11Kv?.toString() ?? '', isAlternate: true),
                                            const Divider(height: 0),
                                            detailContainer(label: 'No of Line P4Kv', value: pole.noOfLineP4Kv?.toString() ?? '', isAlternate: false),
                                            const Divider(height: 0),
                                            detailContainer(label: 'No of Line 33Kv', value: pole.noOfLine33Kv?.toString() ?? '', isAlternate: true),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Latitude', value: pole.latitude.toString(), isAlternate: false),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Longitude', value: pole.longitude.toString(), isAlternate: true),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Surveyor Name', value: pole.surveyorName, isAlternate: false),
                                            const Divider(height: 0),
                                            detailContainer(label: 'Survey Date', value: pole.surveyDate != null ? DateFormat('dd-MMM-yyyy').format(pole.surveyDate!) : 'N/A', isAlternate: true),

                                          ],
                                        ),
                                      ),
                                ////////////////////////////////// -------- Pole Unique Information  -------- ///////////////////////////////
                              
                              ],
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('No data found');
                      }
                    },
                  ),

                  const SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [                          
                          Card(
                            color: const Color.fromARGB(255, 5, 161, 182),
                            margin: const EdgeInsets.only(right: 10, bottom: 10,),
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
                        ],
                      ),
                    ), 
                ],
              ),
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
      ),
    ),
  );
}
}
