// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../api/login_api.dart';
// import '../../dashboard.dart';
// import '../../models/Login/login.dart';
// import 'login_button.dart';
// import 'login_input_fields.dart';
// import '../../constants/constant.dart';

// class SigninControler extends StatefulWidget {
//   const SigninControler({super.key});

//   @override
//   State<SigninControler> createState() => _SigninControlerState();
// }

// final TextEditingController Username = TextEditingController();
// final TextEditingController Password = TextEditingController();

// class _SigninControlerState extends State<SigninControler> {
//   late bool _isValidPhoneNumber;
//   bool _obscureText = true;

//   @override
//   void initState() {
//     super.initState();
//     _isValidPhoneNumber = true;
//   }

//   @override
//   void dispose() {
//     // Username.dispose();
//     // Password.dispose();
//     super.dispose();

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(30),
//       child: Column(
//         children: <Widget>[
//           _buildTextField(
//             controller: Username,
//             hintText: "User Name",
//             icon: const Icon(
//               Icons.person,
//               color: Colors.green,
//             ),
//           ),
//           _buildPasswordField(
//             controller: Password,
//             hintText: "Password",
//             obscureText: _obscureText,
//           ),
//           Container(
//             padding: const EdgeInsets.all(0),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: _isValidPhoneNumber
//                       ? const Color.fromARGB(255, 238, 238, 238)
//                       : Colors.red,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           const SizedBox(height: 20),
//           Align(
//             alignment: Alignment.center,
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     final loginResponse = await CallLoginApi().loginApi(Login(
//                       Username: Username.text,
//                       Password: Password.text,
//                     ));

//                     if (loginResponse != null) {
//                       globalUser = loginResponse.user;
//                       var now = DateTime.now().toUtc().add(const Duration(hours: 6));
//                       var f = DateFormat('E, d MMM yyyy HH:mm:ss');
//                       LoginTime = f.format(now) + " BST";
//                       // Navigate to the Dashboard
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const Dashboard(),
//                         ),
//                       );

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Login Successfully'),
//                           backgroundColor: Colors.green,
//                         ),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Login failed: Invalid response'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   } catch (error) {
//                     //print("Failed to log in! Error: $error");
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('$error'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   }
//                 },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                     Color.fromARGB(255, 5, 192, 192),
//                   ),
//                 ),
//                 child: const Text(
//                   'Login',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     bool obscureText = false,
//     required Icon icon,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(0),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Color.fromARGB(255, 238, 238, 238),
//           ),
//         ),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           labelText: hintText,
//           labelStyle: const TextStyle(
//             color: Color.fromARGB(255, 39, 54, 61),
//           ),
//           prefixIcon: icon,
//         ),
//       ),
//     );
//   }

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String hintText,
//     bool obscureText = false,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Color.fromARGB(255, 238, 238, 238),
//           ),
//         ),
//       ),
//       child: Stack(
//         alignment: Alignment.centerRight,
//         children: [
//           Row(
//             children: [
//               const Icon(
//                 Icons.lock,
//                 color: Colors.orange,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: TextField(
//                   controller: controller,
//                   obscureText: obscureText,
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     labelText: hintText,
//                     labelStyle: const TextStyle(
//                       color: Color.fromARGB(255, 39, 54, 61),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           IconButton(
//             icon: Icon(
//               obscureText ? Icons.visibility_off : Icons.visibility,
//               color: Colors.blueGrey,
//             ),
//             onPressed: () {
//               setState(() {
//                 _obscureText = !_obscureText;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

