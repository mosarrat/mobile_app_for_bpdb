// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class LoginInputFields extends StatefulWidget {
  final TextEditingController userIdController;
  final TextEditingController passwordController;
  //final TextEditingController phoneNumberController;

  const LoginInputFields({
    super.key,
    required this.userIdController,
    required this.passwordController,
    //required this.phoneNumberController,
  });

  @override
  _LoginInputFieldsState createState() => _LoginInputFieldsState();
}

class _LoginInputFieldsState extends State<LoginInputFields> {
  late bool _isValidPhoneNumber;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _isValidPhoneNumber = true;
    //widget.phoneNumberController.addListener(_validatePhoneNumber);

    // #region start :: need to remove
    widget.userIdController.text = "cegisbd";
    widget.passwordController.text = "Cegis@2022";
    //widget.phoneNumberController.text = "01511495465";
    // #endregion
  }

  @override
  void dispose() {
    //widget.phoneNumberController.removeListener(_validatePhoneNumber);
    super.dispose();
  }

  // void _validatePhoneNumber() {
  //   final String phoneNumber = widget.phoneNumberController.text;

  //   setState(() {
  //     if (phoneNumber.isEmpty ||
  //         !phoneNumber.startsWith("01") ||
  //         !RegExp(r'^[0-9]*$').hasMatch(phoneNumber) ||
  //         phoneNumber.length != 11) {
  //       _isValidPhoneNumber = false;
  //     } else {
  //       _isValidPhoneNumber = true;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildTextField(
          controller: widget.userIdController,
          hintText: "User ID",
          icon: const Icon(
            Icons.person,
            color: Colors.green,
          ),
        ),
        _buildPasswordField(
          controller: widget.passwordController,
          hintText: "Password",
          obscureText: _obscureText,
        ),
        Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _isValidPhoneNumber
                    ? const Color.fromARGB(255, 238, 238, 238)
                    : Colors.red,
              ),
            ),
          ),
          // child: TextField(
          //   controller: widget.phoneNumberController,
          //   maxLength: 11,
          //   decoration: InputDecoration(
          //     border: InputBorder.none,
          //     errorText: _isValidPhoneNumber ? null : "Invalid phone number",
          //     labelText: "Enumerator Phone Number",
          //     labelStyle: TextStyle(
          //       color: widget.phoneNumberController.text.isEmpty
          //           ? Colors.blueGrey
          //           : _isValidPhoneNumber
          //               ? Colors.blueGrey
          //               : Colors.red,
          //     ),
          //     prefixIcon: const Icon(
          //       Icons.phone_android_outlined,
          //       color: Colors.blue,
          //     ),
          //   ),
          // ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    required Icon icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 238, 238, 238),
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: hintText,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 39, 54, 61),
          ),
          prefixIcon: icon,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 238, 238, 238),
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock,
                color: Colors.orange,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: hintText,
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 39, 54, 61),
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.blueGrey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ],
      ),
    );
  }
}
