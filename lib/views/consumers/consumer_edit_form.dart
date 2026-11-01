import 'package:flutter/material.dart';
import 'package:bpdb_gis_app/models/consumer_lookup/consumers.dart';
import 'package:intl/intl.dart';

import '../../api/api.dart';
import '../../api/consumer_api.dart';
import '../../api/region_api.dart';
import '../../models/consumer_form_lookup/bussiness_type.dart';
import '../../models/consumer_form_lookup/connection_status.dart';
import '../../models/consumer_form_lookup/connection_type.dart';
import '../../models/consumer_form_lookup/consumer_type.dart';
import '../../models/consumer_form_lookup/location.dart';
import '../../models/consumer_form_lookup/meter_type.dart';
import '../../models/consumer_form_lookup/opreating_voltage.dart';
import '../../models/consumer_form_lookup/phasing_code.dart';
import '../../models/consumer_form_lookup/service_cabletype.dart';
import '../../models/consumer_form_lookup/structure_type.dart';
import '../../models/consumer_form_lookup/tarif_subcatagory.dart';
import '../../models/consumer_form_lookup/tariff_category.dart';
import '../../models/consumer_lookup/consumer_edit.dart';
import '../../models/regions/distribution_transformer.dart';
import '../../models/regions/circle.dart';
import '../../models/regions/esu_info.dart';
import '../../models/regions/feeder_line.dart';
import '../../models/regions/pole.dart';
import '../../models/regions/service_point.dart';
import '../../models/regions/snd_info.dart';
import '../../models/regions/substation.dart';
import '../../models/regions/zone.dart';
import '../../widgets/noti/notifications.dart';
import '../../widgets/widgets/fieldset_legend.dart';
import 'view_consumers.dart';

class ShowConsumerEdit extends StatefulWidget {
  final int consumerId;
  final String consumerNo;
  const ShowConsumerEdit({
    super.key,
    required this.consumerId,
    required this.consumerNo,
  });

  @override
  State<ShowConsumerEdit> createState() => _ShowConsumerEditState();
}

class _ShowConsumerEditState extends State<ShowConsumerEdit> {
  late Future<ConsumerUpdate> _futureConsumerData;

  late Future<List<FeederLine>> feederLines;
  late Future<List<ServicePoint>> servicePoints;
  late Future<List<MeterType>> fetchMeterType;
  late Future<List<PhasingCode>> fetchPhasingCode;
  late Future<List<Locations>> fetchLocations;
  late Future<List<DistributionTransformer>> dts;

  int? selectedSubstationId;
  int? selectedFeederLineId;
  int? selectedServicePointId;
  int? selectedMeterTypeId;
  int? selectedPhasingCodeId;
  int? selectedLocationId;
  int? selectedDTId;

  var dt = DateTime.now(); // Date-Time
  bool isLoading = false;

  late TextEditingController consumerNameController = TextEditingController();
  late TextEditingController consumerNameBanglaController =
      TextEditingController();
  late TextEditingController fatherNameController = TextEditingController();
  late TextEditingController nidController = TextEditingController();
  late TextEditingController mobileNoController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController consumerAddressController =
      TextEditingController();
  late TextEditingController meterModelController = TextEditingController();
  late TextEditingController meterNumberController = TextEditingController();
  late TextEditingController meterManufacturerController =
      TextEditingController();
  late TextEditingController omfKwhController = TextEditingController();
  late TextEditingController latitude = TextEditingController();
  late TextEditingController longitude = TextEditingController();

  Future<ConsumerUpdate> _fetchConsumerData() async {
    return CallConsumerApi().fetchConsumerForUpdate(widget.consumerId);
  }

  @override
  void initState() {
    super.initState();

    // Fetch the consumer data
    _futureConsumerData = _fetchConsumerData();
    feederLines = Future.value([]);
    servicePoints = Future.value([]);
    dts = Future.value([]);
    fetchMeterType = Future.value([]);
    fetchPhasingCode = Future.value([]);
    fetchLocations = Future.value([]);
    // Initialize dependent data
    _futureConsumerData.then((consumer) {
      setState(() {
        feederLines = CallApi().fetchFeederLineInfo(consumer.substationId);
        servicePoints =
            CallConsumerApi().fetchServicePointsByFeeder(consumer.feederLineId);
        dts = CallConsumerApi()
            .fetchDistributionTransformersByFeeder(consumer.feederLineId);
        fetchMeterType = CallConsumerApi().fetchMeterType();
        fetchPhasingCode = CallConsumerApi().fetchPhasingCode();
        fetchLocations = CallConsumerApi().fetchLocations();

        selectedSubstationId = consumer.substationId;
        selectedFeederLineId = consumer.feederLineId;
        selectedServicePointId = consumer.servicesPointId;
        selectedDTId = consumer.dtId;
        selectedMeterTypeId = consumer.meterTypeId;
        selectedPhasingCodeId = consumer.phasingCodeTypeId;
        selectedLocationId = consumer.locationId;
        consumerNameController.text = consumer.customerName;
        consumerNameBanglaController.text = consumer.customerNameBng ?? '';
        fatherNameController.text = consumer.fatherName ?? '';
        nidController.text = consumer.customerNid ?? '';
        mobileNoController.text = consumer.mobileNo ?? '';
        emailController.text = consumer.email ?? '';
        meterModelController.text = consumer.meterModel ?? '';
        meterManufacturerController.text = consumer.meterManufacturer ?? '';
        omfKwhController.text = consumer.omfKwh?.toString() ?? '';
        consumerAddressController.text = consumer.customerAddress ?? '';
        meterNumberController.text = consumer.meterNumber ?? '';
        latitude.text = consumer.latitude.toString();
        longitude.text = consumer.longitude.toString();
      });
    });
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void onFeederLineChanged(int? value) {
    setLoading(true);
    selectedFeederLineId = value;
    selectedServicePointId = null;
    selectedDTId = null;

    // poles = CallApi().fetchPoleInfo(value!).whenComplete(() {
    //   setLoading(false);
    // });
  }

  @override
  Widget build(BuildContext context) {
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
                "Consumer Update Information",
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
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
                      ////////////////////////////////////////Theme_1//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 223, 240, 243),
                          title: const Text('Administrative Information'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText: 'Administrative Information',
                              children: [
                                FutureBuilder<List<FeederLine>>(
                                  future: feederLines,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Feeder Line',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: null,
                                        hint: const Text(
                                            'No feeder line available!'),
                                        items: [],
                                        onChanged: null,
                                      );
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Feeder Line',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: selectedFeederLineId,
                                        hint:
                                            const Text('Select a Feeder Line'),
                                        items: snapshot.data!.map((feeder) {
                                          return DropdownMenuItem<int>(
                                            value: feeder.feederLineId,
                                            child: Text(
                                              feeder.operatingSndName != null &&
                                                      feeder.operatingSndName!.isNotEmpty
                                                  ? '${feeder.feederlineName ?? ''} (${feeder.operatingSndName})'
                                                  : feeder.feederlineName ?? '',
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedFeederLineId = value;
                                            onFeederLineChanged(value);
                                          });
                                        },
                                      );
                                    } else {
                                      return const Text(
                                          'No feeder line available!');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                FutureBuilder<List<ServicePoint>>(
                                  future: servicePoints,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Service Point',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: null,
                                        hint: const Text(
                                            'No service point available!'),
                                        items: [],
                                        onChanged: null,
                                      );
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Service Point',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: selectedServicePointId,
                                        hint: const Text(
                                            'Select a Service Point'),
                                        items: snapshot.data!.map((sp) {
                                          return DropdownMenuItem<int>(
                                            value: sp.servicesPointId,
                                            child: Text(sp.servicePointCode),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedServicePointId = value;
                                          });
                                        },
                                      );
                                    } else {
                                      return const Text(
                                          'No service point available!');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                FutureBuilder<List<DistributionTransformer>>(
                                  future: dts,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }

                                    if (snapshot.hasError) {
                                      showMessage(
                                          'Error: ${snapshot.error}', 'error');
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Distribution Transformer',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: null,
                                        hint: const Text(
                                            'No distribution transformer available!'),
                                        items: [],
                                        onChanged: null,
                                      );
                                    } else if (snapshot.hasData) {
                                      return DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          labelText: 'Distribution Transformer',
                                          labelStyle: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        value: selectedDTId,
                                        hint: const Text(
                                            'Select a Distribution Transformer'),
                                        items: snapshot.data!.map((dt) {
                                          return DropdownMenuItem<int>(
                                            value: dt.id,
                                            child: Text(
                                                dt.distributionTransformerCode ?? ''),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedDTId = value;
                                          });
                                        },
                                      );
                                    } else {
                                      return const Text(
                                          'No distribution transformer available!');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////////////Theme_1//////////////////////////////////
                      
                      ///////////////////////////////////////////Theme_5//////////////////////////////////
                      
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 241, 245, 245),
                          title: const Text('GPS Information'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText: 'GPS Information',
                              children: [
                                _buildTextField(
                                      context, latitude, 'Latitude'),
                                _buildTextField(
                                    context, longitude, 'Longitude'),                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      ////////////////////////////////////////Theme_5//////////////////////////////////
                      
                      ///////////////////////////////////////////Theme_2//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 223, 240, 243),
                          title: const Text('Consumer Information'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText: 'Consumer Information',
                              children: [
                                //_buildTextField(context, consumerNameController, 'Name'),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: TextFormField(
                                    controller: consumerNameController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: TextFormField(
                                    controller: consumerNameBanglaController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Name (বাংলায়)',
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'NotoSansBengali',
                                      fontSize: 18,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Name (বাংলায়)';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                _buildTextField(context, fatherNameController,
                                    'Father Name'),
                                _buildTextField(context, nidController, 'NID'),
                                _buildTextField(
                                    context, mobileNoController, 'Mobile No'),
                                _buildTextField(
                                    context, emailController, 'Email Address'),
                                _buildTextField(context,
                                    consumerAddressController, 'Address'),
                                FutureBuilder<List<Locations>>(
                                  future: fetchLocations,
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
                                          labelText: 'Location',
                                          
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedLocationId,
                                        hint: const Text('Select a Location'),
                                        items: snapshot.data!.map((location) {
                                          return DropdownMenuItem<int>(
                                            value: location.locationId,
                                            child: Text(location.locationName),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedLocationId = value;
                                          });
                                        },
                                      );
                                    } else {
                                      return const Text(
                                          'No Location available');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////////////Theme_2//////////////////////////////////

                      ///////////////////////////////////////////Theme_4//////////////////////////////////
                      Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 241, 245, 245),
                          title: const Text('Meter Information'),
                          childrenPadding: const EdgeInsets.all(5),
                          textColor: const Color.fromARGB(255, 5, 161, 182),
                          children: [
                            FieldsetLegend(
                              legendText: 'Meter Information',
                              children: [
                                const SizedBox(height: 16.0),
                                FutureBuilder<List<MeterType>>(
                                  future: fetchMeterType,
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
                                          labelText: 'Meter Type',
                                          
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedMeterTypeId,
                                        hint: const Text('Select a Meter Type'),
                                        items: snapshot.data!.map((metertype) {
                                          return DropdownMenuItem<int>(
                                            value: metertype.meterTypeId,
                                            child:
                                                Text(metertype.meterTypeName),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedMeterTypeId = value;
                                          });
                                        },
                                      );
                                    } else {
                                      return const Text(
                                          'No Meter Type available');
                                    }
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                _buildTextField(context, meterModelController,
                                    'Meter Model'),
                                _buildTextField(context, meterNumberController,
                                    'Meter Number'),
                                _buildTextField(
                                    context,
                                    meterManufacturerController,
                                    'Meter Manufacturer'),
                                FutureBuilder<List<PhasingCode>>(
                                  future: fetchPhasingCode,
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
                                          labelText: 'Phasing Code Type',
                                          
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                        ),
                                        value: selectedPhasingCodeId,
                                        hint:
                                            const Text('Select a Phasing Code'),
                                        items:
                                            snapshot.data!.map((phasingcode) {
                                          return DropdownMenuItem<int>(
                                            value: phasingcode.phasingCodeId,
                                            child: Text(
                                                phasingcode.phasingCodeName),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedPhasingCodeId = value;
                                          });
                                        },
                                      );
                                    } else {
                                      return const Text(
                                          'No Phasing Code available');
                                    }
                                  },
                                ),

                                Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            ConsumerUpdate updatedConsumers = ConsumerUpdate(
                                              consumerId: widget.consumerId,
                                              consumerNo: widget.consumerNo,
                                              substationId:
                                                  selectedSubstationId!,
                                              feederLineId:
                                                  selectedFeederLineId!,
                                              servicesPointId:
                                                  selectedServicePointId!,
                                              dtId: selectedDTId,
                                              customerName:
                                                  consumerNameController.text,
                                              customerNameBng:
                                                  consumerNameBanglaController
                                                      .text,
                                              fatherName:
                                                  fatherNameController.text,
                                              customerNid: nidController.text,
                                              mobileNo:
                                                  mobileNoController.text,
                                              email: emailController.text,
                                              customerAddress:
                                                  consumerAddressController
                                                      .text,
                                              meterTypeId:
                                                  selectedMeterTypeId,
                                              meterModel:
                                                  meterModelController.text,
                                              meterNumber:
                                                  meterNumberController.text,
                                              meterManufacturer:
                                                  meterManufacturerController
                                                      .text,
                                              phasingCodeTypeId:
                                                  selectedPhasingCodeId,
                                              locationId: selectedLocationId,
                                              omfKwh: double.parse(
                                                  omfKwhController.text),
                                              latitude: double.parse(latitude.text),
                                              longitude: double.parse(longitude.text),
                                            );

                                            
                                            await CallConsumerApi().updateConsumer(updatedConsumers);

                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Consumer Updated Successfully'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (error) {
                                            // Handle Error
                                            //print(error);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Failed to update data: $error'),
                                                backgroundColor: Colors.red,
                                                duration:
                                                    const Duration(seconds: 20),
                                              ),
                                            );
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blue),
                                        ),
                                        child: const Text('Save Update',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ////////////////////////////////////////Theme_4//////////////////////////////////
                      
                      
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
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField(
    BuildContext context, TextEditingController controller, String label) {
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
