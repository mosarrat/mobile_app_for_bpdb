// import 'package:arcgis_maps/arcgis_maps.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../../constants/constant.dart';
// import '../../dashboard.dart';
// import 'layer_loading_service.dart';
// import 'map_legends.dart';
// import 'new_filter_map.dart';
// import 'pop_up_service.dart';

// class ArcGISMapViewer extends StatefulWidget {
//   final String title;
//   const ArcGISMapViewer({
//     super.key,
//     required this.title,
//   });

//   @override
//   State<ArcGISMapViewer> createState() => _ArcGISMapViewerState();
// }

// class _ArcGISMapViewerState extends State<ArcGISMapViewer> {
//   // final _map = ArcGISMap.withBasemapStyle(BasemapStyle.osmStreets);
//   // final _map = ArcGISMap.withBasemapStyle(BasemapStyle.arcGISImageryStandard);
//   late ArcGISMap _map;
  
//   final _mapViewController = ArcGISMapView.createController();
//   final _featurePopupService = FeaturePopupService();
//   late MapLoadingService _mapLoadingService;
//   Set<LayerType> _currentLayers = {};
//   Graphic? _highlightedFeature;
//   GraphicsOverlay? _highlightOverlay;
//   bool _showMapLegends = false;
//   bool _isGPSLocationAdded = false;
//   late GraphicsOverlay _graphicsOverlay;
//   Viewpoint? _previousViewpoint;

//   ArcGISMapImageLayer? _baseMapLayer;
//   bool _isBaseMapVisible = true;

//   @override
//   void initState() {
//     super.initState();
//     final basemapLayer = ArcGISTiledLayer.withUri(
//       Uri.parse('https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer'),
//     );
//     final basemap = Basemap.withLayers(
//       baseLayers: [basemapLayer],
//       referenceLayers: [],
//     );
//     _map = ArcGISMap.withBasemap(basemap);
//     _graphicsOverlay = GraphicsOverlay();
//     _mapLoadingService = MapLoadingService(
//       map: _map,
//       mapViewController: _mapViewController,
//     );
//     _mapLoadingService.layerChangedNotifier.addListener(_onLayersChanged);
//   }

//   void _onLayersChanged() {
//     setState(() {
//       _currentLayers = Set.from(_mapLoadingService.loadedLayers);
//     });
//   }

//   @override
//   void dispose() {
//     // Remove the listener when disposing
//     _mapLoadingService.layerChangedNotifier.removeListener(_onLayersChanged);
//     super.dispose();
//   }

//   /*
//   Future<void> _onMapViewReady() async {
//     _mapViewController.arcGISMap = _map;

//     _mapViewController.setViewpoint(
//       Viewpoint.withLatLongScale(
//         latitude: GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//         longitude:
//             GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//         scale: GlobalVariables.defaultZoomLevel ?? defaultViewPoint.scale,
//       ),
//     );

//     _map.operationalLayers.clear();
//     _mapViewController.graphicsOverlays.clear();

//     final imageLayer = ArcGISMapImageLayer.withUri(
//       Uri.parse(
//           'https://www.arcgisbd.com/server/rest/services/bpdb/bpdb_mobile_app/MapServer'),
//     );

//     await imageLayer.load();

//     _mapLoadingService.loadBaseMap();
//     _map.operationalLayers.add(imageLayer);

//     if (_currentFilters.values.any((v) => v != null)) {
//       await _handleFilterChanged(_currentFilters);
//     }
//   }
//   */
//   Future<void> _onMapViewReady() async {
//     _mapViewController.arcGISMap = _map;

//     _mapViewController.setViewpoint(
//       Viewpoint.withLatLongScale(
//         latitude: GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//         longitude:
//             GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//         scale: GlobalVariables.defaultZoomLevel ?? defaultViewPoint.scale,
//       ),
//     );

//     _map.operationalLayers.clear();
//     _mapViewController.graphicsOverlays.clear();

//     // Initialize base map layer
//     _baseMapLayer = ArcGISMapImageLayer.withUri(
//       Uri.parse(
//         'https://www.arcgisbd.com/server/rest/services/bpdb/bpdb_mobile_app/MapServer',
//       ),
//     );

//     await _baseMapLayer!.load();

//     _mapLoadingService.loadBaseMap();
//     _map.operationalLayers.add(_baseMapLayer!);

//     if (_currentFilters.values.any((v) => v != null)) {
//       await _handleFilterChanged(_currentFilters);
//     }
//   }

//   // Toggle function for FloatingActionButton
//   void _toggleBaseMapVisibility() {
//     if (_baseMapLayer != null) {
//       setState(() {
//         _isBaseMapVisible = !_isBaseMapVisible;
//         _baseMapLayer!.isVisible = _isBaseMapVisible;
//       });
//     }
//   }



//   void _clearAllLayers() {
//     _mapLoadingService.clearAllLayers();
//     _mapLoadingService.loadBaseMap();
//     _clearHighlight();
//     _onMapViewReady();
//     // ✅ wait for it to finish
//     setState(() {
//       _currentLayers.clear();
//     });
//   }

//   Map<String, dynamic> _currentFilters = {
//     'zoneId': null,
//     'circleId': null,
//     'sndId': null,
//     'esuId': null,
//     'substationId': null,
//     'feederLineId': null,
//     'poleDetailsId': null,
//     'consumers': null,
//   };
//   Future<void> _handleFilterChanged(Map<String, dynamic> filters) async {
//     // Update current filters
//     setState(() {
//       // _currentFilters = Map<String, int?>.from(filters);
//       _currentFilters = Map<String, dynamic>.from(filters);
//     });
//     // Check which level is selected and load appropriate layer
//     final consumers = filters['consumers'];
//     if (consumers is List && consumers.isNotEmpty) {
//       await _mapLoadingService.loadAndCenterRangeConsumers(consumers);
//     } else if (filters['poleDetailsId'] != null) {
//       await _mapLoadingService.loadAndCenterPole(filters['poleDetailsId']!);
//     } else if (filters['feederLineId'] != null) {
//       await _mapLoadingService
//           .loadAndCenterFeederLine(filters['feederLineId']!);
//     } else if (filters['substationId'] != null) {
//       await _mapLoadingService
//           .loadAndCenterSubstation(filters['substationId']!);
//     } else if (filters['esuId'] != null) {
//       await _mapLoadingService.loadAndCenterESU(filters['esuId']!);
//     } else if (filters['sndId'] != null) {
//       await _mapLoadingService.loadAndCenterSND(filters['sndId']!);
//     } else if (filters['circleId'] != null) {
//       await _mapLoadingService.loadAndCenterCircle(filters['circleId']!);
//     } else if (filters['zoneId'] != null) {
//       //print('Updated filters: $filters');
//       await _mapLoadingService.loadAndCenterZone(filters['zoneId']!);
//     } else {
//       _mapLoadingService.loadBaseMap();
//     }
//   }

//   Future<void> _zoomIn() async {
//     final currentViewpoint =
//         _mapViewController.getCurrentViewpoint(ViewpointType.centerAndScale);
//     if (currentViewpoint != null) {
//       double newScale = currentViewpoint.targetScale / 2;

//       _mapViewController.setViewpoint(
//         Viewpoint.withLatLongScale(
//           latitude: GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//           longitude:
//               GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//           scale: newScale,
//         ),
//       );
//     }
//   }

//   Future<void> _zoomOut() async {
//     final currentViewpoint =
//         _mapViewController.getCurrentViewpoint(ViewpointType.centerAndScale);
//     if (currentViewpoint != null) {
//       double newScale = currentViewpoint.targetScale * 2;

//       _mapViewController.setViewpoint(
//         Viewpoint.withLatLongScale(
//           latitude: GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//           longitude:
//               GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//           scale: newScale,
//         ),
//       );
//     }
//   }

//   // void _clearHighlight() {
//   //   // Remove highlight graphic if it exists
//   //   if (_highlightOverlay != null && _highlightedFeature != null) {
//   //     _highlightOverlay!.graphics.remove(_highlightedFeature);
//   //     _highlightedFeature = null;
//   //   }
//   // }

//   // void _highlightFeature(ArcGISFeature feature) {
//   //   print(feature.geometry);
//   //   ArcGISSymbol? highlightSymbol;

//   //   final blueLineSymbol = SimpleLineSymbol(
//   //     color: Colors.blueAccent,
//   //     width: 2.0,
//   //     style: SimpleLineSymbolStyle.solid,
//   //   );

//   //   if (feature.geometry is Polygon) {
//   //     highlightSymbol = SimpleFillSymbol(
//   //       color: Color.fromARGB(0, 0, 0, 0),
//   //       outline: blueLineSymbol,
//   //       style: SimpleFillSymbolStyle.solid,
//   //     );
//   //   } else if (feature.geometry is Polyline) {
//   //     highlightSymbol = blueLineSymbol;
//   //   } else if (feature.geometry is ArcGISPoint) {
//   //     highlightSymbol = SimpleMarkerSymbol(
//   //       color: Color.fromARGB(0, 0, 0, 0),
//   //       size: 16.0,
//   //       style: SimpleMarkerSymbolStyle.circle,
//   //     );
//   //   }

//   //   if (highlightSymbol != null && feature.geometry != null) {
//   //     final graphic = Graphic(
//   //       geometry: feature.geometry,
//   //       symbol: highlightSymbol,
//   //     );
//   //     if (_highlightOverlay == null) {
//   //       _highlightOverlay = GraphicsOverlay()..id = 'highlight_overlay';
//   //       _mapViewController.graphicsOverlays.add(_highlightOverlay!);
//   //     }
//   //     _highlightOverlay!.graphics.add(graphic);

//   //     _highlightedFeature = graphic;

//   //     setState(() {});
//   //   }
//   // }
// // void _highlightFeature(ArcGISFeature feature) {
// //   if (feature.geometry == null) return;

// //   if (_highlightOverlay == null) {
// //     _highlightOverlay = GraphicsOverlay()..id = 'highlight_overlay';
// //     _mapViewController.graphicsOverlays.add(_highlightOverlay!);
// //   }

// //   _highlightOverlay!.graphics.clear();

// //   if (feature.geometry is ArcGISPoint) {
// //     final point = feature.geometry as ArcGISPoint;

// //     // Outer circle - acts as outline
// //     final outlineGraphic = Graphic(
// //       geometry: point,
// //       symbol: SimpleMarkerSymbol(
// //         color: Colors.red.withOpacity(0.3), // outline color
// //         size: 30.0,         // bigger size for outline
// //         style: SimpleMarkerSymbolStyle.circle,
// //       ),
// //     );

// //     // Inner circle - fill
// //     final fillGraphic = Graphic(
// //       geometry: point,
// //       symbol: SimpleMarkerSymbol(
// //         color: Colors.transparent,
// //         size: 24.0,
// //         style: SimpleMarkerSymbolStyle.circle,
// //       ),
// //     );

// //     _highlightOverlay!.graphics.addAll([outlineGraphic, fillGraphic]);
// //   }

//   // handle polygon and polyline as before...

// //   setState(() {});
// // }

//   // Future<void> _handleMapTap(Offset screenPoint) async {
//   //   try {
//   //     final mapPoint = _mapViewController.screenToLocation(screen: screenPoint);

//   //     if (_map.operationalLayers.isEmpty) {
//   //       return;
//   //     }
//   //     //_clearHighlight();
//   //     for (var layer in _map.operationalLayers.reversed) {
//   //       final identifyResult = await _mapViewController.identifyLayer(
//   //         layer,
//   //         screenPoint: screenPoint,
//   //         tolerance: 22.0,
//   //         maximumResults: 1,
//   //       );

//   //       if (identifyResult.geoElements.isNotEmpty) {
//   //         final feature = identifyResult.geoElements.first;

//   //         // -- MKS -- //
//   //         final popupInfo =
//   //             _featurePopupService.getFeaturePopupTitle(feature.attributes);
//   //         print(popupInfo);

//   //         if (popupInfo.idKey != null) {
//   //           final id = feature.attributes[popupInfo.idKey];
//   //           print(id);

//   //           if (id != null) {
//   //             _featurePopupService.fetchAndShowPopup(
//   //               context: context,
//   //               idKey: popupInfo.idKey!,
//   //               idValue: id,
//   //               title: popupInfo.title,
//   //             );
//   //           }
//   //           if (feature is ArcGISFeature && feature.geometry != null) {
//   //             // print("consumer Highlight");
//   //             // _highlightFeature();
//   //             await onConsumerClicked(feature);
//   //           }
//   //         }
//   //         // -- MKS -- //

//   //         return;
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print('Error handling map tap: $e');
//   //   }
//   // }

//   Future<void> _handleMapTap(Offset screenPoint) async {
//     try {
//       final mapPoint = _mapViewController.screenToLocation(screen: screenPoint);

//       if (_map.operationalLayers.isEmpty) {
//         return;
//       }

//       // Remove _clearHighlight() here! So highlights remain on tap

//       for (var layer in _map.operationalLayers.reversed) {
//         final identifyResult = await _mapViewController.identifyLayer(
//           layer,
//           screenPoint: screenPoint,
//           tolerance: 22.0,
//           maximumResults: 1,
//         );

//         if (identifyResult.geoElements.isNotEmpty) {
//           final feature = identifyResult.geoElements.first;

//           final popupInfo =
//               _featurePopupService.getFeaturePopupTitle(feature.attributes);
//           print(popupInfo);

//           if (popupInfo.idKey != null) {
//             final id = feature.attributes[popupInfo.idKey];
//             //print(id);

//             if (id != null) {
//               // Show popup but DON'T clear highlights when it closes
//               _featurePopupService.fetchAndShowPopup(
//                 context: context,
//                 idKey: popupInfo.idKey!,
//                 idValue: id,
//                 title: popupInfo.title,
//               );
//             }
//             if (popupInfo.idKey == "consumer_no") {
//               if (feature is ArcGISFeature && feature.geometry != null) {
//                 await onConsumerClicked(feature);
//               }
//             }
//           }
//           return;
//         }
//       }
//     } catch (e) {
//       print('Error handling map tap: $e');
//     }
//   }

//   void _toggleMapLegends() {
//     setState(() {
//       _showMapLegends = !_showMapLegends;
//     });
//   }

//   Future<void> _checkLocationPermission() async {
//     var status = await Permission.location.status;

//     if (status.isGranted) {
//       await _getCurrentLocation();
//     } else if (status.isDenied) {
//       status = await Permission.location.request();
//       if (status.isGranted) {
//         await _getCurrentLocation();
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permission denied')),
//           );
//         }
//       }
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Location permission is permanently denied. Please enable it from settings.',
//             ),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       // Save the previous viewpoint before changing
//       _previousViewpoint =
//           _mapViewController.getCurrentViewpoint(ViewpointType.centerAndScale);

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       _graphicsOverlay.graphics.clear();
//       final ArcGISPoint point = ArcGISPoint(
//         x: position.longitude,
//         y: position.latitude,
//         spatialReference: SpatialReference.wgs84,
//       );

//       final symbol = SimpleMarkerSymbol(
//         style: SimpleMarkerSymbolStyle.circle,
//         color: Colors.blue,
//         size: 18,
//       );

//       final graphic = Graphic(
//         geometry: point,
//         symbol: symbol,
//       );

//       _graphicsOverlay.graphics.add(graphic);
//       _mapViewController.graphicsOverlays.add(_graphicsOverlay);

//       _mapViewController.setViewpoint(
//         Viewpoint.withLatLongScale(
//           latitude: position.latitude,
//           longitude: position.longitude,
//           scale: 5000,
//         ),
//       );

//       setState(() {
//         _isGPSLocationAdded = true;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error getting location: $e')),
//         );
//       }
//     }
//   }

//   void _disableCurrentLocation() {
//     _graphicsOverlay.graphics.clear();

//     // Restore old viewpoint if we saved it
//     if (_previousViewpoint != null) {
//       _mapViewController.setViewpoint(_previousViewpoint!);
//     }

//     setState(() {
//       _isGPSLocationAdded = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     double containerWidth;
//     if (width < 1300 && width > 900) {
//       containerWidth = 650;
//     } else if (width < 900 && width > 600) {
//       containerWidth = 550;
//     } else if (width < 600 && width > 400) {
//       containerWidth = width * 0.26;
//     } else if (width < 400 && width > 200) {
//       containerWidth = 200;
//     } else {
//       containerWidth = 380;
//     }
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(70),
//           child: AppBar(
//             iconTheme: const IconThemeData(
//               color: Colors.white,
//             ),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () {
//                 // Navigator.pop(context);
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const Dashboard(),
//                   ),
//                   (route) => false,
//                 );
//               },
//             ),
//             title: const Text(
//               'Map Viewer',
//               style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             // backgroundColor: const Color.fromARGB(255, 5, 161, 182),
//             backgroundColor: Color.fromARGB(255, 3, 89, 100),
//           ),
//         ),
//         body: Stack(
//           children: [
//             ArcGISMapView(
//               controllerProvider: () => _mapViewController,
//               onMapViewReady: _onMapViewReady,
//               onTap: _handleMapTap,
//             ),
//             FilterPanel(
//               onFilterChanged: _handleFilterChanged,
//               mapController: _mapViewController,
//               initialFilters: _currentFilters,
//               mapLoadingService: _mapLoadingService,
//               onClearAll: _clearAllLayers, // Pass the clear all function
//             ),
//             // Zoom controls
//             Positioned(
//               right: 16,
//               bottom: 80,
//               child: Column(
//                 children: [
//                   if (!_isGPSLocationAdded)
//                     FloatingActionButton(
//                       heroTag: "Show Your Location",
//                       mini: true,
//                       onPressed: _checkLocationPermission,
//                       backgroundColor: Colors.white,
//                       foregroundColor: Color.fromARGB(255, 3, 89, 100),
//                       child: const Icon(Icons.location_searching),
//                     )
//                   else
//                     FloatingActionButton(
//                       heroTag: "Disable Your Location",
//                       mini: true,
//                       onPressed: _disableCurrentLocation,
//                       backgroundColor: Colors.white,
//                       foregroundColor: Color.fromARGB(255, 3, 89, 100),
//                       child: const Icon(Icons.location_disabled),
//                     ),

//                   // -- Base Map hide show button -- //
//                   FloatingActionButton(
//                     heroTag: "BaseMapToggle",
//                     mini: true,
//                     onPressed: _toggleBaseMapVisibility,
//                     backgroundColor: Colors.white,
//                     foregroundColor: const Color.fromARGB(255, 3, 89, 100),
//                     child: Icon(
//                       _isBaseMapVisible ? Icons.map : Icons.map_outlined,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // -- Base Map hide show button -- //
//                   FloatingActionButton(
//                     heroTag: "zoomIn",
//                     mini: true,
//                     onPressed: _zoomIn,
//                     backgroundColor: Colors.white,
//                     foregroundColor: Color.fromARGB(255, 3, 89, 100),
//                     child: const Icon(Icons.add),
//                   ),
//                   const SizedBox(height: 8),
//                   FloatingActionButton(
//                     heroTag: "zoomOut",
//                     mini: true,
//                     onPressed: _zoomOut,
//                     backgroundColor: Colors.white,
//                     foregroundColor: Color.fromARGB(255, 3, 89, 100),
//                     child: const Icon(Icons.remove),
//                   ),
//                 ],
//               ),
//             ),
//             // Legends toggle button
//             Positioned(
//               right: 16,
//               bottom: 16,
//               child: FloatingActionButton(
//                 heroTag: "mapLegends",
//                 mini: true,
//                 backgroundColor: Colors.white,
//                 foregroundColor: Color.fromARGB(255, 3, 89, 100),
//                 onPressed: _toggleMapLegends,
//                 child: const Icon(Icons.legend_toggle_rounded),
//               ),
//             ),

//             // RJR - 19/5/2025
//             // Map Legends panel (visible when toggled)
//             if (_showMapLegends)
//               Positioned(
//                 bottom: 70, // Position above the zoom controls
//                 right: 16,
//                 left: containerWidth,
//                 child: MapLegends(
//                   isVisible: _showMapLegends,
//                   onClose: _toggleMapLegends,
//                   loadedLayers: _currentLayers,
//                   onClearAll: _clearAllLayers, // JAL
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _clearHighlight() {
//     _highlightOverlay?.graphics.clear();
//   }

//   void _highlightFeature(Geometry geometry,
//       {Color color = Colors.yellow, double size = 30.0}) {
//     if (_highlightOverlay == null) {
//       _highlightOverlay = GraphicsOverlay()..id = 'highlight_overlay';
//       _mapViewController.graphicsOverlays.add(_highlightOverlay!);
//     }

//     // Remove the clear() here to accumulate highlights!
//     // _highlightOverlay!.graphics.clear();

//     final symbol = geometry.geometryType == GeometryType.point
//         ? SimpleMarkerSymbol(
//             color: color.withOpacity(0.6),
//             size: size,
//             style: SimpleMarkerSymbolStyle.circle,
//           )
//         : SimpleLineSymbol(
//             color: color.withOpacity(0.6),
//             width: 5.0,
//             style: SimpleLineSymbolStyle.solid,
//           );

//     _highlightOverlay!.graphics
//         .add(Graphic(geometry: geometry, symbol: symbol));
//   }

//   Future<void> _highlightRelatedFeature({
//     required String layerUrl,
//     required String filter,
//     required Color color,
//   }) async {
//     try {
//       final table = ServiceFeatureTable.withUri(Uri.parse(layerUrl));
//       final result = await table.queryFeatures(
//         QueryParameters()
//           ..whereClause = filter
//           ..returnGeometry = true,
//       );

//       for (final feature in result.features()) {
//         if (feature.geometry != null) {
//           _highlightFeature(feature.geometry!, color: color);
//         }
//       }
//     } catch (e) {
//       print('Error highlighting related feature: $e');
//     }
//   }

//   Future<void> onConsumerClicked(ArcGISFeature consumerFeature) async {
//     _clearHighlight();
//     final String _baseUrl =
//         'https://www.arcgisbd.com/server/rest/services/bpdb/basemaps/MapServer';
//     final attributes = consumerFeature.attributes;

//     final consumerId = attributes['consumer_id'];
//     final feederLineId = attributes['feederline_id'];
//     final dtId = attributes['dt_id'];
//     final substationId = attributes['substation_id'];
//     final servicePointId = attributes['service_point_id'];

//     // Highlight the consumer itself
//     final geom = consumerFeature.geometry;
//     if (geom != null) {
//       _highlightFeature(geom, color: Colors.yellow, size: 30.0);
//     }

//     // Highlight its service line
//     await _highlightRelatedFeature(
//       layerUrl: '$_baseUrl/46', // Consumer line layer
//       filter: 'consumer_id = $consumerId',
//       color: Colors.yellow,
//     );

//     // Highlight the DT
//     await _highlightRelatedFeature(
//       layerUrl: '$_baseUrl/62',
//       filter: 'dt_id = $dtId',
//       color: Colors.yellow,
//     );

//     // Highlight the Service Point
//     await _highlightRelatedFeature(
//       layerUrl: '$_baseUrl/48',
//       filter: 'service_point_id  = $servicePointId',
//       color: Colors.yellow,
//     );

//     // Highlight the feeder line
//     await _highlightRelatedFeature(
//       layerUrl: '$_baseUrl/7', // or 9 / 7 depending on type — might need logic
//       filter: 'feederline_id = $feederLineId',
//       color: Colors.yellow,
//     );

//     // Highlight the substation
//     await _highlightRelatedFeature(
//       layerUrl: '$_baseUrl/10', // your substation layer index
//       filter: 'substation_id = $substationId',
//       color: Colors.yellow,
//     );
//   }
// }
