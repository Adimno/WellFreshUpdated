import 'package:flutter/material.dart';
import 'package:wellfresh/theme.dart';

class CustomTextField extends StatelessWidget {
  final String? title;
  final String? hintText;
  final bool obscureText;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color color;
  final int lines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final dynamic keyboardType;

  const CustomTextField({
    Key? key,
    this.title,
    this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.color = cardColor,
    this.lines = 1,
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
          decoration: const BoxDecoration(
            boxShadow: [containerShadow],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            enabled: enabled,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: secondaryTextColor,
              ),
              hintText: hintText,
              fillColor: color,
              filled: true,
              border: UnderlineInputBorder(
                borderRadius:BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              contentPadding: prefixIcon == null ? const EdgeInsets.fromLTRB(0, 16, 0, 16) : const EdgeInsets.all(16),
              prefixIcon: prefixIcon != null ? Padding(padding: const EdgeInsets.only(left: 5), child: prefixIcon) : null,
              suffixIcon: suffixIcon != null ? Padding(padding: const EdgeInsets.only(right: 5), child: suffixIcon) : null,
            ),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: primaryTextColor,
            ),
            minLines: lines,
            maxLines: lines,
            validator: validator,
            keyboardType: keyboardType,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}