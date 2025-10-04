import 'package:flutter/material.dart';

class UserInput extends StatefulWidget {
  const UserInput({super.key, required this.hint, this.obscureText = false, this.controller, this.onChanged});
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: const Color(0xFFE8F5F1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}
