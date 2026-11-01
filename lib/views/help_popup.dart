import 'package:flutter/material.dart';

class HelpPopup extends StatelessWidget {
  const HelpPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      backgroundColor: const Color.fromARGB(255, 3, 89, 100),
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          children: [
            Text(
              "Help and Supprt Contacts",
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
                    detailContainer(
                        label:
                            'Address: F-14/E, Agargaon Administrative Area, Sher-E-Bangla Nagar, Dhaka-1207, Bangladesh',
                        icon: Icons.location_on),
                    const Divider(height: 0),
                    detailContainer(
                        label:
                            'Phone: +88 (02) 41025810; +88 (02) 41025811; \n+88 (02) 41025812; +88 (02) 41025813;',
                        icon: Icons.phone),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Email: cegis@cegisbd.com; ed@cegisbd.com',
                        icon: Icons.email),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Web: www.cegisbd.com',
                        icon: Icons.web),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Business Hours: Sunday - Thursday 9am to 5pm',
                        icon: Icons.access_time),
                    const Divider(height: 0),
                    detailContainer(
                        label: 'Non-business days: Friday and Saturday',
                        icon: Icons.timer_off_outlined),
                    const Divider(height: 0),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      //child: Card(
                      //color: const Color.fromARGB(255, 5, 161, 182),
                      child: TextButton(
                        child: const Text(
                          'Close',
                          style: TextStyle(
                              // color: Colors.white,
                              color: Color.fromARGB(255, 3, 89, 100),
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      //),
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
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Container(
              height: 22,
              width: 22,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 3, 89, 100),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$label',
                style: const TextStyle(fontSize: 11.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
