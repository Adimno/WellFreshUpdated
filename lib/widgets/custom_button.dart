import 'package:flutter/material.dart';
import 'package:wellfresh/theme.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double fontSize;
  final VoidCallback? action;

  const ActionButton({
    super.key,
    required this.title,
    this.icon,
    this.backgroundColor = accentColor,
    this.foregroundColor = invertTextColor,
    this.fontSize = 16,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
        ),
        shadowColor: boxShadowColor,
        elevation: backgroundColor == Colors.transparent ? 0 : 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: foregroundColor),
          if (icon != null) const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}