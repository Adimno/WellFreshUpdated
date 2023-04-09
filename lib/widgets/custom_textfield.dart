import 'package:flutter/material.dart';
import 'package:wellfreshlogin/theme.dart';

class CustomTextField extends StatelessWidget {
  final String? title;
  final String? hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final dynamic keyboardType;

  const CustomTextField({
    Key? key,
    this.title,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          padding: prefixIcon == null ? const EdgeInsets.fromLTRB(24, 0, 5, 0) : const EdgeInsets.fromLTRB(5, 0, 5, 0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [containerShadow],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: secondaryTextColor,
              ),
              hintText: hintText,
              fillColor: Colors.transparent,
              filled: true,
              border: InputBorder.none,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
            validator: validator,
            keyboardType: keyboardType,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}