// import 'dart:math';
// import 'dart:convert';
// import 'package:arcgis_maps/arcgis_maps.dart';
// import '../../api/map_api.dart';
// import '../../api/pole_api.dart';
// // import '../../api/api.dart';
// import '../../constants/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// enum LayerType {
//   chattogram_zone,
//   cumilla_zone,
//   mymenshing_zone,
//   sylhet_zone,
//   circle,
//   snd,
//   esu,
//   substation,
//   feederline_33kv,
//   feederline_11kV,
//   feederline_04kV,
//   pole_33KV,
//   pole_11KV,
//   pole_04KV,
//   consumers,
//   serviceLine,
//   dt,
//   servicepoint
// }

// class MapLoadingService {
//   //final String _baseUrl = 'https://www.arcgisbd.com/server/rest/services/bpdb';
//   final String _baseUrl =
//       'https://www.arcgisbd.com/server/rest/services/bpdb/bpdb_web_maps/MapServer';
//   //https://www.arcgisbd.com/server/rest/services/bpdb/bpdb_web_maps/MapServer
//   final String _mobileBaseUrl =
//       'https://www.arcgisbd.com/server/rest/services/bpdb/bpdb_mobile_app/MapServer';
//   final ArcGISMap map;
//   final ArcGISMapViewController mapViewController;

//   MapLoadingService({
//     required this.map,
//     required this.mapViewController,
//   });

//   void loadBaseMap() {
//     map.operationalLayers.clear();

//     // Set initial viewpoint to Bangladesh
//     mapViewController.setViewpoint(
//       Viewpoint.withLatLongScale(
//         latitude: defaultViewPoint.latitude,
//         longitude: defaultViewPoint.longitude,
//         scale: defaultViewPoint.scale,
//       ),
//     );
//   }

//   final Set<LayerType> _loadedLayers = {};
//   final layerChangedNotifier = ValueNotifier<Set<LayerType>>({});
//   Set<LayerType> get loadedLayers => _loadedLayers;
//   void updateLoadedLayers(Set<LayerType> layersToAdd) {
//     _loadedLayers.clear();
//     _loadedLayers.addAll(layersToAdd);
//     layerChangedNotifier.value = Set.from(_loadedLayers);
//   }

//   FeatureLayer? _zoneFeatureLayer;
//   FeatureLayer? _circleFeatureLayer;
//   FeatureLayer? _sndFeatureLayer;
//   FeatureLayer? _esuFeatureLayer;
//   FeatureLayer? _structureFeatureLayer;
//   FeatureLayer? _substationFeatureLayer;

//   FeatureLayer? _poleFeatureLayer;
//   FeatureLayer? _dtFeatureLayer;
//   FeatureLayer? _servicePointFeatureLayer;

//   FeatureLayer? _consumerFeatureLayer;
//   FeatureLayer? _consumerLineFeatureLayer;
//   FeatureLayer? _feederLineFeatureLayer;

//   void clearAllLayers() {
//     _loadedLayers.clear();
//     // layerChangedNotifier.value = Set.from(_loadedLayers);
//     map.operationalLayers.clear();
//     loadBaseMap();
//   }

//   Future<void> loadAndCenterZone(int zoneId) async {
//     try {
//       // Fetch zone detail info
//       await MapApi.fetchZoneDetailsInfo(zoneId);

//       // Remove previous zone layer if it exists
//       if (_zoneFeatureLayer != null) {
//         map.operationalLayers.remove(_zoneFeatureLayer);
//         _zoneFeatureLayer = null;
//       }

//       // Create the new FeatureLayer
//       // final zoneLayerUrl = Uri.parse('$_baseUrl/15');
//       final zoneLayerUrl = Uri.parse('$_mobileBaseUrl/15');
//       final zoneFeatureTable = ServiceFeatureTable.withUri(zoneLayerUrl);

//       // final zoneFeatureLayer = FeatureLayer.withFeatureTable(zoneFeatureTable);
//       // zoneFeatureLayer.definitionExpression = "zone_id = $zoneId";
//       final zoneFeatureLayer = FeatureLayer.withFeatureTable(zoneFeatureTable)
//         ..definitionExpression = "zone_id = $zoneId"
//         ..opacity = 0.1
//         ..labelsEnabled = false;

//       // Store reference to this layer for next time
//       _zoneFeatureLayer = zoneFeatureLayer;

//       // Add new layer to map
//       map.operationalLayers.add(zoneFeatureLayer);

//       // Set map view
//       mapViewController.setViewpoint(
//         Viewpoint.withLatLongScale(
//           latitude: GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//           longitude:
//               GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//           scale: 2000005,
//         ),
//       );

//       // Update UI state
//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       if (zoneId == 1) {
//         layersToUpdate.add(LayerType.chattogram_zone);
//       } else if (zoneId == 2) {
//         layersToUpdate.add(LayerType.cumilla_zone);
//       } else if (zoneId == 3) {
//         layersToUpdate.add(LayerType.mymenshing_zone);
//       } else if (zoneId == 4) {
//         layersToUpdate.add(LayerType.sylhet_zone);
//       }

//       updateLoadedLayers(layersToUpdate);
//     } catch (e) {
//       // Handle error appropriately
//       print('Error loading zone: $e');
//     }
//   }

//   Future<void> loadAndCenterCircle(int circleId) async {
//     try {
//       await MapApi.fetchCircleDetailsInfo(circleId);

//       if (_circleFeatureLayer != null) {
//         map.operationalLayers.remove(_circleFeatureLayer);
//         _circleFeatureLayer = null;
//       }

//       final circleLayerUrl = Uri.parse('$_mobileBaseUrl/14');
//       final circleFeatureTable = ServiceFeatureTable.withUri(circleLayerUrl);
//       // final circleFeatureLayer =
//       //     FeatureLayer.withFeatureTable(circleFeatureTable);
//       // circleFeatureLayer.definitionExpression = "circle_id = $circleId";
//       final circleFeatureLayer =
//           FeatureLayer.withFeatureTable(circleFeatureTable)
//             ..definitionExpression = "circle_id = $circleId"
//             ..opacity = 0.1
//             ..labelsEnabled = false;
//       print(circleFeatureLayer.definitionExpression);

//       _circleFeatureLayer = circleFeatureLayer;
//       map.operationalLayers.add(circleFeatureLayer);

//       mapViewController.setViewpoint(
//         Viewpoint.withLatLongScale(
//           latitude: GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//           longitude:
//               GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//           scale: 1000005,
//         ),
//       );

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(LayerType.circle);
//       updateLoadedLayers(layersToUpdate);
//     } catch (e) {
//       print('Error loading Circle: $e');
//     }
//   }

//   Future<void> loadAndCenterSND(int sndId) async {
//     try {
//       await MapApi.fetchSndDetailsInfo(sndId);

//       if (_sndFeatureLayer != null) {
//         map.operationalLayers.remove(_sndFeatureLayer);
//         _sndFeatureLayer = null;
//       }

//       final sndLayerUrl = Uri.parse('$_mobileBaseUrl/13');
//       final sndFeatureTable = ServiceFeatureTable.withUri(sndLayerUrl);
//       // final sndFeatureLayer = FeatureLayer.withFeatureTable(sndFeatureTable);
//       // sndFeatureLayer.definitionExpression = "snd_id = $sndId";
//       final sndFeatureLayer = FeatureLayer.withFeatureTable(sndFeatureTable)
//         ..definitionExpression = "snd_id = $sndId"
//         ..opacity = 0.1
//         ..labelsEnabled = false;

//       _sndFeatureLayer = sndFeatureLayer;
//       map.operationalLayers.add(sndFeatureLayer);

//       mapViewController.setViewpoint(
//         Viewpoint.withLatLongScale(
//           latitude: GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//           longitude:
//               GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//           scale: 90000,
//         ),
//       );

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(LayerType.snd);
//       updateLoadedLayers(layersToUpdate);
//     } catch (e) {
//       print('Error loading SND: $e');
//     }
//   }

//   Future<void> loadAndCenterESU(int esuId) async {
//     try {
//       await MapApi.fetchEsuDetailsInfo(esuId);

//       if (_esuFeatureLayer != null) {
//         map.operationalLayers.remove(_esuFeatureLayer);
//         _esuFeatureLayer = null;
//       }

//       final esuLayerUrl = Uri.parse('$_mobileBaseUrl/63');
//       final esuFeatureTable = ServiceFeatureTable.withUri(esuLayerUrl);
//       // print(esuFeatureTable.uri);
//       // final esuFeatureLayer = FeatureLayer.withFeatureTable(esuFeatureTable);
//       // esuFeatureLayer.definitionExpression = "esu_id = $esuId";
//       final esuFeatureLayer = FeatureLayer.withFeatureTable(esuFeatureTable)
//         ..definitionExpression = "esu_id = $esuId"
//         ..opacity = 0.1
//         ..labelsEnabled = false;
//       // print(esuFeatureLayer.definitionExpression);

//       _esuFeatureLayer = esuFeatureLayer;
//       map.operationalLayers.add(esuFeatureLayer);

//       mapViewController.setViewpoint(
//         Viewpoint.withLatLongScale(
//           latitude: GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//           longitude:
//               GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//           scale: 50000,
//         ),
//       );

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(LayerType.esu);
//       updateLoadedLayers(layersToUpdate);
//     } catch (e) {
//       print('Error loading ESU: $e');
//     }
//   }

//   // -- Added by MKS -- //

//   // -- Added by MKS -- //

//   Future<void> loadStructureLayer(int substationId) async {
//     try {
//       final filter = "substation_id  = $substationId";

//       if (_structureFeatureLayer != null) {
//         map.operationalLayers.remove(_structureFeatureLayer);
//         _structureFeatureLayer = null;
//       }

//       final servicePointFeatureTable =
//           ServiceFeatureTable.withUri(Uri.parse('$_baseUrl/45'));
//       final servicePointFeatureLayer =
//           FeatureLayer.withFeatureTable(servicePointFeatureTable)
//             ..definitionExpression = filter;

//       await servicePointFeatureLayer.load();

//       _structureFeatureLayer = servicePointFeatureLayer;
//       map.operationalLayers.add(servicePointFeatureLayer);

//       final result = await servicePointFeatureTable.queryFeatures(
//         QueryParameters()
//           ..whereClause = filter
//           ..returnGeometry = true,
//       );

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(LayerType.servicepoint);
//       updateLoadedLayers(layersToUpdate);
//     } catch (e) {
//       print('Error loading service point layer: $e');
//     }
//   }

//   Future<void> loadAndCenterSubstation(int substationId) async {
//     try {
//       await MapApi.fetchSubstationDetailsInfo(substationId);

//       if (_substationFeatureLayer != null) {
//         map.operationalLayers.remove(_substationFeatureLayer);
//         _substationFeatureLayer = null;
//       }

//       final substationLayerUrl = Uri.parse('$_mobileBaseUrl/10');
//       final substationFeatureTable =
//           ServiceFeatureTable.withUri(substationLayerUrl);
//       final substationFeatureLayer =
//           FeatureLayer.withFeatureTable(substationFeatureTable);
//       substationFeatureLayer.definitionExpression =
//           "substation_id = $substationId";

//       _substationFeatureLayer = substationFeatureLayer;
//       map.operationalLayers.add(substationFeatureLayer);

//       mapViewController.setViewpoint(
//         Viewpoint.withLatLongScale(
//           latitude: GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//           longitude:
//               GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//           scale: 1200,
//         ),
//       );

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(LayerType.substation);
//       updateLoadedLayers(layersToUpdate);
//       await loadStructureLayer(substationId);
//     } catch (e) {
//       print('Error loading Substation: $e');
//     }
//   }

//   Future<void> loadPoleLayer(int feederLineId, feederlineTypeId) async {
//     try {
//       final filter = "feederline_id = $feederLineId";
//       Uri? layerUrl;
//       LayerType poleLayerType;

//       // Remove existing pole layer if any
//       if (_poleFeatureLayer != null) {
//         map.operationalLayers.remove(_poleFeatureLayer);
//         _poleFeatureLayer = null;
//       }

//       switch (feederlineTypeId) {
//         case '33 KV':
//           layerUrl = Uri.parse('$_baseUrl/66');
//           poleLayerType = LayerType.pole_33KV;
//           break;
//         case '11 KV':
//           layerUrl = Uri.parse('$_baseUrl/4');
//           poleLayerType = LayerType.pole_11KV;
//           break;
//         case '0.4 KV':
//           layerUrl = Uri.parse('$_baseUrl/68');
//           poleLayerType = LayerType.pole_04KV;
//           break;
//         default:
//           return;
//       }

//       final poleFeatureTable = ServiceFeatureTable.withUri(layerUrl);
//       final poleFeatureLayer = FeatureLayer.withFeatureTable(poleFeatureTable)
//         ..definitionExpression = filter;

//       await poleFeatureLayer.load();

//       _poleFeatureLayer = poleFeatureLayer;
//       map.operationalLayers.add(poleFeatureLayer);

//       final result = await poleFeatureTable.queryFeatures(
//         QueryParameters()
//           ..whereClause = filter
//           ..returnGeometry = true,
//       );

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(poleLayerType);
//       updateLoadedLayers(layersToUpdate);
//     } catch (e) {
//       print('Error loading pole layer: $e');
//     }
//   }

//   Future<void> loadDTLayer(int feederLineId) async {
//     try {
//       final filter = "feederline_id = $feederLineId";

//       if (_dtFeatureLayer != null) {
//         map.operationalLayers.remove(_dtFeatureLayer);
//         _dtFeatureLayer = null;
//       }

//       final dtFeatureTable =
//           ServiceFeatureTable.withUri(Uri.parse('$_baseUrl/62'));
//       final dtFeatureLayer = FeatureLayer.withFeatureTable(dtFeatureTable)
//         ..definitionExpression = filter;

//       await dtFeatureLayer.load();

//       _dtFeatureLayer = dtFeatureLayer;
//       map.operationalLayers.add(dtFeatureLayer);

//       final result = await dtFeatureTable.queryFeatures(
//         QueryParameters()
//           ..whereClause = filter
//           ..returnGeometry = true,
//       );

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(LayerType.dt);
//       updateLoadedLayers(layersToUpdate);
//     } catch (e) {
//       print('Error loading DT layer: $e');
//     }
//   }

//   Future<void> loadServicePointLayer(int feederLineId) async {
//     try {
//       final filter = "feederline_id = $feederLineId";

//       if (_servicePointFeatureLayer != null) {
//         map.operationalLayers.remove(_servicePointFeatureLayer);
//         _servicePointFeatureLayer = null;
//       }

//       final servicePointFeatureTable =
//           ServiceFeatureTable.withUri(Uri.parse('$_baseUrl/48'));
//       final servicePointFeatureLayer =
//           FeatureLayer.withFeatureTable(servicePointFeatureTable)
//             ..definitionExpression = filter;

//       await servicePointFeatureLayer.load();

//       _servicePointFeatureLayer = servicePointFeatureLayer;
//       map.operationalLayers.add(servicePointFeatureLayer);

//       final result = await servicePointFeatureTable.queryFeatures(
//         QueryParameters()
//           ..whereClause = filter
//           ..returnGeometry = true,
//       );

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(LayerType.servicepoint);
//       updateLoadedLayers(layersToUpdate);
//     } catch (e) {
//       print('Error loading service point layer: $e');
//     }
//   }

//   Future<void> loadConsumerLineLayer(int feederLineId) async {
//     try {
//       final filter = "feederline_id = $feederLineId";

//       if (_consumerLineFeatureLayer != null) {
//         map.operationalLayers.remove(_consumerLineFeatureLayer);
//         _consumerLineFeatureLayer = null;
//       }

//       Uri layerUrl = Uri.parse('$_baseUrl/46');
//       final featureTable = ServiceFeatureTable.withUri(layerUrl);
//       final featureLayer = FeatureLayer.withFeatureTable(featureTable)
//         ..definitionExpression = filter;

//       await featureLayer.load();
//       _consumerLineFeatureLayer = featureLayer;
//       map.operationalLayers.add(featureLayer);

//       final result = await featureTable.queryFeatures(
//         QueryParameters()
//           ..whereClause = filter
//           ..returnGeometry = true,
//       );

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(LayerType.serviceLine);
//       updateLoadedLayers(layersToUpdate);
//     } catch (e) {
//       print('Error loading consumer line layer: $e');
//     }
//   }

//   Future<void> loadConsumerLayer(int feederLineId) async {
//     try {
//       final filter = "feederline_id = $feederLineId";

//       if (_consumerFeatureLayer != null) {
//         map.operationalLayers.remove(_consumerFeatureLayer);
//         _consumerFeatureLayer = null;
//       }

//       Uri layerUrl = Uri.parse('$_baseUrl/61');
//       final featureTable = ServiceFeatureTable.withUri(layerUrl);
//       final featureLayer = FeatureLayer.withFeatureTable(featureTable)
//         ..definitionExpression = filter;

//       await featureLayer.load();
//       _consumerFeatureLayer = featureLayer;
//       map.operationalLayers.add(featureLayer);

//       final result = await featureTable.queryFeatures(
//         QueryParameters()
//           ..whereClause = filter
//           ..returnGeometry = true,
//       );

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(LayerType.consumers);
//       updateLoadedLayers(layersToUpdate);
//     } catch (e) {
//       print('Error loading consumer layer: $e');
//     }
//   }

//   Future<void> loadAndCenterFeederLine(int feederLineId) async {
//     try {
//       final feederLine = await MapApi.fetchFeederLineDetailsInfo(feederLineId);
//       final feederlineTypeId = feederLine.feederlinetypeId;

//       Uri? feederLayerUrl;
//       LayerType feederLayerType;

//       // Remove previously added feederline layer
//       if (_feederLineFeatureLayer != null) {
//         map.operationalLayers.remove(_feederLineFeatureLayer);
//         _feederLineFeatureLayer = null;
//       }

//       switch (feederlineTypeId) {
//         case '33 KV':
//           feederLayerUrl = Uri.parse('$_baseUrl/9');
//           feederLayerType = LayerType.feederline_33kv;
//           break;
//         case '11 KV':
//           feederLayerUrl = Uri.parse('$_baseUrl/8');
//           feederLayerType = LayerType.feederline_11kV;
//           break;
//         case '0.4 KV':
//           feederLayerUrl = Uri.parse('$_baseUrl/7');
//           feederLayerType = LayerType.feederline_04kV;
//           break;
//         default:
//           return;
//       }

//       final featureTable = ServiceFeatureTable.withUri(feederLayerUrl);
//       final featureLayer = FeatureLayer.withFeatureTable(featureTable)
//         ..definitionExpression = "feederline_id = $feederLineId";

//       await featureLayer.load();
//       _feederLineFeatureLayer = featureLayer;
//       map.operationalLayers.add(featureLayer);

//       mapViewController.setViewpoint(
//         Viewpoint.withLatLongScale(
//           latitude: GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//           longitude:
//               GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//           scale: GlobalVariables.defaultZoomLevel != null
//               ? zoomToScale(GlobalVariables.defaultZoomLevel!.toInt())
//               : defaultViewPoint.scale,
//         ),
//       );
//       final currentViewpoint = await mapViewController
//           .getCurrentViewpoint(ViewpointType.centerAndScale);
//       final currentScale = currentViewpoint?.targetScale;
//       print("Current map scale: $currentScale");

//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(feederLayerType);
//       updateLoadedLayers(layersToUpdate);

//       // -- Load additional linked layers -- //
//       await loadPoleLayer(feederLineId, feederlineTypeId);
//       await loadDTLayer(feederLineId);
//       await loadConsumerLineLayer(feederLineId);
//       await loadConsumerLayer(feederLineId);
//       await loadServicePointLayer(feederLineId);
//     } catch (e) {
//       print('Error loading feeder line: $e');
//     }
//   }

//   // -- Added by MKS -- //
//   Future<void> loadAndCenterPole(int poleId) async {
//     try {
//       final poleDetails = await MapApi.fetchPoleDetailsInfo(poleId);
//       final callPoleApi = CallPoleApi();
//       final polePoint = await callPoleApi.fetchPolesById(poleId);
//       final poleCode = poleDetails.poleCode;
//       final lat = polePoint.first.latitude;
//       final long = polePoint.first.longitude;
//       final filter = "pole_code = '$poleCode'";
//       final lineTypeName = poleDetails.lineTypeName;
//       LayerType poleLayerType;
//       Uri? layerUrl;

//       switch (lineTypeName) {
//         case '33 KV':
//           poleLayerType = LayerType.pole_33KV;
//           layerUrl = Uri.parse('$_baseUrl/general/MapServer/1');
//           break;
//         case '11 KV':
//           poleLayerType = LayerType.pole_11KV;
//           layerUrl = Uri.parse('$_baseUrl/general/MapServer/2');
//           break;
//         default:
//           return;
//       }
//       final poleFeatureTable = ServiceFeatureTable.withUri(layerUrl);
//       final poleFeatureLayer = FeatureLayer.withFeatureTable(poleFeatureTable);

//       poleFeatureLayer.definitionExpression = filter;

//       map.operationalLayers.add(poleFeatureLayer);

//       await poleFeatureLayer.load();

//       final queryParams = QueryParameters()
//         ..whereClause = filter
//         ..returnGeometry = true
//         ..maxFeatures = 1;

//       final result = await poleFeatureTable.queryFeatures(queryParams);
//       final features = result.features;

//       if (features().isNotEmpty) {
//         mapViewController.setViewpoint(
//           Viewpoint.withLatLongScale(
//             latitude: lat,
//             longitude: long,
//             scale: GlobalVariables.defaultZoomLevel != null
//                 ? zoomToScale(GlobalVariables.defaultZoomLevel!.toInt())
//                 : defaultViewPoint.scale,
//           ),
//         );
//       } else {
//         // Fallback to default view
//         mapViewController.setViewpoint(
//           Viewpoint.withLatLongScale(
//             latitude:
//                 GlobalVariables.centerLatitude ?? defaultViewPoint.latitude,
//             longitude:
//                 GlobalVariables.centerLongitude ?? defaultViewPoint.longitude,
//             scale: GlobalVariables.defaultZoomLevel != null
//                 ? zoomToScale(GlobalVariables.defaultZoomLevel!.toInt())
//                 : defaultViewPoint.scale,
//           ),
//         );
//       }
//       //await loadServiceLineLayer(poleDetails.poleDetailsId);
//       Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//       layersToUpdate.add(poleLayerType);
//       updateLoadedLayers(layersToUpdate);

//       // await loadConsumerLineLayer(poleDetails.poleDetailsId);
//       await loadConsumerLayer(poleDetails.poleDetailsId);
//     } catch (e) {
//       // print('Error loading POLE: $e');
//     }
//   }
//   // -- Added by MKS -- //

//   Polygon createCirclePolygon({
//     required double centerLat,
//     required double centerLon,
//     required double radiusMeters,
//     int segments = 60,
//   }) {
//     final builder = PolygonBuilder(spatialReference: SpatialReference.wgs84);
//     // You add points to the builder
//     const double earthRadius = 6371000.0;

//     for (int i = 0; i <= segments; i++) {
//       final double angle = 2 * pi * i / segments;
//       final double dx = radiusMeters * cos(angle);
//       final double dy = radiusMeters * sin(angle);

//       // Convert meters to degrees (approximately)
//       final double latOffset = dy / earthRadius * (180 / pi);
//       final double lonOffset =
//           dx / (earthRadius * cos(centerLat * pi / 180)) * (180 / pi);

//       final double lat = centerLat + latOffset;
//       final double lon = centerLon + lonOffset;

//       // Use ArcGISPoint (or the SDK equivalent) to add to the builder
//       final point = ArcGISPoint(
//         x: lon,
//         y: lat,
//         spatialReference: SpatialReference.wgs84,
//       );
//       builder.addPoint(point);
//     }

//     return builder.toGeometry() as Polygon;
//   }

//   Future<void> loadAndCenterRangeConsumers(List<dynamic> consumers) async {
//     try {
//       if (consumers.isEmpty) return;

//       // Remove previous consumer layer if exists
//       if (_consumerFeatureLayer != null) {
//         map.operationalLayers.remove(_consumerFeatureLayer);
//         _consumerFeatureLayer = null;
//       }

//       // Create filter string for consumers
//       final consumerNos = consumers.map((c) => "'$c'").toList();
//       final filter = "consumer_no IN (${consumerNos.join(',')})";

//       String firstConsumer = consumers.first;
//       final MapApi _mapApi = MapApi();
//       final consumerDetail = await _mapApi.fetchConsumerById(firstConsumer);
//       final substationId = consumerDetail['substationId'] is int
//           ? consumerDetail['substationId'] as int
//           : int.tryParse(consumerDetail['substationId']?.toString() ?? '');

//       final feederlineId = consumerDetail['feederLineId'] is int
//           ? consumerDetail['feederLineId'] as int
//           : int.tryParse(consumerDetail['feederLineId']?.toString() ?? '');
//       await loadAndCenterSubstation(substationId!);
//       await loadAndCenterFeederLine(feederlineId!);

//       final layerUrl = Uri.parse('$_baseUrl/61');
//       final featureTable = ServiceFeatureTable.withUri(layerUrl);
//       final featureLayer = FeatureLayer.withFeatureTable(featureTable)
//         ..definitionExpression = filter;

//       await featureLayer.load();
//       _consumerFeatureLayer = featureLayer;
//       map.operationalLayers.add(featureLayer);

//       // Draw circle & center map
//       if (consemerRange.lat != null &&
//           consemerRange.long != null &&
//           consemerRange.range != null) {
//         // Center the map first
//         mapViewController.setViewpoint(
//           Viewpoint.withLatLongScale(
//             latitude: consemerRange.lat!,
//             longitude: consemerRange.long!,
//             scale: 1128.4971763449764,
//           ),
//         );

//         // ✅ Create circle polygon using your helper
//         final circlePolygon = createCirclePolygon(
//           centerLat: consemerRange.lat!,
//           centerLon: consemerRange.long!,
//           radiusMeters: consemerRange.range!,
//         );

//         // Style for circle
//         final circleSymbol = SimpleFillSymbol(
//           style: SimpleFillSymbolStyle.solid,
//           color: Colors.blue.withOpacity(0.2),
//           outline: SimpleLineSymbol(
//             style: SimpleLineSymbolStyle.solid,
//             color: Colors.blue,
//             width: 2,
//           ),
//         );

//         final circleGraphic = Graphic(
//           geometry: circlePolygon,
//           symbol: circleSymbol,
//         );

//         mapViewController.graphicsOverlays.clear();
//         final overlay = GraphicsOverlay();
//         overlay.graphics.add(circleGraphic);
//         mapViewController.graphicsOverlays.add(overlay);

//         Set<LayerType> layersToUpdate = Set.from(_loadedLayers);
//         updateLoadedLayers(layersToUpdate);
//       }
//     } catch (e) {
//       print('Error loading range consumers: $e');
//     }
//   }
// }
