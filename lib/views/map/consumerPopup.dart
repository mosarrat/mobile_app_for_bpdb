// import 'package:arcgis_maps/arcgis_maps.dart';
// import 'package:flutter/material.dart';

// import '../../api/map_api.dart';

// Graphic? _highlightedFeature;
// GraphicsOverlay? _highlightOverlay;
// final _mapViewController = ArcGISMapView.createController();
// void _clearHighlight() {
//   // Remove highlight graphic if it exists
//   if (_highlightOverlay != null && _highlightedFeature != null) {
//     _highlightOverlay!.graphics.remove(_highlightedFeature);
//     _highlightedFeature = null;
//   }
// }

// void _highlightFeature(ArcGISFeature feature) {
//   ArcGISSymbol? highlightSymbol;

//   final blueLineSymbol = SimpleLineSymbol(
//     color: Colors.blueAccent,
//     width: 2.0,
//     style: SimpleLineSymbolStyle.solid,
//   );

//   if (feature.geometry is Polygon) {
//     highlightSymbol = SimpleFillSymbol(
//       color: Color.fromARGB(0, 0, 0, 0),
//       outline: blueLineSymbol,
//       style: SimpleFillSymbolStyle.solid,
//     );
//   } else if (feature.geometry is Polyline) {
//     highlightSymbol = blueLineSymbol;
//   } else if (feature.geometry is ArcGISPoint) {
//     highlightSymbol = SimpleMarkerSymbol(
//       color: Color.fromARGB(0, 0, 0, 0),
//       size: 16.0,
//       style: SimpleMarkerSymbolStyle.circle,
//     );
//   }

//   if (highlightSymbol != null && feature.geometry != null) {
//     final graphic = Graphic(
//       geometry: feature.geometry,
//       symbol: highlightSymbol,
//     );
//     if (_highlightOverlay == null) {
//       _highlightOverlay = GraphicsOverlay()..id = 'highlight_overlay';
//       _mapViewController.graphicsOverlays.add(_highlightOverlay!);
//     }
//     _highlightOverlay!.graphics.add(graphic);

//     _highlightedFeature = graphic;
//   }
// }

// void _highlightConsumerPoint(double? lat, double? lon) {
//   if (lat == null || lon == null) return;

//   final circleSymbol = SimpleMarkerSymbol(
//     color: Colors.red.withOpacity(0.6),
//     size: 18.0,
//     style: SimpleMarkerSymbolStyle.circle,
//   );

//   final point = ArcGISPoint(
//     x: lon,
//     y: lat,
//     spatialReference: SpatialReference.wgs84,
//   );

//   final graphic = Graphic(
//     geometry: point,
//     symbol: circleSymbol,
//   );

//   if (_highlightOverlay == null) {
//     _highlightOverlay = GraphicsOverlay()..id = 'highlight_overlay';
//     _mapViewController.graphicsOverlays.add(_highlightOverlay!);
//   }

//   _highlightOverlay!.graphics.add(graphic);
//   _highlightedFeature = graphic;
// }

// void showConsumerFeaturePopup(
//   BuildContext context,
//   Map<String, Object?> attributes,
//   String title,
//   String? idKey,
// ) {
//   int selectedRadio = 0; // for tab 2 radio selection
//   final meterTypeName = "${attributes['meterTypeName']}".toLowerCase();
//   final MapApi _mapApi = MapApi();
//   showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(3)),
//       ),
//       contentPadding: const EdgeInsets.all(0),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 30),
//       backgroundColor: const Color.fromARGB(255, 3, 89, 100),
//       title: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 15),
//           ],
//         ),
//       ),
//       content: DefaultTabController(
//         length: 2,
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width * 0.6,
//           height: MediaQuery.of(context).size.height * 0.7,
//           child: Column(
//             children: [
//               // Tab Bar
//               const TabBar(
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.white70,
//                 indicatorColor: Colors.white,
//                 tabs: [
//                   Tab(text: "Details"),
//                   Tab(text: "Billing Info"),
//                 ],
//               ),

//               // Tab Views
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     // ===== TAB 1: Consumer Details =====
//                     SingleChildScrollView(
//                       child: Card(
//                         shadowColor: Colors.transparent,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(2),
//                             topRight: Radius.circular(2),
//                           ),
//                         ),
//                         color: Colors.white,
//                         margin: const EdgeInsets.all(0),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               _attributeContainer(
//                                   title: 'Consumer No',
//                                   label: "${attributes['consumerNo']}"),
//                               _attributeContainer(
//                                   title: 'Customer Name',
//                                   label: "${attributes['customerName']}"),
//                               _attributeContainer(
//                                   title: 'Father Name',
//                                   label: "${attributes['fatherName']}"),
//                               _attributeContainer(
//                                   title: 'Customer NID',
//                                   label: "${attributes['customerNid']}"),
//                               _attributeContainer(
//                                   title: 'Mobile No',
//                                   label: "${attributes['mobileNo']}"),
//                               _attributeContainer(
//                                   title: 'Customer Address',
//                                   label: "${attributes['customerAddress']}"),
//                               _attributeContainer(
//                                   title: 'Consumer Type',
//                                   label: "${attributes['consumerTypeName']}"),
//                               _attributeContainer(
//                                   title: 'Meter Type',
//                                   label: "${attributes['meterTypeName']}"),
//                               _attributeContainer(
//                                   title: 'Meter Number',
//                                   label: "${attributes['meterNumber']}"),
//                               _attributeContainer(
//                                   title: 'Meter Model',
//                                   label: "${attributes['meterModel']}"),
//                               _attributeContainer(
//                                   title: 'Meter Manufacturer',
//                                   label: "${attributes['meterManufacturer']}"),
//                               _attributeContainer(
//                                   title: 'Sub Tariff',
//                                   label: "${attributes['subCategoryName']}"),
//                               _attributeContainer(
//                                   title: 'Phasing Code',
//                                   label: "${attributes['phasingCodeName']}"),
//                               _attributeContainer(
//                                   title: 'Installation Date',
//                                   label: "${attributes['installDate']}"),
//                               _attributeContainer(
//                                   title: 'Sanctioned Load (kW)',
//                                   label: "${attributes['sanctionedLoad']}"),
//                               _attributeContainer(
//                                   title: 'Connected Load (kW)',
//                                   label: "${attributes['connectedLoad']}"),
//                               _attributeContainer(
//                                   title: 'Business Type',
//                                   label: "${attributes['businessTypeName']}"),
//                               _attributeContainer(
//                                   title: 'Latitude',
//                                   label: "${attributes['latitude']}"),
//                               _attributeContainer(
//                                   title: 'Longitude',
//                                   label: "${attributes['longitude']}"),
//                               _attributeContainer(
//                                   title: 'Remarks',
//                                   label: "${attributes['remarks']}"),
//                               const SizedBox(height: 20),
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: TextButton(
//                                   child: const Text(
//                                     'Close',
//                                     style: TextStyle(
//                                       color: Color.fromARGB(255, 3, 89, 100),
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     // ===== TAB 2: Radio Button Options =====

//                     StatefulBuilder(
//                       builder: (context, setState) {
//                         return Container(
//                           color: Colors.white,
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (meterTypeName.contains("postpaid")) ...[
//                                 Text(
//                                   "Merer Type: ${attributes['meterTypeName']}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                                 FutureBuilder<Map<String, dynamic>>(
//                                   future: MapApi.fetchPostpaidBillingInfo(
//                                       "${attributes['consumerNo']}",
//                                       "${attributes['locationName']}"),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const Center(
//                                           child: CircularProgressIndicator());
//                                     } else if (snapshot.hasError) {
//                                       return Text(
//                                         "Error: ${snapshot.error}",
//                                         style:
//                                             const TextStyle(color: Colors.red),
//                                       );
//                                     } else if (!snapshot.hasData) {
//                                       return const Text(
//                                           "No billing data found.");
//                                     }

//                                     final data = snapshot.data!;
//                                     final List<dynamic> pending =
//                                         data['pending_months'] ?? [];

//                                     return Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         _attributeContainer(
//                                             title: 'Customer No',
//                                             label: "${data['cusT_NUM']}"),
//                                         _attributeContainer(
//                                             title: 'Location Code',
//                                             label: "${data['locatioN_CODE']}"),
//                                         _attributeContainer(
//                                             title: 'Total Arrear',
//                                             label: "${data['totaL_ARREAR']}"),
//                                         // Text("Customer No: ${data['cusT_NUM']}"),
//                                         // Text("Location Code: ${data['locatioN_CODE']}"),
//                                         // Text("Total Arrear: ${data['totaL_ARREAR']}"),
//                                         const SizedBox(height: 8),
//                                         const Text(
//                                           "Pending Months:",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                         ...pending.map((p) => Text(
//                                               "• ${p['month']} → ${p['montH_ARR']} Tk",
//                                               style:
//                                                   const TextStyle(fontSize: 14),
//                                             )),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ],
//                               if (meterTypeName.contains("prepaid")) ...[
//                                 Text(
//                                   "Merer Type: ${attributes['meterTypeName']}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                                 FutureBuilder<List<Map<String, dynamic>>>(
//                                   future: MapApi.fetchPrepaidBillingInfo(
//                                     "${attributes['consumerNo']}",
//                                     "${attributes['meterNumber']}",
//                                   ),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const Center(
//                                           child: CircularProgressIndicator());
//                                     } else if (snapshot.hasError) {
//                                       return Text(
//                                         "Error: ${snapshot.error}",
//                                         style:
//                                             const TextStyle(color: Colors.red),
//                                       );
//                                     } else if (!snapshot.hasData ||
//                                         snapshot.data!.isEmpty) {
//                                       return const Text(
//                                           "No billing data found.");
//                                     }

//                                     /*
//                                     final List<Map<String, dynamic>> orders = snapshot.data!;

//                                     return Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         const SizedBox(height: 6),
//                                         ...orders.map((order) => Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 _attributeContainer(
//                                                   title: 'Customer No',
//                                                   label: "${order['customerNo']}"),
//                                                 _attributeContainer(
//                                                   title: 'Last Vending Date',
//                                                   label: "${order['date']}"),
//                                                 _attributeContainer(
//                                                   title: 'Last Vending Amount',
//                                                   label: "${order['grossAmount']} Tk"),
//                                                 _attributeContainer(
//                                                   title: 'Energy Cost',
//                                                   label: "${order['energyCost']} Tk"),
//                                                 const Divider(),
//                                               ],
//                                             )),
//                                       ],
//                                     );
//                                     */
//                                     final List<Map<String, dynamic>> orders =
//                                         snapshot.data ?? [];

//                                     if (orders.isEmpty) {
//                                       return const Text("No orders found");
//                                     }

//                                     // Only take the first order explicitly
//                                     final order = orders[0];

//                                     return Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const SizedBox(height: 6),
//                                         _attributeContainer(
//                                           title: 'Customer No',
//                                           label: "${order['customerNo']}",
//                                         ),
//                                         _attributeContainer(
//                                           title: 'Last Vending Date',
//                                           label: "${order['date']}",
//                                         ),
//                                         _attributeContainer(
//                                           title: 'Last Vending Amount',
//                                           label: "${order['grossAmount']} Tk",
//                                         ),
//                                         _attributeContainer(
//                                           title: 'Energy Cost',
//                                           label: "${order['energyCost']} Tk",
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ],
//                               const Spacer(),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

// Widget _attributeContainer({
//   required String label,
//   required String title,
// }) {
//   return Column(
//     children: [
//       Container(
//         width: double.infinity,
//         height: 25,
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "$title: ",
//                 style: const TextStyle(
//                   fontSize: 11.5,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   label,
//                   style: const TextStyle(fontSize: 11.5),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       const Divider(height: 0), // ← Added here
//     ],
//   );
// }
