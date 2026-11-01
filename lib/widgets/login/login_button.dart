// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../noti/notifications.dart';

class LoginButton extends StatefulWidget {
  final TextEditingController userId;
  final TextEditingController password;
  //final TextEditingController phoneNumber;
  final Function(Map<String, dynamic>) onLoginSuccess;

  const LoginButton({
    super.key,
    required this.userId,
    required this.password,
    //required this.phoneNumber,
    required this.onLoginSuccess,
  });

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool isLoading = false;

  Future<void> loginUser(BuildContext context) async {
    if (isLoading) return;

    //final DatabaseHelper dbHelper = DatabaseHelper();
    final userId = widget.userId.text.toString();
    final password = widget.password.text.toString();
    //final phoneNumber = widget.phoneNumber.text.toString();

    if (userId.isEmpty) {
      showNotification(
        context,
        'Required',
        'User ID is required!',
        ContentType.failure,
      );

      return;
    }

    if (password.isEmpty) {
      showNotification(
        context,
        'Required',
        'Password is required!',
        ContentType.failure,
      );

      return;
    }

    // if (phoneNumber.isEmpty) {
    //   showNotification(
    //     context,
    //     'Required',
    //     'Please enter your phone number!',
    //     ContentType.failure,
    //   );

    //   return;
    // }

    setState(() {
      isLoading = true;
    });

    // final apiUrl =
    //     '$myAPILink/api/List/CheckUserInfo?userid=$userId&pass=$password';
    // try {
    //   final response = await http.get(Uri.parse(apiUrl));

    //   if (response.statusCode == 200) {
    String jsonString = '''
  {
    "dataID": 99,
    "userID": "user99",
    "userPass": "rhd@123",
    "isActive": true,
    "userLevel": 1
  }
  ''';
    final Map<String, dynamic> userData = json.decode(jsonString);

    //     //delete previously all logged user records
    //     dbHelper.deleteAllUserRecords();
    //     dbHelper.insertUser(
    //       userData['userID'],
    //       userData['userLevel'].toString().toInt(),
    //       phoneNumber,
    //     );

    showNotification(
      context,
      'Success',
      'Signed in successfully!',
      ContentType.success,
    );

    widget.onLoginSuccess(userData);
    //   } else {
    //     showNotification(
    //       context,
    //       'An Error Occured',
    //       'Login failed, please try again! Error: ${response.statusCode}',
    //       ContentType.failure,
    //     );

    //     await dbHelper.storeErrorLog(
    //         'Login failed, please try again! Error: ${response.statusCode}');
    //   }
    // } catch (error) {
    //   if (kDebugMode) {
    //     print('Error: $error');
    //   }

    //   showNotification(
    //     context,
    //     'An Error Occured',
    //     'Error: $error',
    //     ContentType.failure,
    //   );

    //   await dbHelper.storeErrorLog(error.toString());
    // } finally {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: Colors.cyan[500],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () async {
          //HapticFeedback.vibrate();
          //_playLocalAudio();
          //await _audioPlayer.play(AssetSource('assets/wav/mixkit-hand-tribal-drum-562.mp3'));
          //await _audioPlayer.play(UrlSource('https://assets.mixkit.co/active_storage/sfx/562/562.wav'));

          loginUser(context);
        },
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
