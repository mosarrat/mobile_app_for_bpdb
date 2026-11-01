// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../dashboard.dart';
import 'login_button.dart';
import 'login_input_fields.dart';

class SigninControl extends StatefulWidget {
  const SigninControl({super.key});

  @override
  _SigninControlState createState() => _SigninControlState();
}

class _SigninControlState extends State<SigninControl> {
  //final DatabaseHelper dbHelper = DatabaseHelper();

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  Map<String, dynamic>? userData;
  String? user;
  int? userLevel;

  Future<void> redirectToHomePage(BuildContext context) async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          LoginInputFields(
            userIdController: userIdController,
            passwordController: passwordController,
            //phoneNumberController: phoneNumberController,
          ),
          const SizedBox(height: 20),
          const SizedBox(
            height: 10,
          ),
          LoginButton(
            userId: userIdController,
            password: passwordController,
            //phoneNumber: phoneNumberController,
            onLoginSuccess: (Map<String, dynamic> data) {
              setState(() {
                // if (data['userID'] != null &&
                //     data['userID'].toString().isNotEmpty) {
                //   user = data['userID'];
                //   userLevel = data['userLevel'];

                //   userId = user!;
                //   userLevelId = userLevel!;

                //   if (kDebugMode) {
                //     print('I am: ${data['userID']}, My User Level: $userLevel');
                //   }
                // } else {
                //   user = '';
                //   userLevel = -1;

                //   if (kDebugMode) {
                //     print('Invalid user Data format');
                //   }
                // }
              });

              //rony need to work here
              redirectToHomePage(context);
            },
          ),
        ],
      ),
    );
  }
}
