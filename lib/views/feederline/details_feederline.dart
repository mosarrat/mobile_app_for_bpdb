import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../api/feederline_api.dart';
import '../../models/feederlines_lookup/feederline.dart';
import '../../models/feederlines_lookup/feederline_byid.dart';
import '../../widgets/widgets/fieldset_legend.dart';

Future<void> showDetailDialog(BuildContext context, CallApiService apiService,
    FeederLines feederline) async {
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
                "FeederLine Details",
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
        content: FutureBuilder<FeederLinesById>(
          future: apiService.fetchFeederLineDetails(feederline.feederLineId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              final detailedFeederLine = snapshot.data!;
              return SingleChildScrollView(
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
                        ////////////////////////////////// -------- Region Information -------- ///////////////////////////////
                        Theme(
                          data: ThemeData().copyWith(
                            //dividerColor: Colors.transparent,
                            iconTheme: const IconThemeData(color: Colors.white),
                          ),
                          child: ExpansionTile(
                            collapsedBackgroundColor:
                                const Color.fromARGB(255, 223, 240, 243),
                            title: const Text('Region Information'),
                            // tilePadding: EdgeInsets.zero, // Removes padding around the title
                            childrenPadding: EdgeInsets
                                .zero, // Removes padding around the children
                            //minTileHeight: 25,
                            //trailing: const SizedBox(),
                            textColor: const Color.fromARGB(255, 5, 161, 182),
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // "zoneId"
                                    Text('Zone: ${detailedFeederLine.zoneId ?? ''}'),
                                    const Divider(),
                                    // "circleId"
                                    Text(
                                        'Circle: ${detailedFeederLine.circleId ?? ''}'),
                                    const Divider(),
                                    // "sndId"
                                    Text('SND: ${detailedFeederLine.sndId ?? ''}'),
                                    const Divider(),
                                    // "esuId"
                                    Text('ESU: ${detailedFeederLine.esuId?? ''}'),
                                    const Divider(),
                                    // "sourceSubstationId"
                                    Text(
                                        'Source Substation: ${detailedFeederLine.sourceSubstationId ?? ''}'),
                                    const Divider(),
                                    // "destinationSubstationId"
                                    Text(
                                        'Destination Substation: ${detailedFeederLine.destinationSubstationId ?? ''}'),
                                    const Divider(),
                                    // "servicesPointId"
                                    // Text(
                                    //     'Services Point: ${detailedFeederLine.servicesPointId}'),
                                    // const Divider(),
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
                        ////////////////////////////////// -------- Feeder Line Information -------- ///////////////////////////////
                        Theme(
                          data: ThemeData().copyWith(
                            // dividerColor: Colors.transparent,
                            iconTheme: const IconThemeData(color: Colors.white),
                          ),
                          child: ExpansionTile(
                            title: const Text('Feeder Line Information'),
                            // tilePadding: EdgeInsets.zero, // Removes padding around the title
                            childrenPadding: EdgeInsets
                                .zero, // Removes padding around the children
                            //minTileHeight: 25,
                            collapsedBackgroundColor:
                                const Color.fromARGB(255, 241, 245, 245),
                            //trailing: const SizedBox(),
                            textColor: const Color.fromARGB(255, 5, 161, 182),
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // "feederLineId"
                                    Text(
                                      "Feeder Line Id: ${detailedFeederLine.feederLineId.toString()}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Divider(),
                                    // "feederlineName"
                                    Text(
                                        'Feeder line name: ${detailedFeederLine.feederlineName ?? ''}'),
                                    const Divider(),
                                    // "feederLineCode"
                                    Text(
                                        'Feeder Line Code: ${detailedFeederLine.feederLineCode ?? 'N/A'}'),
                                    const Divider(),

                                    // "isGrid"
                                    Text(
                                        'Is Grid: ${detailedFeederLine.isGrid == true ? "Yes" : "No"}'),
                                    const Divider(),
                                    // "gridSubstationInputId"
                                    // Text(
                                    //     'Grid Substation Input: ${detailedFeederLine.gridSubstationInputId}'),
                                    // const Divider(),
                                    // "sourceGridId"
                                    // Text('Source Grid: ${detailedFeederLine.sourceGridId}'),
                                    // const Divider(),
                                    // "feederLineTypeId"
                                    Text(
                                        'Feeder Line Type: ${detailedFeederLine.feederLineTypeId ?? ''}'),
                                    const Divider(),
                                    // "feederConductorTypeId"
                                    Text(
                                        'Feeder Conductor Type: ${detailedFeederLine.feederConductorTypeId ?? ''}'),
                                    // "feederLocation"
                                    const Divider(),
                                    Text(
                                        'Feeder Location: ${detailedFeederLine.feederLocation ?? ''}'),
                                    const Divider(
                                      color: Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ////////////////////////////////// -------- Feeder Line Information -------- ///////////////////////////////
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
                            //trailing: const SizedBox(),
                            textColor: const Color.fromARGB(255, 5, 161, 182),
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // "nominalVoltage"
                                    Text(
                                        'Nominal Voltage: ${detailedFeederLine.nominalVoltage ?? ''}'),
                                    const Divider(),

                                    // "feederMeterNumber"
                                    Text(
                                        'Feeder Meter Number: ${detailedFeederLine.feederMeterNumber ?? ''}'),
                                    const Divider(),
                                    // "meterCurrentRating"
                                    Text(
                                        'Meter Current Rating: ${detailedFeederLine.meterCurrentRating ?? ''}'),
                                    const Divider(),
                                    // "meterVoltageRating"
                                    Text(
                                        'Meter Voltage Rating: ${detailedFeederLine.meterVoltageRating ?? ''}'),
                                    const Divider(),
                                    // "maximumDemand"
                                    Text(
                                        'Maximum Demand: ${detailedFeederLine.maximumDemand ?? ''}'),
                                    const Divider(),
                                    // "peakDemand"
                                    Text(
                                        'Peak Demand: ${detailedFeederLine.peakDemand ?? ''}'),
                                    const Divider(),
                                    // "maximumLoad"
                                    Text(
                                        'Maximum Load: ${detailedFeederLine.maximumLoad ?? ''}'),
                                    const Divider(),
                                    // "sanctionedLoad"
                                    Text(
                                        'Sanctioned Load: ${detailedFeederLine.sanctionedLoad ?? ''}'),
                                    const Divider(),
                                    // "isBulkCustomer"
                                    Text(
                                        'Is Bulk Customer: ${detailedFeederLine.isBulkCustomer ?? ''}'),
                                    const Divider(),
                                    // "bulkCustomerName"
                                    Text(
                                        'Bulk Customer Name: ${detailedFeederLine.bulkCustomerName ?? ''}'),
                                    const Divider(),
                                    // "isPgcbGrid"
                                    Text(
                                        'Is Pgcb Grid: ${detailedFeederLine.isPgcbGrid== true ? "Yes" : "No"}'),
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
                        ////////////////////////////////// -------- Remarks Information -------- ///////////////////////////////
                        Theme(
                          data: ThemeData().copyWith(
                            // dividerColor: Colors.transparent,
                            iconTheme: const IconThemeData(color: Colors.white),
                          ),
                          child: ExpansionTile(
                            title: const Text('Remarks Information'),
                            // tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            //minTileHeight: 25,
                            collapsedBackgroundColor:
                                const Color.fromARGB(255, 241, 245, 245),
                            //trailing: const SizedBox(),
                            textColor: const Color.fromARGB(255, 5, 161, 182),
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // "remarks"
                                    Text(
                                        'Remarks: ${detailedFeederLine.remarks ?? ''}'),
                                    const Divider(
                                      color: Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ////////////////////////////////// -------- Remarks Information -------- ///////////////////////////////
                        const SizedBox(
                          height: 20,
                        ),
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
              );
            }
          },
        ),
        // actions: [
        //   Container(
        //     decoration: BoxDecoration(
        //       color: Colors.orange[900],
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //     child: TextButton(
        //       onPressed: () => Navigator.of(context).pop(),
        //       child: const Text(
        //         'Close',
        //         style: TextStyle(color: Colors.white),
        //       ),
        //     ),
        //   ),
        // ],
      );
    },
  );
}

Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text(
          'Are you sure you want to delete this Feeder Line Information?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
