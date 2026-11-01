import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/pole_api.dart';
import '../../api/region_api.dart';
import '../../models/consumer_lookup/consumers.dart';
import '../../models/consumer_lookup/single_consumers.dart';
import '../../models/regions/pole.dart';
import 'pole_details_by_poleDetailsId.dart';
import 'pole_details_edit.dart';

class PoleListView extends StatefulWidget {
  final int feederLineId;

  const PoleListView({
    super.key,
    required this.feederLineId,
  });

  @override
  _PoleListViewState createState() => _PoleListViewState();
}

class _PoleListViewState extends State<PoleListView> {
  final CallPoleApi api = CallPoleApi();
  late Future<List<Pole>> _futurePoles;

  @override
  void initState() {
    super.initState();
    _futurePoles = _fetchPoles();
  }

  Future<List<Pole>> _fetchPoles() async {
    return CallPoleApi().fetchPoleInfo(
      widget.feederLineId,
    );
  }

////////////////////--------View Details Comsumer Pop-up----------////////////////////////
  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          'Pole Information',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<Pole>>(
        future: _futurePoles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Pole available!'));
          } else {
            // Filter the list based on search query

            List<Pole> Poles = snapshot.data!;

            return ListView.builder(
              itemCount: Poles.length + 1,
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
                        'Total Poles: ${Poles.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }
                Pole poleInfo = Poles[index - 1];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      "Pole Id: ${poleInfo.poleDetailsId.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Pole Code: ${poleInfo.poleCode}\r\nPole Unique Code: ${poleInfo.poleUniqueCode}',
                      style: const TextStyle(height: 1.5),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'Edit Details',
                          child: Container(
                            height: 27,
                            width: 27,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              iconSize: 12,
                              icon: const Icon(
                                Icons.edit_square,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return EditPolePopup(
                                      poleId: poleInfo.poleId,
                                      poleDetailsId: poleInfo.poleDetailsId,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
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
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ShowDetailDialog(
                                      poleId: poleInfo.poleId,
                                      poleDetailsId: poleInfo.poleDetailsId,
                                    );
                                  },
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
