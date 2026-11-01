import 'package:flutter/material.dart';
import "package:carousel_slider/carousel_slider.dart";
import 'package:intl/intl.dart';
import '../../api/pole_api.dart';
import '../../models/region_delails_lookup/poleDetailsId.dart';
import '../../models/region_delails_lookup/poleId.dart';
import '../../models/region_delails_lookup/pole_image.dart';
import '../../constants/constant.dart';
import '../map/pole_map_viewer.dart';


class ShowDetailDialog extends StatefulWidget {
  final int poleId;
  final int poleDetailsId;

  const ShowDetailDialog({
    super.key,
    required this.poleId,
    required this.poleDetailsId,
  });

  @override
  State<ShowDetailDialog> createState() => _ShowDetailDialogState();
}

class _ShowDetailDialogState extends State<ShowDetailDialog> {
  late Future<List<PoleDetails>> _futurePolesByDetailsId;
  late Future<List<PoleDetailByID>> _futurePolesById;
  late Future<List<PoleImage>> _futurePoleImg;
  late double latitude;
  late double longitude;
  late int poleDetailsId;
  late String poleCode;
  late int zone;
  late int circle;
  late int snd;
  late int substation;
  late int feederline;
  late int linetypeId;

  @override
  void initState() {
    super.initState();
    _futurePolesByDetailsId = _fetchPolesByDetailsId();
    _futurePolesById = _fetchPolesById();
    _futurePoleImg = _fetchPoleImage();
  }

  Future<List<PoleDetails>> _fetchPolesByDetailsId() async {
    return CallPoleApi().fetchPolesByDetailsId(widget.poleDetailsId);
  }

  Future<List<PoleDetailByID>> _fetchPolesById() async {
    return CallPoleApi().fetchPolesById(widget.poleId);
  }

  Future<List<PoleImage>> _fetchPoleImage() async {
    return CallPoleApi().fetchPoleImage(widget.poleId);
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
                  FutureBuilder<List<PoleDetails>>(
                    future: _futurePolesByDetailsId,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final poleDetails = snapshot.data!;
                        if (poleDetails.isNotEmpty) {
                          // Update global variables with the first pole's latitude and longitude
                          poleDetailsId = poleDetails.first.poleDetailsId;
                          poleCode = poleDetails.first.poleCode;
                          zone = poleDetails.first.zoneId;
                          circle = poleDetails.first.circleId;
                          snd = poleDetails.first.sndId;
                          substation = poleDetails.first.substationId;
                          feederline = poleDetails.first.feederLineId;
                          linetypeId = poleDetails.first.lineTypeId;
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: poleDetails.map((poleDetail) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ////////////////////////////////// -------- Region Information -------- ///////////////////////////////
                                Theme(
                                  data: ThemeData().copyWith(
                                    //dividerColor: Colors.transparent,
                                    iconTheme: const IconThemeData(
                                        color: Colors.white),
                                  ),
                                  child: ExpansionTile(
                                    title: const Text('Region Information'),
                                    // tilePadding: EdgeInsets.zero,
                                    childrenPadding: EdgeInsets.zero,
                                    //minTileHeight: 25,
                                    collapsedBackgroundColor:
                                        const Color.fromARGB(
                                            255, 223, 240, 243),
                                    // trailing: const SizedBox(),
                                    textColor:
                                        const Color.fromARGB(255, 5, 161, 182),
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Zone Info: ${poleDetail.zoneName}'),
                                            const Divider(),
                                            Text(
                                                'Circle Info: ${poleDetail.circleName}'),
                                            const Divider(),
                                            Text(
                                                'SnD Info: ${poleDetail.snDName}'),
                                            const Divider(),
                                            Text(
                                                'Esu Info: ${poleDetail.esuName ?? ""}'),
                                            const Divider(),
                                            Text(
                                                'Substation Info: ${poleDetail.substationName}'),
                                            const Divider(),
                                            Text(
                                                'Feeder Line Info: ${poleDetail.feederlineName}'),
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ////////////////////////////////// -------- Region Information -------- ///////////////////////////////
                                ////////////////////////////////// -------- Feeder Wise Pole Information -------- ///////////////////////////////
                                Theme(
                                  data: ThemeData().copyWith(
                                    // dividerColor: Colors.transparent
                                    iconTheme: const IconThemeData(
                                        color: Colors.white),
                                  ),
                                  child: ExpansionTile(
                                    title: const Text(
                                        'Feeder Wise Pole Information'),
                                    childrenPadding: EdgeInsets.zero,
                                    //minTileHeight: 25,
                                    collapsedBackgroundColor:
                                        const Color.fromARGB(
                                            255, 241, 245, 245),
                                    // trailing: const SizedBox(),
                                    textColor:
                                        const Color.fromARGB(255, 5, 161, 182),
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   'Pole Detail Id: ${poleDetail.poleDetailsId.toString()}',
                                            //   style: const TextStyle(
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                            // const Divider(),
                                            Text(
                                                'Pole Code: ${poleDetail.poleCode}'),
                                            const Divider(),
                                            // Text(
                                            //     'Pole Unique Code: ${poleDetail.poleUniqueCode}'),
                                            // const Divider(),
                                            // Text(
                                            //     'Feeder Wise Serial No. : ${poleDetail.feederWiseSerialNo}'),
                                            // const Divider(),
                                            Text(
                                                'Pole No. : ${poleDetail.poleNo}'),
                                            const Divider(),
                                            Text(
                                                'Previous Pole No. : ${poleDetail.previousPoleNo}'),
                                            const Divider(),
                                            Text(
                                                'Line Type: ${poleDetail.lineTypeName}'),
                                            const Divider(),
                                            Text(
                                                'Type of Wire : ${poleDetail.name}'),
                                            const Divider(),
                                            Text(
                                                'Wire Length (m): ${poleDetail.wireLength ?? ""}',),
                                            const Divider(),
                                            // Text(
                                            //     'Wire Condition Id: ${poleDetail.wireConditionId}'),
                                            // const Divider(),
                                            // Text(
                                            //     'Back Span: ${poleDetail.backSpan}'),
                                            // const Divider(),
                                            // Text(
                                            //     'Phase A Id: ${poleDetail.phaseAId}'),
                                            // const Divider(),
                                            // Text(
                                            //     'Phase B Id: ${poleDetail.phaseBId}'),
                                            // const Divider(),
                                            // Text(
                                            //     'Phase C Id: ${poleDetail.phaseCId}'),
                                            // const Divider(),
                                            Text(
                                                'Neutral: ${poleDetail.neutral == true ? "Yes" : "No"}'),
                                            const Divider(),
                                            Text(
                                                'Is Right Pole: ${poleDetail.isRightPole == true ? "Yes" : "No"}'),
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ///////////////////////////////////// -------- Feeder Wise Pole  Information -------- ////////////////////////////
                              ],
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('No data found');
                      }
                    },
                  ),

                  FutureBuilder<List<PoleDetailByID>>(
                    future: _futurePolesById,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final poles = snapshot.data!;
                        if (poles.isNotEmpty) {
                          // Update global variables with the first pole's latitude and longitude
                          latitude = poles.first.latitude;
                          longitude = poles.first.longitude;
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: poles.map((pole) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ////////////////////////////////// -------- Pole Unique Information -------- ///////////////////////////////
                                Theme(
                                  data: ThemeData().copyWith(
                                    //dividerColor: Colors.transparent
                                    iconTheme: const IconThemeData(
                                        color: Colors.white),
                                  ),
                                  child: ExpansionTile(
                                    title:
                                        const Text('Pole Unique Information '),
                                    childrenPadding: EdgeInsets.zero,
                                    //minTileHeight: 25,
                                    collapsedBackgroundColor:
                                        const Color.fromARGB(
                                            255, 223, 240, 243),
                                    // trailing: const SizedBox(),
                                    textColor:
                                        const Color.fromARGB(255, 5, 161, 182),
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 20),
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
                                            Text(
                                                'pole Number: ${pole.poleNumber ?? ""}'),
                                            const Divider(),
                                            Text(
                                                'Pole Type: ${pole.poleTypeName}'),
                                            const Divider(),
                                            Text(
                                                'Pole condition: ${pole.conditionName}'),
                                            const Divider(),
                                            Text(
                                                'No of Wire Ht: ${pole.noOfWireHt ?? ''}'),
                                            const Divider(),
                                            Text(
                                                'No of Wire Lt: ${pole.noOfWireLt ?? ''}'),
                                            const Divider(),
                                            Text('Msj No. : ${pole.msjNo ?? ''}'),
                                            const Divider(),
                                            // Text(
                                            //     'Sleeve No. : ${pole.sleeveNo ?? ''}'),
                                            // const Divider(),
                                            // Text('Twist No. : ${pole.twistNo ?? ''}'),
                                            // const Divider(),
                                            Text(
                                                'Street Light: ${pole.streetLight == true ? "Yes" : "No"}'),
                                            const Divider(),
                                            Text(
                                                'Transformer Exist: ${pole.transformerExist == true ? "Yes" : "No"}'),
                                            const Divider(),
                                            Text(
                                                'Common Pole: ${pole.commonPole == true ? "Yes" : "No"}'),
                                            const Divider(),
                                            Text('Tap: ${pole.tap == true ? "Yes" : "No"}'),
                                            const Divider(),
                                            Text(
                                                'Pole Height: ${pole.poleHeight ?? ""}'),
                                            const Divider(),
                                            Text(
                                                'No of Line 11Kv: ${pole.noOfLine11Kv ?? ""}'),
                                            const Divider(),
                                            Text(
                                                'No of Line P4Kv: ${pole.noOfLineP4Kv ?? ""}'),
                                            const Divider(),
                                            Text(
                                                'No of Line 33Kv: ${pole.noOfLine33Kv ?? ""}'),
                                            const Divider(),
                                            Text('Latitude: ${pole.latitude}'),
                                            const Divider(),
                                            Text(
                                                'Longitude: ${pole.longitude}'),
                                            const Divider(),
                                            Text(
                                                'Surveyor Name: ${pole.surveyorName}'),
                                            const Divider(),
                                            Text(
                                              'Survey Date: ${pole.surveyDate != null ? DateFormat('dd-MMM-yyyy').format(pole.surveyDate!) : 'N/A'}',
                                            ),
                                            
                                            const Divider(
                                              color: Colors.transparent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ////////////////////////////////// -------- Pole Unique Information  -------- ///////////////////////////////
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const Text(
                                    'Images: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('No data found');
                      }
                    },
                  ),

                  //////////////////////////// Image Handeling /////////////////////////////
                  FutureBuilder<List<PoleImage>>(
                    future: _futurePoleImg,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final poles = snapshot.data!;

                        if (poles.isEmpty) {
                          return const Text('No images available');
                        }
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height / 2,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              scrollDirection: Axis.horizontal,
                            ),
                            items: poles.map((poleImg) {
                              // print('Image URL: $poleImgPath/${poleImg.pictureName}');
                              final imageUrl =
                                  '$poleImgPath/${poleImg.pictureName}';
                              return Builder(
                                builder: (BuildContext context) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        );
                      } else {
                        return const Text('No data found');
                      }
                    },
                  ),
                  ////////////////////////////Image Handeling/////////////////////////////
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
                          margin: const EdgeInsets.only(
                            right: 10,
                            bottom: 10,
                          ),
                          child: TextButton(
                            child: const Text(
                              'Open Map View',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PoleMapViewer(
                                    title: 'Pole Map View',
                                    zone: zone,
                                    circle: circle,
                                    snd: snd, 
                                    substationId: substation,
                                    feederlineId: feederline,
                                    poleDetailsId: poleDetailsId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Card(
                          color: const Color.fromARGB(255, 5, 161, 182),
                          margin: const EdgeInsets.only(
                            right: 10,
                            bottom: 10,
                          ),
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
