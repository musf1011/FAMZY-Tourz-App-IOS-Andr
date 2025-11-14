import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final String? initialValue;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool isVisible;
  final VoidCallback? toggleVisibility;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final int maxLines;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;

  const CustTextFormField({
    super.key,
    required this.label,
    required this.hint,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.isVisible = false,
    this.toggleVisibility,
    this.onChanged,
    this.maxLines = 1,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.onSaved,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: controller == null ? initialValue : null,
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      obscureText: obscureText && isVisible,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 226, 222, 209)),
        suffixIcon: toggleVisibility != null
            ? IconButton(
                onPressed: toggleVisibility,
                icon: Icon(
                  isVisible ? Icons.visibility_off : Icons.visibility,
                  color: isVisible
                      ? const Color.fromARGB(255, 100, 100, 100)
                      : const Color.fromARGB(255, 0, 80, 30),
                ),
              )
            : null,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 182, 146, 29)),
        ),
      ),
    );
  }
}
