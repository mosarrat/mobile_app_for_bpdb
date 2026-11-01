import 'package:flutter/material.dart';
import '../../api/dt_api.dart';
import '../../models/dt_lookup/dt_details.dart';
import '../map/dt_map_viewer.dart';

class ShowDetailDialog extends StatefulWidget {
  final int id;

  const ShowDetailDialog({
    super.key,
    required this.id,
  });

  @override
  State<ShowDetailDialog> createState() => _ShowDetailDialogState();
}

class _ShowDetailDialogState extends State<ShowDetailDialog> {
  late Future<List<Transformer>> _futureDTByDetailsId;
  late double latitude;
  late double longitude;
  late int DTId;
  late String dtCode;
  late String dtLocation;
  late int zone;
  late int circle;
  late int snd;
  late int substation;
  late int feederline;

  @override
  void initState() {
    super.initState();
    _futureDTByDetailsId = _fetchDTByDetailsId();
  }

  Future<List<Transformer>> _fetchDTByDetailsId() async {
    return CallDTApi().fetchDTByDetailsId(widget.id);
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
              "Distribution Transformer Details",
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
                  FutureBuilder<List<Transformer>>(
                    future: _futureDTByDetailsId,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } 
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } 
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No transformer data found'));
                      }
                      final dtDetails = snapshot.data!;
                        if (dtDetails.isNotEmpty) {
                          DTId = dtDetails.first.id ?? 0;
                          zone = dtDetails.first.zoneId ?? 0;
                          circle = dtDetails.first.circleId ?? 0;
                          snd = dtDetails.first.snDId ?? 0;
                          substation = dtDetails.first.substationId ?? 0;
                          feederline = dtDetails.first.feederlineId ?? 0;
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: dtDetails.map((transformer) {
                            return Card(
                              child: Padding(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'DT Name',
                                        value: transformer.dtLocationName ?? '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Snd',
                                        value: transformer.snDName ?? '',
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Substation',
                                        value: transformer.substationName ?? '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Feeder Line',
                                        value: transformer.feederlineName ?? '',
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'DT Location Name',
                                        value: transformer.dtLocationName ?? ''
                                            .toString(),
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Latitude',
                                        value: transformer.latitude.toString(),
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Longitude',
                                        value: transformer.longitude.toString(),
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Nearest Holding/House No/Shop',
                                        value: transformer
                                                .nearestHoldingHouseNoShop ??
                                            '',
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Installed Condition ',
                                        value: transformer
                                                .installedConditionName ??
                                            '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Install Place',
                                        value: transformer.installedPlaceName ??
                                            '',
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Owner of the Transformer ',
                                        value:
                                            transformer.transformerOwnerName ??
                                                '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Transformer KVA Rating',
                                        value: transformer.transformerKvaRating?.toString() ?? '',
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Name of Manufacturer',
                                        value: transformer.nameofManufacturer ??
                                            '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Rated Power',
                                        value: '',
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Impedance',
                                        value: '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'No of Phrase',
                                        value: '',
                                        isAlternate: false),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Vector Group',
                                        value: '',
                                        isAlternate: true),
                                    const Divider(height: 0),
                                    detailContainer(
                                        label: 'Rated Frequency',
                                        value: '',
                                        isAlternate: false),
                                    const Divider(height: 0),
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
                                                'Open Map View',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DTMapViewer(
                                                      title: 'DT Map View',
                                                      dtId: DTId,
                                                      zone: zone,
                                                      circle: circle,
                                                      snd: snd,
                                                      substationId: substation,
                                                      feederlineId: feederline,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
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
