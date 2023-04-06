import 'package:flutter/material.dart';
import 'package:wellfreshlogin/theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.title,
    required this.hint,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  final String? title;
  final String? hint;
  final dynamic icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [containerShadow],
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: secondaryTextColor,
              ),
              hintText: hint,
              fillColor: Colors.transparent,
              filled: true,
              border: InputBorder.none,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              prefixIcon: Icon(icon),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}