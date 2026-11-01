import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/constant.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'widgets/login/signin.dart';

// ---- For Firebase Remote Config ---- //
Future<String?> getApiUrl() async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('apiurl')
        .doc('SBFjZ89xdaWGT4BnodbQ')
        .get();

    if (doc.exists) {
      return doc.data()?['url'] as String?;
    }
  } catch (e) {
    print('Error fetching API URL: $e');
  }
  return null;
}


// Future<void> loadConfig() async {
//   AppConfig.apiUrl = await getApiUrl();
// }
Future<void> loadConfig() async {
    final url = await getApiUrl();
    myAPILink = url;
  }
// ---- For Firebase Remote Config ---- //
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ---- For Firebase Remote Config ---- //
  await loadConfig();
  // ---- For Firebase Remote Config ---- //
  
 runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Exo2',
      ),
      home: const Signin(),
    ),
  );
}

class Signin extends StatelessWidget {
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double height = MediaQuery.of(context).size.height;
    double topheight;
    if (height > 800) {
      topheight = height * 0.05;
    } else if (height < 400) {
      topheight = height * 0.001;
    } else {
      topheight = height * 0.005;
    }


    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 3, 89, 100),

        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: topheight,
                ),
                const Header(),
                Flexible(
                  child: Container(
                    height: height - (height * 0.05),
                    padding: const EdgeInsets.only(bottom: 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    // child: const SigninControl(),
                    child: const SigninControler(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double textsize;
    if (height < 1300 && height > 900) {
      // print(height);
      // print("1");
      textsize = width * 0.05;
    } else if (height < 900 && height > 600) {
      // print(height);
      // print("2");
      textsize = width * 0.05;
    } else if (height < 600 && height > 400) {
      // print(height);
      // print("3");
      textsize = width * 0.03;
    } else if (height < 400 && height > 200) {
      // print(height);
      // print("4");
      textsize = width * 0.03;
    } else {
      // print(height);
      // print("5");
      textsize = width * 0.5;
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/icons/appicon.png',
              height: height * 0.20,
              width: width * 0.30,
            ),
          ),
          SizedBox(height: height * 0.02),
          Center(
            child: Text(
              "BPDB GIS APP",
              style: TextStyle(
                color: Colors.white,
                fontSize: textsize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
        ],
      ),
    );
  }
}
