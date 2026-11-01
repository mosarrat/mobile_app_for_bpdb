import 'package:flutter/material.dart';
import 'package:bpdb_gis_app/widgets/widgets/fieldset_legend.dart';
import 'package:intl/intl.dart';
import '../../api/api.dart';
import '../../api/feederline_api.dart';
import '../../models/feederlines_lookup/feederline.dart';
import '../../models/regions/feederline_conductor.dart';
import '../../models/regions/feederlinetype.dart';
import '../../models/regions/zone.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/service_point.dart';

Future<void> showEditForm(BuildContext context, CallApiService apiService,
    FeederLines item, VoidCallback onSuccess) async {
  showDialog(
    context: context,
    builder: (context) => EditDialog(
      apiService: apiService,
      item: item,
      onSuccess: onSuccess,
    ),
  );
}

class EditDialog extends StatefulWidget {
  final CallApiService apiService;
  final FeederLines item;
  final VoidCallback onSuccess;

  const EditDialog({
    Key? key,
    required this.apiService,
    required this.item,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late Future<List<Zone>> zones;
  late Future<List<Circles>> circles;
  late Future<List<SndInfo>> snds;
  late Future<List<EsuInfo>> esu;
  late Future<List<Substation>> substations;
  late Future<List<ServicePoint>> servicePoints;
  late Future<List<FeederLineType>> feederlinetype;
  late Future<List<FeederConductorType>> feederlineConductor;
  late bool isGridSelected;
  late bool isBluckConsumerSelected;

  int? selectedZoneId;
  int? selectedCircleId;
  int? selectedSnDId;
  int? selectedEsuId;
  int? selectedSubstationId;
  int? selectedFeederLineId;
  int? selectedFeederlineTypeId;
  int? selectedFeederLineConductorId;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    zones = CallApi().fetchZoneInfo();
    circles = CallApi().fetchCircleInfo(widget.item.zoneId);
    snds = CallApi().fetchSnDInfo(widget.item.circleId);
    esu = CallApiService().fetchEsuInfo(widget.item.sndId);
    substations = CallApi().fetchSubstationInfo(widget.item.sndId);
    feederlinetype = CallApiService().fetchFeederLineTypeInfo();
    feederlineConductor = CallApiService().fetchFeederlineConductor();

    // Initialize selected values
    selectedZoneId = widget.item.zoneId;
    selectedCircleId = widget.item.circleId;
    selectedSnDId = widget.item.sndId;
    selectedEsuId = widget.item.esuId;
    selectedSubstationId = widget.item.sourceSubstationId;
    selectedFeederLineId = widget.item.feederLineId;
    selectedFeederlineTypeId = widget.item.feederLineTypeId;
    selectedFeederLineConductorId = widget.item.feederConductorTypeId;
    isGridSelected = widget.item.isGrid;
    isBluckConsumerSelected = widget.item.isBulkCustomer;
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void onFeederlineType(int? value) {
    setLoading(true);
    selectedFeederlineTypeId = value;
  }

  void onFeederlineConductor(int? value) {
    setLoading(true);
    selectedFeederLineConductorId = value;
  }

  void onZoneChanged(int? value) {
    setLoading(true);
    selectedZoneId = value;
    selectedCircleId = null;
    selectedSnDId = null;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    circles = CallApi().fetchCircleInfo(value!).whenComplete(() {
      setLoading(false);
    });
    snds = Future.value([]);
    substations = Future.value([]);
  }

  void onCircleChanged(int? value) {
    setLoading(true);
    selectedCircleId = value;
    selectedSnDId = null;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    snds = CallApi().fetchSnDInfo(value!).whenComplete(() {
      setLoading(false);
    });

    substations = Future.value([]);
  }

  void onSnDChanged(int? value) {
    setLoading(true);
    selectedSnDId = value;
    selectedEsuId = null;
    selectedSubstationId = null;
    selectedFeederLineId = null;
    substations = CallApi().fetchSubstationInfo(value!).whenComplete(() {
      setLoading(false);
    });
    esu = CallApiService().fetchEsuInfo(value!).whenComplete(() {
      setLoading(false);
    });
  }

  void onEsuChanged(int? value) {
    setLoading(true);
    selectedEsuId = value;
    selectedSubstationId = null;
    selectedFeederLineId = null;
  }

  void onSubstationChanged(int? value) {
    setLoading(true);
    selectedSubstationId = value;
    selectedFeederLineId = null;
  }

  void itemSwitchGrid(bool value) {
    setState(() {
      isGridSelected = value;
    });
  }

  void itemSwitchBlukConsumer(bool value) {
    setState(() {
      isBluckConsumerSelected = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController _feederlineId =
        TextEditingController(text: widget.item.feederLineId.toString());
    TextEditingController _feederLineCode =
        TextEditingController(text: widget.item.feederLineCode);
    TextEditingController _feederlineName =
        TextEditingController(text: widget.item.feederlineName);
    
    TextEditingController _feederLineUId =
        TextEditingController(text: widget.item.feederLineUId);
    TextEditingController _feederLocation =
        TextEditingController(text: widget.item.feederLocation);
    TextEditingController _feederLength =
        TextEditingController(text: widget.item.feederLength.toString());
    // var isGridSelected = widget.item.isGrid;
    // var isBluckConsumerSelected = widget.item.isBulkCustomer;
    TextEditingController _feederMeterNumber =
        TextEditingController(text: widget.item.feederMeterNumber);
    TextEditingController _maximumDemand =
        TextEditingController(text: widget.item.maximumDemand);
    TextEditingController _peakDemand =
        TextEditingController(text: widget.item.peakDemand);
    TextEditingController _sanctionedLoad =
        TextEditingController(text: widget.item.sanctionedLoad);
    TextEditingController _connectionTypeController = TextEditingController();
    TextEditingController _nominalVoltage =
        TextEditingController(text: widget.item.nominalVoltage.toString());
    TextEditingController _meterCurrentRating =
        TextEditingController(text: widget.item.meterCurrentRating);
    TextEditingController _bulkCustomerName =
        TextEditingController(text: widget.item.bulkCustomerName);
    TextEditingController _meterVoltageRating =
        TextEditingController(text: widget.item.meterVoltageRating);
    TextEditingController _remarks =
        TextEditingController(text: widget.item.remarks);
    var dt = DateTime.now(); // Date-Time
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
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "FeederLine Update Information",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
      
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shadowColor: Colors.transparent,
              // width: MediaQuery.of(context).size.width,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              )),
              //color: const Color.fromARGB(255, 206, 242, 248),
              color: Colors.white,
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Theme(
                      data: ThemeData().copyWith(
                        dividerColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: Colors.white),
                      ),
                      child: ExpansionTile(
                        collapsedBackgroundColor:
                            const Color.fromARGB(255, 223, 240, 243),
                        title: const Text('Administrative Location'),
                        childrenPadding: const EdgeInsets.all(5),
                        textColor: const Color.fromARGB(255, 5, 161, 182),
                        children: [
                          FieldsetLegend(
                            legendText: 'Administrative Location',
                            children: [
                              FutureBuilder<List<Zone>>(
                                future: zones,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    return DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        labelText: 'Zone',
                                        labelStyle:
                                            TextStyle(color: Colors.blue),
                                      ),
                                      value: selectedZoneId,
                                      hint: const Text('Select a Zone'),
                                      items: snapshot.data!.map((zone) {
                                        return DropdownMenuItem<int>(
                                          value: zone.zoneId,
                                          child: Text(
                                              zone.zoneName),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        selectedZoneId = value;
                                        onZoneChanged(value);
                                      },
                                    );
                                  } else {
                                    return const Text('No zones available');
                                  }
                                },
                              ),
                              /////-----Circle
                              FutureBuilder<List<Circles>>(
                                future: circles,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    return DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        labelText: 'Circle',
                                        labelStyle:
                                            TextStyle(color: Colors.blue),
                                      ),
                                      value: selectedCircleId,
                                      hint: const Text('Select a Circle'),
                                      items: snapshot.data!.map((circle) {
                                        return DropdownMenuItem<int>(
                                          value: circle.circleId,
                                          child: Text(
                                              '${circle.circleName}'),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        selectedCircleId = value;
                                        onCircleChanged(value);
                                      },
                                    );
                                  } else {
                                    return const Text('No circles available');
                                  }
                                },
                              ),
                              /////-----Snd
                              FutureBuilder<List<SndInfo>>(
                                future: snds,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    return DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        labelText: 'Snd',
                                        labelStyle:
                                            TextStyle(color: Colors.blue),
                                      ),
                                      value: selectedSnDId,
                                      hint: const Text('Select a Snd'),
                                      items: snapshot.data!.map((snd) {
                                        return DropdownMenuItem<int>(
                                          value: snd.sndId,
                                          child: Text(
                                              '${snd.snDName}'),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        selectedSnDId = value;
                                        onSnDChanged(value);
                                      },
                                    );
                                  } else {
                                    return const Text('No SnD value available');
                                  }
                                },
                              ),
                              /////-----Esu
                              FutureBuilder<List<EsuInfo>>(
                                future: esu,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    return DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        labelText: 'Esu',
                                        labelStyle:
                                            TextStyle(color: Colors.blue),
                                      ),
                                      value: selectedEsuId,
                                      hint: const Text('Select a Esu'),
                                      items: snapshot.data!.map((esu) {
                                        return DropdownMenuItem<int>(
                                          value: esu.esuId,
                                          child: Text(
                                              esu.esuName),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        selectedEsuId = value;
                                      },
                                    );
                                  } else {
                                    return const Text('No Esu value available');
                                  }
                                },
                              ),
                              /////-----substation
                              FutureBuilder<List<Substation>>(
                                future: substations,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    return DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        labelText: 'Substations',
                                        labelStyle:
                                            TextStyle(color: Colors.blue),
                                      ),
                                      value: selectedSubstationId,
                                      hint: const Text('Select a substations'),
                                      items: snapshot.data!.map((substation) {
                                        return DropdownMenuItem<int>(
                                          value: substation.substationId,
                                          child: Text(
                                              substation.substationName),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        selectedSubstationId = value;
                                      },
                                    );
                                  } else {
                                    return const Text(
                                        'No Substation value available');
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Theme(
                      data: ThemeData().copyWith(
                        dividerColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: Colors.white),
                      ),
                      child: ExpansionTile(
                        collapsedBackgroundColor:
                            const Color.fromARGB(255, 241, 245, 245),
                        title: const Text('Feeder Line Information'),
                        childrenPadding: const EdgeInsets.all(5),
                        textColor: const Color.fromARGB(255, 5, 161, 182),
                        children: [
                          FieldsetLegend(
                            legendText: 'Feeder Line Information',
                            children: [
                              // _buildTextField(_feederlineId, 'Feeder Line Id'),
                              _buildTextField(
                                  _feederLineCode, 'Feeder Line Code'),
                              _buildTextField(
                                  _feederlineName, 'Feeder Line Name'),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'IsGrid',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Switch(
                                          value: isGridSelected,
                                          onChanged: itemSwitchGrid,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // _buildTextField(
                              //     _feederLineToGrid, 'Feeder Line To Grid'),
                              // _buildTextField(
                              //     _feederLineUId, 'Feeder Line UId'),
                              FutureBuilder<List<FeederLineType>>(
                                future: feederlinetype,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox.shrink();
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    return DropdownButtonFormField<int>(
                                      decoration: InputDecoration(
                                        labelText: 'Feeder Line Type',
                                        labelStyle: const TextStyle(
                                          color: Color.fromARGB(255, 121, 120, 120),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                      ),
                                      value: selectedFeederlineTypeId,
                                      hint: const Text(
                                          'Select a Feeder Line Type'),
                                      items:
                                          snapshot.data!.map((feederlinetype) {
                                        return DropdownMenuItem<int>(
                                          value:
                                              feederlinetype.feederLineTypeId,
                                          child: Text(
                                              feederlinetype.feederLineTypeName),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedFeederlineTypeId = value;
                                        });
                                      },
                                    );
                                  } else {
                                    return const Text(
                                        'No Feeder Line Type available');
                                  }
                                },
                              ),
                              const SizedBox(height: 16.0),
                              FutureBuilder<List<FeederConductorType>>(
                                future: feederlineConductor,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox.shrink();
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    return DropdownButtonFormField<int>(
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        labelText: 'Feeder Line Conductor Type',
                                        labelStyle: const TextStyle(
                                          color: Color.fromARGB(255, 121, 120, 120),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                      ),
                                      value: selectedFeederLineConductorId,
                                      hint: const Text(
                                          'Select a FeederLine Conductor Type'),
                                      items: snapshot.data!
                                          .map((feederlineConductor) {
                                        return DropdownMenuItem<int>(
                                          value: feederlineConductor
                                              .feederConductorTypeId,
                                          child: Text(
                                            feederlineConductor.feederConductorTypeName,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedFeederLineConductorId = value;
                                        });
                                      },
                                    );
                                  } else {
                                    return const Text(
                                        'No Feeder Line Type available');
                                  }
                                },
                              ),
                              const SizedBox(height: 16.0),
                              _buildTextField(
                                  _feederLocation, 'Feeder Line Location'),
                              _buildTextField(
                                  _feederLength, 'Feeder Line Length'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Theme(
                      data: ThemeData().copyWith(
                        dividerColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: Colors.white),
                      ),
                      child: ExpansionTile(
                        collapsedBackgroundColor:
                            const Color.fromARGB(255, 223, 240, 243),
                        title: const Text('Meter Information'),
                        childrenPadding: const EdgeInsets.all(5),
                        textColor: const Color.fromARGB(255, 5, 161, 182),
                        children: [
                          FieldsetLegend(
                            legendText: 'Meter Information',
                            children: [
                              _buildTextField(
                                  _feederMeterNumber, 'Feeder Meter No'),
                              _buildTextField(
                                  _nominalVoltage, 'Nominal Voltage'),
                              _buildTextField(
                                  _meterCurrentRating, 'Meter Current Rating'),
                              _buildTextField(
                                  _meterVoltageRating, 'Meter Voltage Rating'),
                              _buildTextField(_maximumDemand, 'Maximum Demand'),
                              _buildTextField(_peakDemand, 'Peak Demand'),
                              _buildTextField(
                                  _sanctionedLoad, 'Sanctioned Load'),
                              _buildTextField(_connectionTypeController,
                                  'Connection Type Controller'),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Is BulkCustomer',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Switch(
                                          value: isBluckConsumerSelected,
                                          onChanged: itemSwitchBlukConsumer,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              _buildTextField(
                                  _bulkCustomerName, 'Bulk Customer Name'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Theme(
                      data: ThemeData().copyWith(
                        dividerColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: Colors.white),
                      ),
                      child: ExpansionTile(
                        collapsedBackgroundColor:
                            const Color.fromARGB(255, 241, 245, 245),
                        title: const Text('Remarks'),
                        childrenPadding: const EdgeInsets.all(5),
                        textColor: const Color.fromARGB(255, 5, 161, 182),
                        children: [
                          FieldsetLegend(
                            legendText: 'Remarks',
                            children: [
                              _buildTextField(_remarks, 'remarks'),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Add your save functionality here
                                try{
                                    T checkNotNull<T>(T? value, String fieldName) {
                                      if (value == null || value == 0) {
                                        throw 'Invalid value for $fieldName. PLease Check Again ';
                                      }
                                      return value;
                                    }
                                    await CallApiService().updateFeederLine(FeederLines(
                                    feederLineId: checkNotNull(
                                      int.parse(_feederlineId.text),
                                      'Feeder Line Id'),
                                    feederlineName: checkNotNull(
                                      _feederlineName.text, 'Feeder Line Name'),
                                    zoneId: checkNotNull(selectedZoneId, 'Zone'),
                                    circleId:
                                        checkNotNull(selectedCircleId, 'Circle'),
                                    sndId: checkNotNull(selectedSnDId, 'SnD'),
                                    esuId: selectedEsuId,
                                    sourceSubstationId: checkNotNull(
                                        selectedSubstationId, 'Substation'),
                                    destinationSubstationId: 2,
                                    feederLineCode: checkNotNull(
                                        _feederLineCode.text, 'Feeder Line Code'),
                                    isGrid: isGridSelected,
                                    gridSubstationInputId: 0,
                                    feederLineUId: checkNotNull(
                                      _feederLineUId.text, 'Feeder Line UId'),
                                    feederLineTypeId: checkNotNull(
                                        selectedFeederlineTypeId,
                                        'Feeder Line Type'),
                                    feederConductorTypeId: checkNotNull(
                                        selectedFeederLineConductorId,
                                        'Feeder Line Conductor Type'),
                                    nominalVoltage: checkNotNull(
                                        double.tryParse(_nominalVoltage.text),
                                        'Nominal Voltage'),
                                    feederLocation: _feederLocation.text,
                                    feederMeterNumber: _feederMeterNumber.text,
                                    meterCurrentRating:
                                        int.tryParse(_meterCurrentRating.text),
                                    meterVoltageRating:
                                        double.tryParse(_meterVoltageRating.text),
                                    maximumDemand: double.tryParse(_maximumDemand.text),
                                    peakDemand: double.tryParse(_peakDemand.text),
                                    maximumLoad: double.tryParse(_maximumDemand.text),
                                    sanctionedLoad: double.tryParse(_sanctionedLoad.text),
                                    isBulkCustomer: isBluckConsumerSelected,
                                    bulkCustomerName: _bulkCustomerName.text,
                                    isPgcbGrid: false,
                                    startingDate:
                                        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dt),
                                    activationStatusId: 2,
                                    verificationStateId: 2,
                                    isPermittedToVerify: false,
                                    isPermittedToApprove: false,
                                    isEditAvailable: false,
                                    feederLength: double.tryParse(_feederLength.text) ?? 0,
                                    remarks: _remarks.text,
                                  ));
                                  Navigator.of(context).pop();
                                  widget.onSuccess();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Feeder Line Information Updated Successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }catch (error){
                                    //print("Error Updating Feeder Line Data: $error");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error Updating Feeder Line Data: $error'),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 20),
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              ),
                              child: const Text('Save Update',
                                  style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Card(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        margin: const EdgeInsets.only(right: 10, bottom: 10,),
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
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField(TextEditingController controller, String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    ),
  );
}
