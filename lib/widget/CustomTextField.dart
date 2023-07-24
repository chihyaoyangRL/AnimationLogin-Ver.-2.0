import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final VoidCallback editing;

  CustomTextField({@required this.hint, @required this.obscure, @required this.icon, @required this.keyboardType, this.controller, this.editing});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration( /// Underline border
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.white)),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscure,
        style: const TextStyle(color: Colors.white),
        keyboardType: widget.keyboardType,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          icon: Icon(widget.icon, color: Colors.white),
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
          contentPadding: const EdgeInsets.only(top: 25.0, right: 30.0, bottom: 20.0, left: 5.0),
        ),
        onEditingComplete: widget.editing,
      ),
    );
  }
}