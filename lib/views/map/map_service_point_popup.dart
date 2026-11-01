import 'package:flutter/material.dart';

class ShowServicePointDetail extends StatelessWidget {
  const ShowServicePointDetail({
    Key? key,
    required this.service_point_id,
    required this.service_point_code,
    required this.service_cable_size,
    required this.service_cable_type,
    required this.zone_name,
    required this.circle_name,
    required this.snd_name,
    required this.substation_name,
    required this.feeder_name,
  }) : super(key: key);

  final int service_point_id;
  final String service_point_code;
  final int service_cable_size;
  final String service_cable_type;
  final String zone_name;
  final String circle_name;
  final String snd_name;
  final String substation_name;
  final String feeder_name;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: const Color.fromARGB(255, 3, 89, 100),
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          children: [
            Text(
              "Service Point Information",
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
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Service Point Id.', value: service_point_id.toString(), isAlternate: true),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Service Point Code', value: service_point_code, isAlternate: false),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Service Cable Size',
                        value: service_cable_size.toString(),
                        isAlternate: true),
                    const Divider(height: 0),

                    detailContainer(
                        label: 'Service Cable Type', value: service_cable_type, isAlternate: true),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Zone Name', value: zone_name, isAlternate: false),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Circle Nane',
                        value: circle_name,
                        isAlternate: true),
                    const Divider(height: 0),

                    detailContainer(
                        label: 'SnD Name', value: snd_name, isAlternate: true),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Substation Name', value: substation_name, isAlternate: false),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Feeder Name',
                        value: feeder_name,
                        isAlternate: true),
                    const Divider(height: 0),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text(
                          'Close',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 3, 89, 100),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget detailContainer({
    required String label,
    required String value,
    bool isAlternate = false,
  }) {
    return Container(
      width: double.infinity,
      height: 40,
      color: isAlternate
          ? const Color.fromARGB(255, 223, 240, 243)
          : const Color.fromARGB(255, 241, 245, 245),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                ': $value',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
