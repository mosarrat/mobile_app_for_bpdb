// import 'dart:convert';

// import 'package:flutter/material.dart';
// // import 'package:arcgis_maps/arcgis_maps.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import '../../api/api.dart';
// import '../../api/consumer_api.dart';
// import '../../api/map_api.dart';
// import '../../constants/constant.dart';
// import '../../models/Login/login.dart';
// import '../../models/regions/circle.dart';
// import '../../models/regions/esu_info.dart';
// import '../../models/regions/feeder_line.dart';
// import '../../models/regions/snd_info.dart';
// import '../../models/regions/substation.dart';
// import '../../models/regions/zone.dart';
// import '../../widgets/noti/notifications.dart';
// import 'layer_loading_service.dart';

// class FilterPanel extends StatefulWidget {
//   final Function(Map<String, dynamic>) onFilterChanged;
//   // final ArcGISMapViewController mapController;
//   final Map<String, dynamic> initialFilters;
//   final MapLoadingService? mapLoadingService;
//   final VoidCallback onClearAll;

//   const FilterPanel({
//     super.key,
//     required this.onFilterChanged,
//     // required this.mapController,
//     required this.initialFilters,
//     this.mapLoadingService,
//     required this.onClearAll, // Add this parameter
//   });

//   @override
//   State<FilterPanel> createState() => _FilterPanelState();
// }

// class _FilterPanelState extends State<FilterPanel> {
//   bool isFormVisible = false;
//   final MapApi _mapApi = MapApi();
//   late Future<List<Zone>> zones;
//   late Future<List<Circles>> circles;
//   late Future<List<SndInfo>> snds;
//   late Future<List<EsuInfo>> esu;
//   late Future<List<Substation>> substations;
//   late Future<List<FeederLine>> feederLines;

//   int? selectedZoneId;
//   int? selectedCircleId;
//   int? selectedSnDId;
//   int? selectedEsuId;
//   int? selectedSubstationId;
//   int? selectedFeederLineId;
//   List<dynamic>? consumerList = [];
//   bool useGPS = false;

//   final TextEditingController radius = TextEditingController();
//   final TextEditingController latitude = TextEditingController();
//   final TextEditingController longitude = TextEditingController();
//   List<String> consumerNos = [];
//   bool isLoading = false;
//   User? user = globalUser;

//   Future<void> _checkLocationPermission() async {
//     var status = await Permission.location.status;

//     if (status.isGranted) {
//       await _getCurrentLocation();
//     } else if (status.isDenied) {
//       status = await Permission.location.request();
//       if (status.isGranted) {
//         await _getCurrentLocation();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               backgroundColor: Colors.red,
//               content: Text('Location permission denied')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             backgroundColor: Colors.red,
//             content: Text(
//                 'Location permission is permanently denied. Please enable it from settings.')),
//       );
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       setState(() {
//         latitude.text = position.latitude.toStringAsFixed(6);
//         longitude.text = position.longitude.toStringAsFixed(6);
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.red,
//           content: Text('Failed to get location: $e'),
//         ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     zones = CallApi().fetchZoneInfo();
//     circles = Future.value([]);
//     snds = Future.value([]);
//     esu = Future.value([]);
//     substations = Future.value([]);
//     feederLines = Future.value([]);

//     if (user?.ZoneId != null) {
//       selectedZoneId = user!.ZoneId;
//       circles = CallApi().fetchCircleInfo(selectedZoneId!).whenComplete(() {
//         setLoading(false);
//       });
//       updateFilters();
//     }
//     if (user?.CircleId != null) {
//       selectedCircleId = user!.CircleId;
//       snds = CallApi().fetchSnDInfo(selectedCircleId!).whenComplete(() {
//         setLoading(false);
//       });
//       updateFilters();
//     }
//     if (user?.SndId != null) {
//       selectedSnDId = user!.SndId;
//       esu = CallConsumerApi().fetchEsuInfo(selectedSnDId!).whenComplete(() {
//         setLoading(false);
//       });
//       substations =
//           CallApi().fetchSubstationInfo(selectedSnDId!).whenComplete(() {
//         setLoading(false);
//       });
//       updateFilters();
//     }
//     if (user?.EsuId != null) {
//       selectedEsuId = user?.EsuId;
//       substations =
//           CallApi().fetchSubstationInfoByEsu(selectedEsuId!).whenComplete(() {
//         setLoading(false);
//       });
//       updateFilters();
//     }
//     _getCurrentLocation();
//   }

//   void setLoading(bool loading) {
//     if (isLoading != loading) {
//       setState(() {
//         isLoading = loading;
//       });
//     }
//   }

//   void onZoneChanged(int? value) {
//     setLoading(true);
//     selectedZoneId = value;
//     selectedCircleId = null;
//     selectedSnDId = null;
//     selectedEsuId = null;
//     selectedSubstationId = null;
//     selectedFeederLineId = null;
//     circles = CallApi().fetchCircleInfo(value!).whenComplete(() {
//       setLoading(false);
//     });
//     snds = Future.value([]);
//     substations = Future.value([]);
//     feederLines = Future.value([]);

//     isFormVisible = false;
//     updateFilters();
//   }

//   void onCircleChanged(int? value) {
//     setLoading(true);
//     selectedCircleId = value;
//     selectedSnDId = null;
//     selectedEsuId = null;
//     selectedSubstationId = null;
//     selectedFeederLineId = null;
//     snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
//       setLoading(false);
//     });
//     substations = Future.value([]);
//     feederLines = Future.value([]);
//     isFormVisible = false;
//     updateFilters();
//   }

//   Future<void> onSnDChanged(int? value) async {
//     setLoading(true);
//     selectedSnDId = value;
//     selectedEsuId = null;
//     selectedSubstationId = null;
//     selectedFeederLineId = null;
//     try {
//       List<EsuInfo> esudata = await CallConsumerApi().fetchEsuInfo(value!);
//       if (esudata.isEmpty) {
//         substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
//           setLoading(false);
//         });
//       } else {
//         esu = CallConsumerApi().fetchEsuInfo(value!).whenComplete(() {
//           setLoading(false);
//         });
//         substations = Future.value([]);
//       }
//     } catch (e) {
//       print('Error fetching ESU info: $e');
//       substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
//         setLoading(false);
//       });
//     }
//     feederLines = Future.value([]);
//     isFormVisible = false;
//     updateFilters();
//   }

//   void onEsuChanged(int? value) {
//     setLoading(true);
//     selectedEsuId = value;
//     selectedSubstationId = null;
//     selectedFeederLineId = null;
//     substations = CallApi().fetchSubstationInfoByEsu(value!).whenComplete(() {
//       setLoading(false);
//     });
//     isFormVisible = false;
//     updateFilters();
//   }

//   void onSubstationChanged(int? value) {
//     setLoading(true);
//     selectedSubstationId = value;
//     selectedFeederLineId = null;
//     feederLines = CallApi().fetchFeederLineInfo(value!).whenComplete(() {
//       setLoading(false);
//     });
//     isFormVisible = false;
//     updateFilters();
//   }

//   void onFeederLineChanged(int? value) {
//     setLoading(true);
//     selectedFeederLineId = value;
//     isFormVisible = false;
//     updateFilters();
//   }

//   void updateFilters() {
//     final filters = {
//       'zoneId': selectedZoneId,
//       'circleId': selectedCircleId,
//       'sndId': selectedSnDId,
//       'esuId': selectedEsuId,
//       'substationId': selectedSubstationId,
//       'feederLineId': selectedFeederLineId,
//       'consumers': consumerList,
//     };
//     widget.onFilterChanged(filters);
//   }

//   void resetFilters() {
//     setState(() {
//       if (user?.ZoneId != null) {
//         selectedZoneId = user!.ZoneId;
//       } else {
//         selectedZoneId = null;
//       }
//       if (user?.CircleId != null) {
//         selectedCircleId = user!.CircleId;
//       } else {
//         selectedCircleId = null;
//       }
//       if (user?.SndId != null) {
//         selectedSnDId = user!.SndId;
//       } else {
//         selectedSnDId = null;
//       }
//       if (user?.EsuId != null) {
//         selectedEsuId = user!.EsuId;
//       } else {
//         selectedEsuId = null;
//       }
//       selectedSubstationId = null;
//       selectedFeederLineId = null;
//       consumerList = null;
//       latitude.clear();
//       longitude.clear();
//       radius.clear();
//       // Hide form after reset
//       isFormVisible = false;
//     });

//     widget.onClearAll();
//     updateFilters();
//   }

//   void fetchConsumers() async {
//     setState(() {
//       isLoading = true;
//     });

//     final lat = latitude.text;
//     final lon = longitude.text;
//     final rad = radius.text;
//     consemerRange.lat = double.tryParse(lat);
//     consemerRange.long = double.tryParse(lon);
//     consemerRange.range = double.tryParse(rad);
//     consumerList = await _mapApi.fetchConsumersInRange(lat, lon, rad);
//     setState(() {
//       isLoading = false;
//     });
//     isFormVisible = false;
//     updateFilters();

//     print("Consumers found: $consumerList");
//   }

//   @override
//   Widget build(BuildContext context) {
//     double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);

//     return Stack(
//       children: [
//         // Filter toggle button
//         Positioned(
//           top: 10,
//           right: 10,
//           child: FloatingActionButton(
//             mini: true,
//             backgroundColor: Colors.white,
//             foregroundColor: const Color.fromARGB(255, 3, 89, 100),
//             onPressed: () {
//               setState(() {
//                 isFormVisible = !isFormVisible;
//               });
//             },
//             child: Icon(isFormVisible ? Icons.close : Icons.filter_list),
//           ),
//         ),

//         // Filter form
//         if (isFormVisible)
//           Positioned(
//             top: 70,
//             right: 10,
//             left: 10,
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.9),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: DefaultTabController(
//                 length: 2, // 👈 Two tabs
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Filter Map',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: resetFilters,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             foregroundColor: Colors.white,
//                           ),
//                           child: const Text('Reset'),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),

//                     // Tab bar
//                     const TabBar(
//                       labelColor: Colors.black,
//                       indicatorColor: Color.fromARGB(255, 3, 89, 100),
//                       tabs: [
//                         Tab(text: 'Region'),
//                         Tab(text: 'Consumer'),
//                       ],
//                     ),
//                     const SizedBox(height: 10),

//                     // Tab content
//                     SizedBox(
//                       height: 270, // 👈 set height for tab content
//                       child: TabBarView(
//                         children: [
//                           // Region Filters
//                           SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 FutureBuilder<List<Zone>>(
//                                   future: zones,
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const SizedBox.shrink();
//                                     }

//                                     if (snapshot.hasError) {
//                                       return Center(
//                                           child:
//                                               Text('Error: ${snapshot.error}'));
//                                     } else if (snapshot.hasData) {
//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           label: RichText(
//                                             text: TextSpan(
//                                               text: 'Zone',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: deviceFontSize + 3,
//                                               ),
//                                               children: const [
//                                                 TextSpan(
//                                                   text: ' *',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         value: selectedZoneId,
//                                         hint: const Text('Select a Zone'),
//                                         items: snapshot.data!.map((zone) {
//                                           return DropdownMenuItem<int>(
//                                             value: zone.zoneId,
//                                             child: Text(zone.zoneName),
//                                           );
//                                         }).toList(),
//                                         // onChanged: (value) {
//                                         //   selectedZoneId = value;
//                                         //   onZoneChanged(value);
//                                         // },
//                                         onChanged: user?.ZoneId == null
//                                             ? (value) {
//                                                 selectedZoneId = value;
//                                                 onZoneChanged(value);
//                                               }
//                                             : null,
//                                       );
//                                     } else {
//                                       return const Text('No zones available');
//                                     }
//                                   },
//                                 ),
//                                 const SizedBox(height: 16.0),
//                                 FutureBuilder<List<Circles>>(
//                                   future: circles,
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const SizedBox.shrink();
//                                     }

//                                     if (snapshot.hasError) {
//                                       showMessage(
//                                           'Error: ${snapshot.error}', 'error');
//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           label: RichText(
//                                             text: TextSpan(
//                                               text: 'Circle',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: deviceFontSize + 3,
//                                               ),
//                                               children: const [
//                                                 TextSpan(
//                                                   text: ' *',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         value: null,
//                                         hint:
//                                             const Text('No circles available!'),
//                                         items: [],
//                                         onChanged: null,
//                                       );
//                                     } else if (snapshot.hasData) {
//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           label: RichText(
//                                             text: TextSpan(
//                                               text: 'Circle',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: deviceFontSize + 3,
//                                               ),
//                                               children: const [
//                                                 TextSpan(
//                                                   text: ' *',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         value: selectedCircleId,
//                                         hint: const Text('Select a Circle'),
//                                         items: snapshot.data!.map((circle) {
//                                           return DropdownMenuItem<int>(
//                                             value: circle.circleId,
//                                             child: Text(circle.circleName!),
//                                           );
//                                         }).toList(),
//                                         // onChanged: (value) {
//                                         //   setState(() {
//                                         //     selectedCircleId = value;
//                                         //     onCircleChanged(value);
//                                         //   });
//                                         // },
//                                         onChanged: user?.CircleId == null
//                                             ? (value) {
//                                                 selectedCircleId = value;
//                                                 onCircleChanged(value);
//                                               }
//                                             : null,
//                                       );
//                                     } else {
//                                       return const Text(
//                                           'No circles available!');
//                                     }
//                                   },
//                                 ),
//                                 const SizedBox(height: 16.0),
//                                 FutureBuilder<List<SndInfo>>(
//                                   future: snds,
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const SizedBox.shrink();
//                                     }

//                                     if (snapshot.hasError) {
//                                       showMessage(
//                                           'Error: ${snapshot.error}', 'error');
//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           label: RichText(
//                                             text: TextSpan(
//                                               text: 'SnD',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: deviceFontSize + 3,
//                                               ),
//                                               children: const [
//                                                 TextSpan(
//                                                   text: ' *',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         value: null,
//                                         hint: const Text('No SnDs available!'),
//                                         items: [],
//                                         onChanged: null,
//                                       );
//                                     } else if (snapshot.hasData) {
//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           label: RichText(
//                                             text: TextSpan(
//                                               text: 'SnD',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: deviceFontSize + 3,
//                                               ),
//                                               children: const [
//                                                 TextSpan(
//                                                   text: ' *',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         value: selectedSnDId,
//                                         hint: const Text('Select a SnD'),
//                                         items: snapshot.data!.map((snd) {
//                                           return DropdownMenuItem<int>(
//                                             value: snd.sndId,
//                                             child: Text(snd.snDName!),
//                                           );
//                                         }).toList(),
//                                         // onChanged: (value) {
//                                         //   setState(() {
//                                         //     selectedSnDId = value;
//                                         //     onSnDChanged(value);
//                                         //   });
//                                         // },
//                                         onChanged: user?.SndId == null
//                                             ? (value) {
//                                                 selectedSnDId = value;
//                                                 onSnDChanged(value);
//                                               }
//                                             : null,
//                                       );
//                                     } else {
//                                       return const Text('No SnDs available!');
//                                     }
//                                   },
//                                 ),
//                                 const SizedBox(height: 16.0),
//                                 ////// ESU Info //////
//                                 FutureBuilder<List<EsuInfo>>(
//                                   future: esu,
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const SizedBox.shrink();
//                                     }

//                                     if (snapshot.hasError) {
//                                       showMessage(
//                                           'Error: ${snapshot.error}', 'error');

//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           labelText: 'Esu',
//                                           labelStyle: TextStyle(
//                                             color: Colors.blue,
//                                             fontSize: deviceFontSize + 3,
//                                           ),
//                                         ),
//                                         value: null,
//                                         hint: const Text('No Esus available!'),
//                                         items: [],
//                                         onChanged: null,
//                                       );
//                                     } else if (snapshot.hasData) {
//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           labelText: 'Esu',
//                                           labelStyle: TextStyle(
//                                             color: Colors.blue,
//                                             fontSize: deviceFontSize + 3,
//                                           ),
//                                         ),
//                                         value: selectedEsuId,
//                                         hint: const Text('Select a Esu'),
//                                         items: snapshot.data!.map((esu) {
//                                           return DropdownMenuItem<int>(
//                                             value: esu.esuId,
//                                             child: Text(esu.esuName),
//                                           );
//                                         }).toList(),
//                                         // onChanged: (value) {
//                                         //   setState(() {
//                                         //     selectedEsuId = value;
//                                         //     onEsuChanged(value);
//                                         //   });
//                                         // },

//                                         onChanged: user?.EsuId == null
//                                             ? (value) {
//                                                 selectedEsuId = value;
//                                                 onEsuChanged(value);
//                                               }
//                                             : null,
//                                       );
//                                     } else {
//                                       return const Text('No Esus available!');
//                                     }
//                                   },
//                                 ),
//                                 const SizedBox(height: 16.0),
//                                 ///// Esu Info //////
//                                 FutureBuilder<List<Substation>>(
//                                   future: substations,
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const SizedBox.shrink();
//                                     }

//                                     if (snapshot.hasError) {
//                                       showMessage(
//                                           'Error: ${snapshot.error}', 'error');
//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           label: RichText(
//                                             text: TextSpan(
//                                               text: 'Substaion',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: deviceFontSize + 3,
//                                               ),
//                                               children: const [
//                                                 TextSpan(
//                                                   text: ' *',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         value: null,
//                                         hint: const Text(
//                                             'No substations available!'),
//                                         items: [],
//                                         onChanged: null,
//                                       );
//                                     } else if (snapshot.hasData) {
//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           label: RichText(
//                                             text: TextSpan(
//                                               text: 'Substaion',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: deviceFontSize + 3,
//                                               ),
//                                               children: const [
//                                                 TextSpan(
//                                                   text: ' *',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         value: selectedSubstationId,
//                                         hint: const Text('Select a Substation'),
//                                         items: snapshot.data!.map((substation) {
//                                           return DropdownMenuItem<int>(
//                                             value: substation.substationId,
//                                             child:
//                                                 Text(substation.substationName),
//                                           );
//                                         }).toList(),
//                                         onChanged: (value) {
//                                           setState(() {
//                                             selectedSubstationId = value;
//                                             onSubstationChanged(value);
//                                           });
//                                         },
//                                       );
//                                     } else {
//                                       return const Text(
//                                           'No substations available!');
//                                     }
//                                   },
//                                 ),
//                                 const SizedBox(height: 16.0),
//                                 FutureBuilder<List<FeederLine>>(
//                                   future: feederLines,
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return const SizedBox.shrink();
//                                     }

//                                     if (snapshot.hasError) {
//                                       showMessage(
//                                           'Error: ${snapshot.error}', 'error');
//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           label: RichText(
//                                             text: TextSpan(
//                                               text: 'Feeder Line',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: deviceFontSize + 3,
//                                               ),
//                                               children: const [
//                                                 TextSpan(
//                                                   text: ' *',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         value: null,
//                                         hint: const Text(
//                                             'No feeder line available!'),
//                                         items: [],
//                                         onChanged: null,
//                                       );
//                                     } else if (snapshot.hasData) {
//                                       return DropdownButtonFormField<int>(
//                                         isExpanded: true,
//                                         decoration: InputDecoration(
//                                           label: RichText(
//                                             text: TextSpan(
//                                               text: 'Feeder Line',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: deviceFontSize + 3,
//                                               ),
//                                               children: const [
//                                                 TextSpan(
//                                                   text: ' *',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         value: selectedFeederLineId,
//                                         hint:
//                                             const Text('Select a Feeder Line'),
//                                         items: snapshot.data!.map((feeder) {
//                                           return DropdownMenuItem<int>(
//                                             value: feeder.feederLineId,
//                                             child: Text(feeder.feederlineName!),
//                                           );
//                                         }).toList(),
//                                         onChanged: (value) {
//                                           setState(() {
//                                             selectedFeederLineId = value;
//                                             onFeederLineChanged(value);
//                                           });
//                                         },
//                                       );
//                                     } else {
//                                       return const Text(
//                                           'No feeder line available!');
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // Consumer Filters
//                           SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 5),
//                                 _buildTextField(latitude, 'Latitude', true),
//                                 _buildTextField(longitude, 'Longitude', true),
//                                 _buildTextField(radius, 'Radius', true),
//                                 ElevatedButton(
//                                   onPressed: fetchConsumers,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                         const Color.fromARGB(255, 54, 216, 244),
//                                     foregroundColor: Colors.white,
//                                   ),
//                                   child: isLoading
//                                       ? CircularProgressIndicator(
//                                           color: Colors.white)
//                                       : const Text('Search'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildFilterDropdown<T>({
//     required String hint,
//     required T? value,
//     required List<DropdownMenuItem<T>> items,
//     required Function(T?)? onChanged,
//     required bool isLoading,
//   }) {
//     return isLoading
//         ? Container(
//             height: 60,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: const Center(
//               child: SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               ),
//             ),
//           )
//         : DropdownButtonFormField<T>(
//             isExpanded: true,
//             decoration: InputDecoration(
//               labelText: hint,
//               border: OutlineInputBorder(),
//             ),
//             value: value,
//             items: items,
//             onChanged: onChanged,
//           );
//   }

//   Widget _buildTextField(
//       TextEditingController? controller, String label, bool mandatory) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           label: RichText(
//             text: TextSpan(
//               text: label,
//               style: const TextStyle(
//                 color: Color.fromARGB(255, 100, 97, 97),
//                 fontSize: 16.0,
//               ),
//               children: [
//                 if (mandatory)
//                   const TextSpan(
//                     text: ' *',
//                     style: TextStyle(
//                       color: Colors.red,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         validator: (value) {
//           if (mandatory && (value == null || value.isEmpty)) {
//             return 'Please enter $label';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
