/*import 'package:flutter/material.dart';


class Input extends StatefulWidget {
  const Input({super.key});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextFormField(
      
              style: TextStyle(
                fontSize: 10
              ),
              decoration: InputDecoration(
                label: Text("Email"),
                hintText:("veuillez saisir votre mail"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) { 
                  return "veuillez saisir votre mail ";
      
                }
                return null;
              }
              
            ),
    );
  }
}*/ 
import 'package:flutter/material.dart';



class Input extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final bool isEmail;

  const Input({
    super.key,
    required this.hint,
    this.isPassword = false,
    this.isEmail = false,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextFormField(
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
