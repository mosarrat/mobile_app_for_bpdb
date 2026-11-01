// import 'package:flutter/material.dart';
// import 'package:arcgis_maps/arcgis_maps.dart';

// class MapLicense extends StatefulWidget {
//   final String title;
//   const MapLicense({super.key, required this.title});

//   @override
//   State<MapLicense> createState() => _MapLicenseState();
// }

// class _MapLicenseState extends State<MapLicense> {
//   late ArcGISMap _map;
//   late ArcGISMapImageLayer _imageLayer;
//   late ArcGISMapViewController _mapViewController;

//   @override
//   void initState() {
//     super.initState();

//     // ✅ Set runtime license key
//     ArcGISEnvironment.setLicenseUsingKey(
//       'runtimelite,1000,rud1038211312,none,4N5X0H4AH580A1GJH006',
//     );

//     // ✅ Create World Imagery basemap
//     final basemapLayer = ArcGISTiledLayer.withUri(
//       Uri.parse('https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer'),
//     );
//     final basemap = Basemap.withLayers(
//       baseLayers: [basemapLayer],
//       referenceLayers: [],
//     );

//     // ✅ Create ArcGISMap
//     _map = ArcGISMap.withBasemap(basemap);

//     // ✅ Add BPDB MapServer as operational layer
//     _imageLayer = ArcGISMapImageLayer.withUri(
//       Uri.parse(
//         'https://www.arcgisbd.com/server/rest/services/bpdb/bpdb_mobile_app/MapServer',
//       ),
//     );
//     _map.operationalLayers.add(_imageLayer);

//     // ✅ Set initial viewpoint for Bangladesh
//     _map.initialViewpoint = Viewpoint.withLatLongScale(
//       latitude: 23.6850,
//       longitude: 90.3563,
//       scale: 800000, // adjust to fit your layer nicely
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Colors.blue,
//       ),
//       body: SafeArea(
//         child: ArcGISMapView(
//           controllerProvider: () {
//             _mapViewController = ArcGISMapView.createController()
//               ..arcGISMap = _map;
//             return _mapViewController;
//           },
//           onMapViewReady: () async {
//             debugPrint('✅ ArcGIS MapView is ready');
//             // Optional: animate to viewpoint for smooth zoom
//             await _mapViewController.setViewpointAnimated(
//               Viewpoint.withLatLongScale(
//                 latitude: 23.6850,
//                 longitude: 90.3563,
//                 scale: 5000000,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

