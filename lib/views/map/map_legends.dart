// import 'package:flutter/material.dart';
// import 'layer_loading_service.dart';

// class MapLegends extends StatefulWidget {
//   const MapLegends({
//     super.key, 
//     required this.isVisible, 
//     required this.onClose,
//     required this.loadedLayers,
//     this.onClearAll, 
     
//   });

//   final bool isVisible;
//   final VoidCallback onClose;
//   final Set<LayerType> loadedLayers;
//   final VoidCallback? onClearAll; //jal

//   @override
//   State<MapLegends> createState() => _MapLegendsState();
// }

// class _MapLegendsState extends State<MapLegends> {
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     double popupHeight;
//     double topbarWidth;
//     double topspaceWidth;

//     if (height < 1300 && height > 900) {
//       popupHeight = height * 0.3;
//     } else if (height < 900 && height > 600) {
//       popupHeight = height * 0.28;
//     } else if (height < 600 && height > 400) {
//       popupHeight = height * 0.48;
//     } else if (height < 400 && height > 200) {
//       popupHeight = height * 0.5;
//     } else {
//       popupHeight = height * 0.28;
//     }

//     if (width < 1300 && width > 900) {
//       topbarWidth = width * 0.2;
//       topspaceWidth = width * 0.03;
//     } else if (width < 900 && width > 600) {
//       topbarWidth = width / 7.5;
//       topspaceWidth = width / 14;
//     } else if (width < 600 && width > 400) {
//       topbarWidth = width * 0.26;
//       topspaceWidth = width * 0.03;
//     } else if (width < 400 && width > 200) {
//       topbarWidth = width * 0.26;
//       topspaceWidth = width *0.03;
//     } else {
//       topbarWidth = width * 0.2;
//       topspaceWidth = width * 0.002;
//     }
    
//     return Visibility(
//       visible: widget.isVisible,
//       child: Container( 
//         height: popupHeight, 
//         color: Colors.grey[300],
//         child: Column(
//           children: [
//             Card(
//               color: const Color.fromARGB(255, 5, 161, 182),
//               margin: EdgeInsetsDirectional.zero,
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(2),
//                   topRight: Radius.circular(2),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: topbarWidth,
//                     height: 40,
//                     child: const Padding(
//                       padding: EdgeInsets.only(left: 12),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           "Map Legend",
//                           style: TextStyle(
//                             fontSize: 15.2,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: topspaceWidth),
//                   Expanded(child: Container()), 
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     iconSize: 16,
//                     onPressed: widget.onClose,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: widget.loadedLayers.isEmpty
//                 ? const Center(
//                     child: Text(
//                       "No layers loaded yet",
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   )
//                 : Scrollbar(
//                     thumbVisibility: true,
//                     interactive: true,
//                     radius: Radius.elliptical(8.0, 2.0),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           // Only show legends for layers that are loaded
//                           if (widget.loadedLayers.contains(LayerType.chattogram_zone))
//                             _buildLegendCard('chattogram.png', 'Chattogram Zone'),
//                           if (widget.loadedLayers.contains(LayerType.cumilla_zone))
//                             _buildLegendCard('cumilla.png', 'Cumilla Zone'),
//                           if (widget.loadedLayers.contains(LayerType.mymenshing_zone))
//                             _buildLegendCard('mymensingh.png', 'Mymensingh Zone'),
//                           if (widget.loadedLayers.contains(LayerType.sylhet_zone))
//                             _buildLegendCard('sylhet.png', 'Sylhet Zone'),
//                             // _buildLegendCard('zone.png', 'Zone'),
//                           if (widget.loadedLayers.contains(LayerType.circle))
//                             _buildLegendCard('circle.png', 'Circle'),
//                           if (widget.loadedLayers.contains(LayerType.snd))
//                             _buildLegendCard('snd.png', 'SnD'),
//                           if (widget.loadedLayers.contains(LayerType.esu))
//                             _buildLegendCard('esu.png', 'Esu'),
//                           if (widget.loadedLayers.contains(LayerType.substation))
//                             _buildLegendCard('new_substation.png', 'Substation'),
                          
//                           if (widget.loadedLayers.contains(LayerType.feederline_33kv))
//                             _buildLegendCard('feederline_33k.png', '33kV Feeder Line'),
//                           if (widget.loadedLayers.contains(LayerType.feederline_11kV))
//                             _buildLegendCard('feederline_11k.png', '11kV Feeder Line'),
//                           if (widget.loadedLayers.contains(LayerType.feederline_04kV))
//                             _buildLegendCard('feederline_0.4k.png', '0.4kV Feeder Line'),
//                           if (widget.loadedLayers.contains(LayerType.pole_33KV))
//                             _buildLegendCard('pole_33kv.png', 'Pole 33KV'),
//                           if (widget.loadedLayers.contains(LayerType.pole_11KV))
//                             _buildLegendCard('pole_11kv.png', 'Pole 11KV'),
//                           if (widget.loadedLayers.contains(LayerType.pole_04KV))
//                             _buildLegendCard('lt_pole.png', 'Pole 0.4KV'),
//                           if (widget.loadedLayers.contains(LayerType.dt))
//                             _buildLegendCard('dt.png', 'Distribution Transformer (DT)'),
//                             if (widget.loadedLayers.contains(LayerType.consumers))
//                             _buildLegendCard('consumers.png', 'Consumers'),
//                           if (widget.loadedLayers.contains(LayerType.serviceLine))
//                             _buildLegendCard('consumer_serviceline.png', 'Service Line'),
//                           if (widget.loadedLayers.contains(LayerType.servicepoint))
//                             _buildLegendCard('service_point.png', 'Service Point'),
//                         ],
//                       ),
//                     ),
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLegendCard(String assetName, String title) {
//     return Column(
//       children: [
//         Card(
//           color: Colors.white,
//           shadowColor: Colors.transparent,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(2),
//               topRight: Radius.circular(2),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Row(
//               children: [
//                 Image.asset(
//                   'assets/map_legend/$assetName',
//                   width: 24,
//                   height: 24,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 12,  
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }