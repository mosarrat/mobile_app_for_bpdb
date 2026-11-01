// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../../models/Login/login.dart';
import '../../constants/constant.dart';
//import 'package:geolocator/geolocator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
  User? user = globalUser;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 240, 243),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'BPDB User Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 5, 161, 182),
          // actions: <Widget>[
          //   Container(
          //     margin: const EdgeInsets.only(right: 25),
          //     padding: const EdgeInsets.all(4),
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.white),
          //       borderRadius: BorderRadius.circular(7),
          //     ),
          //     child: GestureDetector(
          //       onTap: () {},
          //         child: const Row(
          //         children: [
          //           Icon(
          //             Icons.edit,
          //             size: 20.0,
          //             color: Colors.white,
          //           ),
          //           Text("Edit", style: TextStyle(color: Colors.white),),
          //         ],
          //       ),
          //     )
          //   ),
          // ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: const Color.fromARGB(255, 202, 240, 245),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:15, left: 15, bottom: 15, right: 30),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                          child:  Image.asset(
                          'assets/images/profile_avater.png',
                          width: 90,
                          height: 90,
                          fit:BoxFit.cover,
                        ),
                        ), 
                      ),

                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0, bottom: 2),
                            child: Text("User Name: ${user?.UserName}", 
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 5, 161, 182),
                              ),
                            ),
                          ), 

                         Text("${user?.GroupName}", style: TextStyle(color: Color.fromARGB(255, 5, 161, 182),),),
                          
                        ],
                      ), 
                    ],
                  ),
                  
                ),
              ),
              const SizedBox(height: 6,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text('Personal Information',
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            // color: const Color.fromARGB(255, 40, 138, 196),
                            color: Color.fromARGB(255, 3, 89, 100),
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text("Address:"),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            // color: const Color.fromARGB(255, 40, 138, 196),
                            color: Color.fromARGB(255, 3, 89, 100),
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text("Email: ${user?.Email}"),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            // color: const Color.fromARGB(255, 40, 138, 196),
                            color: Color.fromARGB(255, 3, 89, 100),
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text("Office Phone:"),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                            // color: const Color.fromARGB(255, 40, 138, 196),
                            color: Color.fromARGB(255, 3, 89, 100),
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text("Personal Contact: ${user?.PhoneNumber}"),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.perm_identity,
                            // color: const Color.fromARGB(255, 40, 138, 196),
                            color: Color.fromARGB(255, 3, 89, 100),
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text("Id:"),
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                  
                ),
              ),
              const SizedBox(height: 6,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text('Administrative Information',
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      const Divider(),
                      Text("Zone: ${user?.ZoneName ?? ''}"),
                      const Divider(),
                      Text("Circle: ${user?.CircleName ?? ''}"),
                      const Divider(),
                      Text("Snd: ${user?.SnDName ?? ''}"),
                      const Divider(),
                      Text("Esu: ${user?.EsuName ?? ''}"),
                      const Divider(),
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
