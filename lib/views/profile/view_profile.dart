// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../../models/Login/login.dart';
import '../../constants/constant.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    User? user = globalUser;
    return AlertDialog(
      shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Image.asset(
              'assets/images/bpdb_logo.png',
              width: 65,
              height: 65,
            ),
            const Text(
              "BPDB User Information",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              // width: MediaQuery.of(context).size.width,
               shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),)),
              color: const Color.fromARGB(255, 206, 242, 248),
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("User Name: ${user?.UserName}"),
                    const Divider(),
                    Text("Zone: ${user?.ZoneId ?? ''}"),
                    const Divider(),
                    Text("Circle: ${user?.CircleId ?? ''}"),
                    const Divider(),
                    Text("Snd: ${user?.SndId ?? ''}"),
                    const Divider(),
                    Text("Esu: ${user?.EsuId ?? ''}"),
                    const Divider(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Card(
                        color: const Color.fromARGB(255, 5, 161, 182),
                        child: 
                          TextButton(
                            child: const Text('Cancel', 
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

