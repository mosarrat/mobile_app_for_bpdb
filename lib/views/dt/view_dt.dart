import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/dt_api.dart';
import '../../constants/constant.dart';
import '../../models/dt_lookup/dt_info.dart';
import 'dt_details_info.dart';
import 'edit_dt.dart';

class DTListView extends StatefulWidget {
  final int substation;
  final int feederLineId;

  const DTListView({
    super.key,
    required this.substation,
    required this.feederLineId,
  });

  @override
  State<DTListView> createState() => _DTListViewState();
}

class _DTListViewState extends State<DTListView> {
  final CallDTApi apiCall = CallDTApi();
  late Future<List<TransformerDetails>> _futureDT;

  @override
  void initState() {
    super.initState();
    _futureDT = _fetchDT();
  }

  void _loadData() {
    setState(() {
      _futureDT = apiCall.fetchDT(
        substation: widget.substation,
        feederLineId: widget.feederLineId,
      );
    });
  }

  Future<List<TransformerDetails>> _fetchDT() async {
    return CallDTApi().fetchDT(
      substation: widget.substation,
      feederLineId: widget.feederLineId,
    );
  }

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
          'Distribution Transformer Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<TransformerDetails>>(
        future: _futureDT,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Distribution Transformer available!'));
          } else {
            List<TransformerDetails> dts = snapshot.data!;

            return ListView.builder(
              itemCount: dts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Static card at the top
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    color: Colors.lightBlue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total DT: ${dts.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }
                TransformerDetails dtInfo = dts[index - 1];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    title: Text("Distribution Transformer Name: ${dtInfo.dtLocationName ?? ''}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text(
                    //   'Distribution Transformer Code: ${dtInfo.distributionTransformerCode ?? 'N/A'}\n'
                    //   'Pole Detail Left Id: ${dtInfo.poleDetailsLeftId?.toString() ?? 'N/A'}\n'
                    //   'Pole Detail Right Id: ${dtInfo.poleDetailsRightId?.toString() ?? 'N/A'}',
                    //   style: const TextStyle(height: 1.5),
                    // ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'Edit',
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
                                //showEditForm(context, apiCall, consumer);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ShowDtEdit(
                                      dtId: dtInfo.id,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 2),
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
                                      id: dtInfo.id,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                    },
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
