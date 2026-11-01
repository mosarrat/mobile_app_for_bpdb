// import 'package:flutter/material.dart';

// import '../../api/map_api.dart';
// import 'consumerPopup.dart';

// class FeaturePopupService {
//   // Show a popup dialog with feature attributes
//   void showFeaturePopup(
//     BuildContext context,
//     Map<String, Object?> attributes,
//     String title,
//     String? idKey,
//   ) {
//     final poleDetails;
//     final poles;
//     if (attributes.length == 2 && idKey == 'pole_details_id') {
//       poleDetails = (attributes['poleDetails'] ?? {}) as Map<String, dynamic>;
//       poles = (attributes['poles'] ?? {}) as Map<String, dynamic>;
//     } else {
//       poleDetails = "";
//       poles = "";
//     }

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(3)),
//         ),
//         contentPadding: const EdgeInsets.all(0),
//         insetPadding: const EdgeInsets.symmetric(horizontal: 30),
//         backgroundColor: const Color.fromARGB(255, 3, 89, 100),
//         title: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 15),
//             ],
//           ),
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Card(
//                 shadowColor: Colors.transparent,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(2),
//                     topRight: Radius.circular(2),
//                   ),
//                 ),
//                 color: Colors.white,
//                 margin: const EdgeInsets.all(0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // ...attributes.entries
//                       //     .map((e) => Column(
//                       //           children: [
//                       //             _attributeContainer(
//                       //               label: "${e.value}",
//                       //               title: _formatFieldName(e.key),
//                       //             ),
//                       //             const Divider(height: 0),
//                       //           ],
//                       //         ))
//                       //     .toList(),
//                       if (idKey == 'zone_id') ...[
//                         _attributeContainer(
//                             title: 'Zone Name',
//                             label: "${attributes['zoneName']}"),
//                         _attributeContainer(
//                             title: 'Number of Circles', label: "${attributes['totalCircle']}"),
//                         _attributeContainer(
//                             title: 'Area', label: ""),
//                         _attributeContainer(
//                             title: 'Number of 33KV Feeder Line', label: "${attributes['feeder33KvCount']}"),
//                         _attributeContainer(
//                             title: 'Number of 11KV Feeder Line', label: "${attributes['feeder11KvCount']}"),
//                         _attributeContainer(
//                             title: 'Number of 0.4KV Feeder Line', label: "${attributes['feeder04KvCount']}"),
//                          _attributeContainer(
//                             title: '33KV Feeder Line Length (m)', label: "${attributes['feeder33KvLength']}"),
//                         _attributeContainer(
//                             title: '11KV Feeder Line Length (m)', label: "${attributes['feeder11KvLength']}"),
//                         _attributeContainer(
//                             title: '0.4KV Feeder Line Length (m)', label: "${attributes['feeder04KvLength']}"),
//                         _attributeContainer(
//                             title: 'Total Consumers', label: "${attributes['totalConsumers']}"),
//                         _attributeContainer(
//                             title: 'Total Three Phrase Consumers', label: "${attributes['threePhase']}"),
//                         _attributeContainer(
//                             title: 'Total Single Phrase Consumers', label: "${attributes['singlePhase']}"),
//                         _attributeContainer(
//                             title: 'Number of Pole', label: "${attributes['totalPole']}"),
//                         _attributeContainer(
//                             title: 'Number of DT', label: "${attributes['totalDT']}"),
//                         _attributeContainer(
//                             title: 'Latitude',
//                             label: "${attributes['centerLatitude']}"),
//                         _attributeContainer(
//                             title: 'Longitude',
//                             label: "${attributes['centerLongitude']}"),
//                       ] else if (idKey == 'circle_id') ...[
//                         _attributeContainer(
//                             title: 'Circle Name',
//                             label: "${attributes['circleName']}"),
//                          _attributeContainer(
//                             title: 'Number of S&D', label: "${attributes['totalSnd']}"),
//                         _attributeContainer(
//                             title: 'Number of ESU', label: "${attributes['totalEsu']}"),
//                         _attributeContainer(
//                             title: 'Area', label: ""),
//                         _attributeContainer(
//                             title: 'Number of 33KV Feeder Line', label: "${attributes['feeder33KvCount']}"),
//                         _attributeContainer(
//                             title: 'Number of 11KV Feeder Line', label: "${attributes['feeder11KvCount']}"),
//                         _attributeContainer(
//                             title: 'Number of 0.4KV Feeder Line', label: "${attributes['feeder04KvCount']}"),
//                          _attributeContainer(
//                             title: '33KV Feeder Line Length (m)', label: "${attributes['feeder33KvLength']}"),
//                         _attributeContainer(
//                             title: '11KV Feeder Line Length (m)', label: "${attributes['feeder11KvLength']}"),
//                         _attributeContainer(
//                             title: '0.4KV Feeder Line Length (m)', label: "${attributes['feeder04KvLength']}"),
//                         _attributeContainer(
//                             title: 'Total Consumers', label: "${attributes['totalConsumers']}"),
//                         _attributeContainer(
//                             title: 'Total Three Phrase Consumers', label: "${attributes['threePhase']}"),
//                         _attributeContainer(
//                             title: 'Total Single Phrase Consumers', label: "${attributes['singlePhase']}"),
//                         _attributeContainer(
//                             title: 'Number of Pole', label: "${attributes['totalPole']}"),
//                         _attributeContainer(
//                             title: 'Number of DT', label: "${attributes['totalDT']}"),
//                         _attributeContainer(
//                             title: 'Latitude',
//                             label: "${attributes['centerLatitude']}"),
//                         _attributeContainer(
//                             title: 'Longitude',
//                             label: "${attributes['centerLongitude']}"),
//                       ] else if (idKey == 'snd_id') ...[
//                         _attributeContainer(
//                             title: 'SnD Name',
//                             label: "${attributes['snDName']}"),
//                         _attributeContainer(
//                             title: 'Number of ESU', label: "${attributes['totalEsu']}"),
//                         _attributeContainer(
//                             title: 'Number of Substations', label: "${attributes['totalSubstation']}"),
//                         _attributeContainer(
//                             title: 'Area', label: ""),
//                         _attributeContainer(
//                             title: 'Number of 33KV Feeder Line', label: "${attributes['feeder33KvCount']}"),
//                         _attributeContainer(
//                             title: 'Number of 11KV Feeder Line', label: "${attributes['feeder11KvCount']}"),
//                         _attributeContainer(
//                             title: 'Number of 0.4KV Feeder Line', label: "${attributes['feeder04KvCount']}"),
//                          _attributeContainer(
//                             title: '33KV Feeder Line Length (m)', label: "${attributes['feeder33KvLength']}"),
//                         _attributeContainer(
//                             title: '11KV Feeder Line Length (m)', label: "${attributes['feeder11KvLength']}"),
//                         _attributeContainer(
//                             title: '0.4KV Feeder Line Length (m)', label: "${attributes['feeder04KvLength']}"),
//                         _attributeContainer(
//                             title: 'Total Consumers', label: "${attributes['totalConsumers']}"),
//                         _attributeContainer(
//                             title: 'Total Three Phrase Consumers', label: "${attributes['threePhase']}"),
//                         _attributeContainer(
//                             title: 'Total Single Phrase Consumers', label: "${attributes['singlePhase']}"),
//                         _attributeContainer(
//                             title: 'Number of Pole', label: "${attributes['totalPole']}"),
//                         _attributeContainer(
//                             title: 'Number of DT', label: "${attributes['totalDT']}"),
//                         _attributeContainer(
//                             title: 'Latitude',
//                             label: "${attributes['centerLatitude']}"),
//                         _attributeContainer(
//                             title: 'Longitude',
//                             label: "${attributes['centerLongitude']}"),
//                       ] else if (idKey == 'esu_id') ...[
//                        _attributeContainer(
//                             title: 'ESU Name',
//                             label: "${attributes['esuName']}"),
//                         _attributeContainer(
//                             title: 'Number of Substations', label: "${attributes['totalSubstation']}"),
//                         _attributeContainer(
//                             title: 'Area', label: ""),
//                         _attributeContainer(
//                             title: 'Number of 33KV Feeder Line', label: "${attributes['feeder33KvCount']}"),
//                         _attributeContainer(
//                             title: 'Number of 11KV Feeder Line', label: "${attributes['feeder11KvCount']}"),
//                         _attributeContainer(
//                             title: 'Number of 0.4KV Feeder Line', label: "${attributes['feeder04KvCount']}"),
//                          _attributeContainer(
//                             title: '33KV Feeder Line Length (m)', label: "${attributes['feeder33KvLength']}"),
//                         _attributeContainer(
//                             title: '11KV Feeder Line Length (m)', label: "${attributes['feeder11KvLength']}"),
//                         _attributeContainer(
//                             title: '0.4KV Feeder Line Length (m)', label: "${attributes['feeder04KvLength']}"),
//                         _attributeContainer(
//                             title: 'Total Consumers', label: "${attributes['totalConsumers']}"),
//                         _attributeContainer(
//                             title: 'Total Three Phrase Consumers', label: "${attributes['threePhase']}"),
//                         _attributeContainer(
//                             title: 'Total Single Phrase Consumers', label: "${attributes['singlePhase']}"),
//                         _attributeContainer(
//                             title: 'Number of Pole', label: "${attributes['totalPole']}"),
//                         _attributeContainer(
//                             title: 'Number of DT', label: "${attributes['totalDT']}"),
//                         _attributeContainer(
//                             title: 'Latitude',
//                             label: "${attributes['centerLatitude']}"),
//                         _attributeContainer(
//                             title: 'Longitude',
//                             label: "${attributes['centerLongitude']}"),
//                       ] else if (idKey == 'substation_id') ...[
//                         _attributeContainer(
//                             title: 'Substation Name',
//                             label: "${attributes['substationName']}"),
//                         _attributeContainer(
//                             title: 'Substation Type',
//                             label: "${attributes['substationTypeName']}"),
//                         _attributeContainer(
//                             title: 'Nominal Voltage',
//                             label: "${attributes['nominalVoltage'] ?? ''}"),
//                         _attributeContainer(
//                             title: 'Installed Capacity',
//                             label: "${attributes['installedCapacity'] ?? ''}"),
//                         _attributeContainer(
//                             title: 'Maximum Demand',
//                             label: "${attributes['maximumDemand'] ?? ''}"),
//                         _attributeContainer(
//                             title: 'Peak Load',
//                             label: "${attributes['peakLoad'] ?? ''}"),
//                         _attributeContainer(
//                             title: 'Location',
//                             label: "${attributes['location'] ?? ''}"),
//                         _attributeContainer(
//                             title: 'Area Of Substation',
//                             label: "${attributes['areaOfSubstation'] ?? ''}"),
//                         _attributeContainer(
//                             title: 'Total Capacity Cal',
//                             label: "${attributes['totalCapacityCal'] ?? ''}"),
//                         _attributeContainer(
//                             title: 'Year Of Commissioning',
//                             label: "${attributes['yearOfComissioning'] ?? ''}"),
//                         _attributeContainer(
//                             title: 'Number of 11KV Feeder Line',
//                             label: "${attributes['feeder11KvCount']}"),
//                         _attributeContainer(
//                             title: 'Number of 0.4KV Feeder Line',
//                             label: "${attributes['feeder04KvCount']}"),
//                         _attributeContainer(
//                             title: 'No of Power Transformer',
//                             label: ""),
//                         _attributeContainer(
//                             title: 'Latitude',
//                             label: "${attributes['latitude']}"),
//                         _attributeContainer(
//                             title: 'Longitude',
//                             label: "${attributes['longitude']}"),
//                       ] else if (idKey == 'feederline_id') ...[
//                         _attributeContainer(
//                             title: 'Zone', label: "${attributes['zoneId']}"),
//                         _attributeContainer(
//                             title: 'Circle',
//                             label: "${attributes['circleId']}"),
//                         _attributeContainer(
//                             title: 'SnD', label: "${attributes['sndId']}"),
//                         _attributeContainer(
//                             title: 'Source Substation',
//                             label: "${attributes['sourceSubstationId']}"),
//                         _attributeContainer(
//                             title: 'Destination Substation',
//                             label: "${attributes['destinationSubstationId'] ?? ''}"),
//                         _attributeContainer(
//                             title: 'Feeder Line Id',
//                             label: "${attributes['feederLineId']}"),
//                         _attributeContainer(
//                             title: 'Feeder Line Code',
//                             label: "${attributes['feederLineCode']}"),
//                         _attributeContainer(
//                             title: 'Feeder Line Name',
//                             label: "${attributes['feederlineName']}"),
//                         _attributeContainer(
//                             title: 'Feeder Line Type',
//                             label: "${attributes['feederLineTypeId']}"),
//                         _attributeContainer(
//                             title: 'Feeder Conductor Type',
//                             label: "${attributes['feederConductorTypeId']}"),
//                         _attributeContainer(
//                             title: 'Nominal Voltage',
//                             label: "${attributes['nominalVoltage']}"),
//                       ] else if (idKey == 'pole_details_id') ...[
//                         // _attributeContainer(
//                         //     title: 'Zone', label: "${attributes['zoneName']}"),
//                         // _attributeContainer(
//                         //     title: 'Circle',
//                         //     label: "${attributes['circleName']}"),
//                         // _attributeContainer(
//                         //     title: 'SnD', label: "${attributes['snDName']}"),
//                         // _attributeContainer(
//                         //     title: 'ESU', label: "${attributes['esuName']}"),
//                         // _attributeContainer(
//                         //     title: 'Substation',
//                         //     label: "${attributes['substationName']}"),
//                         // _attributeContainer(
//                         //     title: 'Feeder Line Name',
//                         //     label: "${attributes['feederlineName']}"),
//                         _attributeContainer(
//                             title: 'Feeder Wise Serial No',
//                             label: "${poleDetails['feederWiseSerialNo']}"),
//                         _attributeContainer(
//                             title: 'Pole No',
//                             label: "${poleDetails['poleNo']}"),
//                         _attributeContainer(
//                             title: 'Line Type',
//                             label: "${poleDetails['lineTypeName']}"),
//                         _attributeContainer(
//                             title: 'Pole Condition',
//                             label: "${poles['conditionName']}"),
//                         _attributeContainer(
//                             title: 'Pole Type',
//                             label: "${poles['poleTypeName']}"),
//                         _attributeContainer(
//                             title: 'Pole Height',
//                             label: "${poles['poleHeight']}"),
//                         _attributeContainer(
//                             title: 'Latitude', label: "${poles['latitude']}"),
//                         _attributeContainer(
//                             title: 'Longitude', label: "${poles['longitude']}"),
//                         _attributeContainer(
//                             title: 'Wire Tpe', label: "${poleDetails['name']}"),
//                         _attributeContainer(
//                             title: 'No of 0.4KV Line',
//                             label: "${poles['noOfLineP4Kv']}"),
//                         _attributeContainer(
//                             title: 'No of 11KV Line',
//                             label: "${poles['noOfLine11Kv']}"),
//                         _attributeContainer(
//                             title: 'No of 33KV Line',
//                             label: "${poles['noOfLine33Kv'] ?? ''}"),
//                         _attributeContainer(
//                           title: 'Is Neutral',
//                           label:
//                               (poleDetails['neutral'] == true) ? 'Yes' : 'No',
//                         ),
//                         _attributeContainer(
//                           title: 'In Right Pole',
//                           label: (poleDetails['isRightPole'] == true)
//                               ? 'Yes'
//                               : 'No',
//                         ),
//                         _attributeContainer(
//                           title: 'Is Street Light',
//                           label: (poles['streetLight'] == true) ? 'Yes' : 'No',
//                         ),
//                         _attributeContainer(
//                           title: 'Transformer Exist',
//                           label: (poles['transformerExist'] == true)
//                               ? 'Yes'
//                               : 'No',
//                         ),
//                       ] else if (idKey == 'dt_id') ...[
//                         _attributeContainer(
//                             title: 'Distribution Transformer Name',
//                             label: "${attributes['dtLocationName']}"),
//                         _attributeContainer(
//                             title: 'SnD', label: "${attributes['snDName']}"),
//                         _attributeContainer(
//                             title: 'Substation',
//                             label: "${attributes['substationName']}"),
//                         _attributeContainer(
//                             title: 'Feeder Line Name',
//                             label: "${attributes['feederlineName']}"),
//                         _attributeContainer(
//                             title: 'DT Location',
//                             label: "${attributes['dtLocationName']}"),
//                         _attributeContainer(
//                             title: 'Nearest Holding/House No/Shop',
//                             label: "${attributes['nearestHoldingHouseNoShop']}"),
//                         _attributeContainer(
//                             title: 'Installed Condition',
//                             label: "${attributes['installedConditionName']}"),
//                         _attributeContainer(
//                             title: 'Install Place',
//                             label: "${attributes['installedPlaceName']}"),
//                         _attributeContainer(
//                             title: 'Owner of the Transformer',
//                             label: "${attributes['transformerOwnerName']}"),
//                         _attributeContainer(
//                             title: 'Name of Manufacturer',
//                             label: "${attributes['nameofManufacturer']}"),
//                         _attributeContainer(
//                             title: 'Rated Power',
//                             label: ""),
//                         _attributeContainer(
//                             title: 'Impedance',
//                             label: ""),
//                         _attributeContainer(
//                             title: 'No of Phrase',
//                             label: ""),
//                         _attributeContainer(
//                             title: 'Vector Group',
//                             label: ""),
//                         _attributeContainer(
//                             title: 'Rated Frequency',
//                             label: ""),
//                         _attributeContainer(
//                             title: 'Transformer Kva Rating',
//                             label: "${attributes['transformerKvaRating']}"),
//                         _attributeContainer(
//                             title: 'latitude',
//                             label: "${attributes['latitude']}"),
//                         _attributeContainer(
//                             title: 'longitude',
//                             label: "${attributes['longitude']}"),
//                       ] else if (idKey == 'consumer_no') ...[
//                         _attributeContainer(title: 'SND Name', label: "${attributes['snDName']}"),
//                         _attributeContainer(title: 'Feeder Line Name', label: "${attributes['feederlineName']}"),
                        
//                         _attributeContainer(
//                             title: 'Consumer No',
//                             label: "${attributes['consumerNo']}"),
//                         _attributeContainer(title: 'Consumer Type', label: "${attributes['consumerTypeName']}"),
//                         _attributeContainer(
//                             title: 'Customer Name',
//                             label: "${attributes['customerName']}"),
                        
//                         _attributeContainer(
//                             title: 'Customer NID',
//                             label: "${attributes['customerNid']}"),
//                         _attributeContainer(
//                             title: 'Father Name',
//                             label: "${attributes['fatherName'] ?? ''}"),
//                         _attributeContainer(
//                             title: 'Mobile No',
//                             label: "${attributes['mobileNo']}"),
//                         _attributeContainer(
//                             title: 'Customer Address',
//                             label: "${attributes['customerAddress']}"),
//                         _attributeContainer(title: 'Premise Name', label: "${attributes['premiseName']}"),
                        

//                         // _attributeContainer(title: 'Zone Name', label: "${attributes['zoneName']}"),
//                         // _attributeContainer(title: 'Circle Name', label: "${attributes['circleName']}"),
//                         // 
//                         // _attributeContainer(title: 'ESU Name', label: "${attributes['esuName']}"),
//                         // _attributeContainer(title: 'Substation Name', label: "${attributes['substationName']}"),
//                         //

//                         // _attributeContainer(title: 'DT Id', label: "${attributes['dtId']}"),
//                         // _attributeContainer(title: 'Pole Details Id', label: "${attributes['poleDetailsId']}"),
//                         // _attributeContainer(title: 'Service Point Id', label: "${attributes['servicesPointId']}"),
//                         // _attributeContainer(title: 'Service Cable Size', label: "${attributes['serviceCableSize']}"),
//                         // _attributeContainer(title: 'Service Cable Type Id', label: "${attributes['serviceCableTypeId']}"),
//                         // _attributeContainer(
//                         //     title: 'Meter Type',
//                         //     label: "${attributes['meterTypeName']}"),
//                         _attributeContainer(
//                             title: 'Meter Number',
//                             label: "${attributes['meterNumber']}"),
//                         _attributeContainer(
//                             title: 'Meter Model',
//                             label: "${attributes['meterModel']}"),
//                         _attributeContainer(
//                             title: 'Meter Manufacturer',
//                             label: "${attributes['meterManufacturer']}"),

//                         _attributeContainer(
//                             title: 'Tariff',
//                             label: "${attributes['tariff']}"),
                        
//                         _attributeContainer(title: 'Connection Status', label: "${attributes['connectionStatusName']}"),
//                         _attributeContainer(title: 'Business Type', label: "${attributes['businessTypeName']}"),
//                         _attributeContainer(title: 'Connected Pole no.', label: "${attributes['poleNo']}"),
//                         _attributeContainer(title: 'Service Cable Type', label: "${attributes['serviceCableTypeName']}"),
//                         _attributeContainer(title: 'Service Cable Size', label: "${attributes['serviceCableSize']}"),
//                         _attributeContainer(title: 'Phasing Code', label: "${attributes['phasingCodeName']}"),
//                         _attributeContainer(title: 'Sanction Load', label: "${attributes['sanctionedLoad']}"),
//                         _attributeContainer(title: 'Connected Load', label: "${attributes['connectedLoad']}"),

//                         _attributeContainer(title: 'Distance from SP', label: "${attributes['distanceFromSp']}"),
//                         _attributeContainer(title: 'Distance from DT', label: "${attributes['distanceFromDt']}"),
//                         // _attributeContainer(title: 'Building/Apt No', label: "${attributes['buildingAptNo']}"),
//                         // _attributeContainer(title: 'Premise Name', label: "${attributes['premiseName']}"),
//                         // _attributeContainer(title: 'Structure Id', label: "${attributes['structureId']}"),
//                         // _attributeContainer(title: 'Structure Map No', label: "${attributes['structureMapNo']}"),
//                         // _attributeContainer(title: 'Structure Type Id', label: "${attributes['structureTypeId']}"),
//                         // _attributeContainer(title: 'Number of Floor', label: "${attributes['numberOfFloor']}"),
//                         // _attributeContainer(title: 'Distance From SP (m)', label: "${attributes['distanceFromSp']}"),
//                         _attributeContainer(
//                             title: 'Latitude',
//                             label: "${attributes['latitude']}"),
//                         _attributeContainer(
//                             title: 'Longitude',
//                             label: "${attributes['longitude']}"),
//                         _attributeContainer(
//                             title: 'Remarks',
//                             label: "${attributes['remarks'] ?? ''}"),
//                       ] else ...[
//                         // Fallback to default dynamic display
//                         ...attributes.entries
//                             .map((e) => Column(
//                                   children: [
//                                     _attributeContainer(
//                                       label: "${e.value}",
//                                       title: _formatFieldName(e.key),
//                                     ),
//                                     const Divider(height: 0),
//                                   ],
//                                 ))
//                             .toList(),
//                       ],
//                       const SizedBox(height: 20),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: TextButton(
//                           child: const Text(
//                             'Close',
//                             style: TextStyle(
//                               color: Color.fromARGB(255, 3, 89, 100),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //-----JAL-----------
//   String _formatFieldName(String fieldName) {
//     List<String> words = fieldName.split('_');
//     List<String> capitalizedWords = words.map((word) {
//       if (word.isEmpty) return word;
//       return word[0].toUpperCase() + word.substring(1).toLowerCase();
//     }).toList();

//     return capitalizedWords.join(' ');
//   }

//   ({String title, String? idKey}) getFeaturePopupTitle(
//       Map<String, Object?> attributes) {
//     if (attributes.containsKey('consumer_no')) {
//       return (title: 'Consumer Details', idKey: 'consumer_no');
//     } else if (attributes.containsKey('pole_details_id')) {
//       return (title: 'Pole Details', idKey: 'pole_details_id');
//     } else if (attributes.containsKey('feederline_id') &&
//         attributes.containsKey('feeder_name')) {
//       return (title: 'FeederLine Details', idKey: 'feederline_id');
//     } else if (attributes.containsKey('dt_id') &&
//         attributes.containsKey('dt_number')) {
//       return (title: 'DT Details', idKey: 'dt_id');
//     } else if (attributes.containsKey('substation_id')) {
//       return (title: 'Substation Details', idKey: 'substation_id');
//     } else if (attributes.containsKey('esu_id')) {
//       return (title: 'ESU Details', idKey: 'esu_id');
//     } else if (attributes.containsKey('snd_id')) {
//       return (title: 'SND Details', idKey: 'snd_id');
//     } else if (attributes.containsKey('circle_id')) {
//       return (title: 'Circle Details', idKey: 'circle_id');
//     } else if (attributes.containsKey('zone_id')) {
//       return (title: 'Zone Details', idKey: 'zone_id');
//     }

//     return (title: 'Feature Details', idKey: null);
//   }

//   Widget _attributeContainer({
//     required String label,
//     required String title,
//   }) {
//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           height: 25,
//           child: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "$title: ",
//                   style: const TextStyle(
//                     fontSize: 11.5,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     label,
//                     style: const TextStyle(fontSize: 11.5),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const Divider(height: 0), // ← Added here
//       ],
//     );
//   }

//   Future<void> fetchAndShowPopup({
//     required BuildContext context,
//     required String idKey,
//     required Object idValue,
//     required String title,
//   }) async {
//     Map<String, dynamic> data = {};
//     final MapApi _mapApi = MapApi();
//     // print(idKey);
//     try {
//       switch (idKey) {
//         case 'zone_id':
//           data = await _mapApi.fetchZoneById(idValue);
//           break;
//         case 'circle_id':
//           data = await _mapApi.fetchCircleById(idValue);
//           break;
//         case 'snd_id':
//           data = await _mapApi.fetchSndById(idValue);
//           break;
//         case 'esu_id':
//           data = await _mapApi.fetchEsuById(idValue);
//           break;
//         case 'substation_id':
//           data = await _mapApi.fetchSubstationById(idValue);
//           break;
//         case 'feederline_id':
//           data = await _mapApi.fetchFeederlineById(idValue);
//           // print(data);
//           break;
//         case 'pole_details_id':
//           data = await _mapApi.fetchPoleDetailsById(idValue);
//           break;
//         case 'dt_id':
//           data = await _mapApi.fetchDtById(idValue);
//           break;
//         case 'consumer_no':
//           data = await _mapApi.fetchConsumerById(idValue);

//           break;
//         default:
//           throw Exception('Unsupported ID key: $idKey');
//       }

//       if(idKey == 'consumer_no'){
//         showConsumerFeaturePopup(context, data, title, idKey);
//       }else{
//         showFeaturePopup(context, data, title, idKey);
//       }
      
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load data: $e')),
//       );
//     }
//   }
// }
