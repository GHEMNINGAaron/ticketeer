import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final bool isEmail;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomInput({
    Key? key,
    required this.hint,
    this.isPassword = false,
    this.isEmail = false,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType:
            widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
        obscureText: widget.isPassword ? obscure : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF1C2333),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}