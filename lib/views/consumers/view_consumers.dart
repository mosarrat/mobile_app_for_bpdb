// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
// import 'package:gis_app_bpdb/views/map/map_viewer.dart';
import 'package:intl/intl.dart';
import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';
import '../../models/consumer_lookup/consumers.dart';
import '../../models/consumer_lookup/single_consumers.dart';
import '../map/consumer_map_viewer.dart';
import 'consumer_edit_form.dart';

class ConsumerListView extends StatefulWidget {
  final String field;
  final String value;
  // final int feederLineId;
  // final String consumerNo;

  const ConsumerListView({
    super.key,
    required this.field,
    required this.value,
    // required this.feederLineId,
    // required this.consumerNo,
  });

  @override
  _ConsumerListViewState createState() => _ConsumerListViewState();
}

class _ConsumerListViewState extends State<ConsumerListView> {
  final CallConsumerApi apiCall = CallConsumerApi();
  late Future<List<Consumers>> _futureConsumers;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureConsumers = _fetchConsumers();
  }

  void _loadData() {
    setState(() {
      _futureConsumers = apiCall.fetchConsumers();
    });
  }

  Future<List<Consumers>> _fetchConsumers() async {
    return CallConsumerApi().fetchConsumers(
      // feederLineId: widget.feederLineId,
      // consumerNo: widget.consumerNo,
      field: widget.field,
      value: widget.value,
    );
  }

  void _searchConsumers(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  bool _isMatch(Consumers consumer) {
    String customerName = consumer.customerName.toLowerCase();
    String consumerNo = consumer.consumerNo.toLowerCase();

    return customerName.contains(_searchQuery) ||
        consumerNo.contains(_searchQuery);
  }

////////////////////--------View Details Comsumer Pop-up----------////////////////////////
  void _showConsumerDetails(String consumerNo) async {
    try {
      final consumer =
          await CallApi().fetchConsumerDetail(consumerNo: consumerNo);
      _showDetailsDialog(consumer);
    } catch (e) {
      print(e.toString());

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  void _showDetailsDialog(Consumer consumer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
          contentPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: const Color.fromARGB(255, 5, 161, 182),
          title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Consumer Details",
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
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Card(
              //width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              )),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ////////////////////////////////// -------- Administrative Information -------- ///////////////////////////////
                    Theme(
                      data: ThemeData().copyWith(
                        //dividerColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: Colors.white),
                      ),
                      child: ExpansionTile(
                        collapsedBackgroundColor:
                            const Color.fromARGB(255, 223, 240, 243),
                        title: const Text('Administrative Information'),
                        // tilePadding: EdgeInsets.zero, // Removes padding around the title
                        childrenPadding: EdgeInsets
                            .zero, // Removes padding around the children
                        //minTileHeight: 25,
                        // trailing: const SizedBox(),
                        textColor: const Color.fromARGB(255, 5, 161, 182),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Zone: ${consumer.zoneName}'),
                                // const Divider(),
                                // Text('Circle: ${consumer.circleName}'),
                                // const Divider(),
                                Text('SnD: ${consumer.snDName}'),
                                const Divider(),
                                // Text('ESU: ${consumer.esuName ?? ''}'),
                                // const Divider(),
                                Text('Substation: ${consumer.substationName}'),
                                const Divider(),
                                Text('Feeder Line: ${consumer.feederlineName}'),
                                const Divider(),
                                Text(
                                    'Services Point: ${consumer.servicesPointId}'),
                                const Divider(
                                  color: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ////////////////////////////////// -------- Administrative Information -------- ///////////////////////////////
                    ////////////////////////////////// -------- Consumer Information -------- ///////////////////////////////
                    Theme(
                      data: ThemeData().copyWith(
                        // dividerColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: Colors.white),
                      ),
                      child: ExpansionTile(
                        title: const Text('Consumer Information'),
                        // tilePadding: EdgeInsets.zero, // Removes padding around the title
                        childrenPadding: EdgeInsets
                            .zero, // Removes padding around the children
                        //minTileHeight: 25,
                        collapsedBackgroundColor:
                            const Color.fromARGB(255, 241, 245, 245),
                        // trailing: const SizedBox(),
                        textColor: const Color.fromARGB(255, 5, 161, 182),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Consumer No.: ${consumer.consumerNo}'),
                                const Divider(),
                                Text(
                                    'Consumer Type: ${consumer.consumerTypeName}'),
                                const Divider(),
                                Text('Consumer Name: ${consumer.customerName}'),
                                const Divider(),
                                Text('Consumer NID: ${consumer.customerNid}'),
                                const Divider(),
                                Text(
                                    'Consumer Father Name: ${consumer.fatherName}'),
                                const Divider(),
                                Text('Mobile: ${consumer.mobileNo ?? 'N/A'}'),
                                const Divider(),
                                Text(
                                    'Address: ${consumer.customerAddress ?? 'N/A'}'),
                                const Divider(),
                                Text(
                                    'Premise Name: ${consumer.premiseName ?? 'N/A'}'),
                                const Divider(),
                                const Divider(
                                  color: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ////////////////////////////////// -------- Consumer Information -------- ///////////////////////////////
                    ////////////////////////////////// -------- Meter Information Information -------- ///////////////////////////////
                    Theme(
                      data: ThemeData().copyWith(
                        // dividerColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: Colors.white),
                      ),
                      child: ExpansionTile(
                        title: const Text('Meter Information'),
                        // tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        //minTileHeight: 25,
                        collapsedBackgroundColor:
                            const Color.fromARGB(255, 223, 240, 243),
                        // trailing: const SizedBox(),
                        textColor: const Color.fromARGB(255, 5, 161, 182),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Meter Number: ${consumer.meterNumber}'),
                                const Divider(),
                                Text('Meter Model: ${consumer.meterModel}'),
                                const Divider(),
                                Text(
                                    'Meter Manufacturer: ${consumer.meterManufacturer}'),
                                const Divider(),
                                Text('Meter Type: ${consumer.meterTypeName}'),
                                const Divider(),
                                // Text(
                                //     'Phasing Code: ${consumer.phasingCodeName}'),
                                // const Divider(),
                                // Text(
                                //     'Operating Voltage: ${consumer.operatingVoltageName}'),
                                // const Divider(),

                                // Text(
                                //   'Install Date: ${consumer.installDate != null ? DateFormat('dd-MMM-yyyy').format(consumer.installDate!) : 'N/A'}',
                                // ),
                                const Divider(
                                  color: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ////////////////////////////////// -------- Meter Information Information -------- ///////////////////////////////
                    ////////////////////////////////// -------- Tariff Information -------- ///////////////////////////////
                    Theme(
                      data: ThemeData().copyWith(
                        // dividerColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: Colors.white),
                      ),
                      child: ExpansionTile(
                        title: const Text('Tariff Information'),
                        // tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        //minTileHeight: 25,
                        collapsedBackgroundColor:
                            const Color.fromARGB(255, 241, 245, 245),
                        // trailing: const SizedBox(),
                        textColor: const Color.fromARGB(255, 5, 161, 182),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tariff: ${consumer.tariff}'),
                                const Divider(
                                  color: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ////////////////////////////////// -------- Tariff Information -------- ///////////////////////////////
                    ////////////////////////////////// -------- Connection, Business, Bill, Services Information -------- ///////////////////////////////
                    Theme(
                      data: ThemeData().copyWith(
                        // dividerColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: Colors.white),
                      ),
                      child: ExpansionTile(
                        title: const Text(
                            'Connection, Business, Bill, Services Information'),
                        // tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        //minTileHeight: 25,
                        collapsedBackgroundColor:
                            const Color.fromARGB(255, 223, 240, 243),
                        // trailing: const SizedBox(),
                        textColor: const Color.fromARGB(255, 5, 161, 182),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const Text('Location:'),
                                // const Divider(),
                                Text(
                                    'Connection Status: ${consumer.connectionStatusName}'),
                                const Divider(),
                                Text(
                                    'Business Type: ${consumer.businessTypeName}'),
                                const Divider(),
                                Text(
                                    'Connected Pole no.: ${consumer.poleNo ?? 'N/A'}'),
                                const Divider(),
                                Text(
                                    'Service Cable Type: ${consumer.serviceCableTypeName ?? 'N/A'}'),
                                const Divider(),
                                Text(
                                    'Service Cable Size: ${consumer.serviceCableSize}'),
                                const Divider(),
                                Text(
                                    'Phasing Code: ${consumer.phasingCodeName}'),
                                const Divider(),
                                Text(
                                    'Sanction Load: ${consumer.sanctionedLoad} kW'),
                                const Divider(),
                                Text(
                                    'Connected Load: ${consumer.connectedLoad} kW'),
                                const Divider(),
                                Text('Latitude: ${consumer.latitude}'),
                                const Divider(),
                                Text('Longitude: ${consumer.longitude}'),
                                const Divider(),
                                Text(
                                    'Distance from SP: ${consumer.distanceFromSp ?? 'N/A'} m'),
                                const Divider(),
                                Text(
                                    'Distance from DT: ${consumer.distanceFromDt ?? 'N/A'} m'),
                                const Divider(),

                                const Divider(
                                  color: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ////////////////////////////////// -------- Connection, Business, Bill, Services Information -------- ///////////////////////////////
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
                                    builder: (context) => ConsumerMapViewer(
                                      title: 'Consumer Map View',
                                      consumerNo: consumer.consumerNo,
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
            ),
          ),
          ///////////////////////////
        );
      },
    );
  }

////////////////////--------View Details Comsumer Pop-up----------////////////////////////
  @override
  Widget build(BuildContext context) {
    User? user = globalUser;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          'Consumers List',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: TextField(
          //     controller: _searchController,
          //     decoration: InputDecoration(
          //       hintText: 'Search consumers...',
          //       prefixIcon: const Icon(Icons.search),
          //       suffixIcon: _searchController.text.isNotEmpty
          //           ? IconButton(
          //               icon: const Icon(Icons.clear),
          //               onPressed: () {
          //                 _searchController.clear();
          //                 _searchConsumers('');
          //               },
          //             )
          //           : null,
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(16),
          //       ),
          //     ),
          //     onChanged: _searchConsumers,
          //   ),
          // ),

          Expanded(
            child: FutureBuilder<List<Consumers>>(
              future: _futureConsumers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No consumers available!'));
                } else {
                  // Filter the list based on search query
                  // List<Consumers> filteredConsumers = snapshot.data!
                  //     .where((consumer) => _isMatch(consumer))
                  //     .toList();

                  // if (filteredConsumers.isEmpty) {
                  //   return const Center(
                  //       child: Text('No matching consumers found!'));
                  // }
                  List<Consumers> consumers = snapshot.data!;
                  // print("Total Consumers: ${consumers.length}");

                  return ListView.builder(
                    itemCount: consumers.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Static card at the top
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          color: Colors.lightBlue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Total Consumers: ${consumers.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }
                      // Consumers consumer = consumers[index];
                      Consumers consumer = consumers[index - 1];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(
                            "Consumer Name: ${consumer.customerName}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Consumer No: ${consumer.consumerNo}\r\nMeter Number: ${consumer.poleDetailsId}',
                            style: const TextStyle(height: 1.5),
                          ),
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
                                          return ShowConsumerEdit(
                                            consumerId: consumer.consumerId,
                                            consumerNo: consumer.consumerNo,
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
                                      _showConsumerDetails(consumer.consumerNo);
                                    },
                                  ),
                                ),
                              ),
                              //////
                              //const SizedBox(height: 2),
                              // const SizedBox(width: 2),
                              // if(user?.GroupId == 1)
                              // Tooltip(
                              //   message: 'Delete Data',
                              //   child: Container(
                              //     height: 27,
                              //     width: 27,
                              //     decoration: const BoxDecoration(
                              //       color: Colors.red,
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: IconButton(
                              //       iconSize: 12,
                              //       icon: const Icon(
                              //         Icons.delete,
                              //         color: Colors.white,
                              //       ),
                              //       onPressed: () async {
                              //         if (consumer.consumerNo != null) {
                              //           final shouldDelete =
                              //               await showDeleteConfirmationDialog(
                              //                   context);
                              //           if (shouldDelete == true) {
                              //             try {
                              //               await apiCall
                              //                   .deleteData(consumer.consumerNo!);
                              //               Navigator.push(
                              //                 context,
                              //                 MaterialPageRoute(
                              //                     builder: (context) => const FilterConsumers()),
                              //               );

                              //               ScaffoldMessenger.of(context)
                              //                   .showSnackBar(
                              //                 const SnackBar(
                              //                     content: Text(
                              //                         'Consumer Info Deleted Successfully'),
                              //                     backgroundColor: Colors.green),
                              //               );
                              //             } catch (error) {
                              //               print(
                              //                   'Error deleting Consumer: $error');
                              //               ScaffoldMessenger.of(context)
                              //                   .showSnackBar(
                              //                 SnackBar(
                              //                     content: Text(
                              //                         'Failed to delete Consumer: $error')),
                              //               );
                              //             }
                              //           }
                              //         } else {
                              //           print(
                              //               'Consumer No is null, cannot delete.');
                              //           ScaffoldMessenger.of(context).showSnackBar(
                              //             const SnackBar(
                              //                 content: Text(
                              //                     'Cannot delete: Consumer No Id is null')),
                              //           );
                              //         }
                              //       },
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          onTap: () {
                            // Handle tap on ListTile (navigate to detail screen, etc.)
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
