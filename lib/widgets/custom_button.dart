import 'package:flutter/material.dart';
import 'package:wellfreshlogin/theme.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? color;
  final VoidCallback? action;

  const ActionButton({
    super.key,
    required this.title,
    this.icon,
    this.color,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
        ),
        shadowColor: boxShadowColor,
        elevation: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon),
          if (icon != null) const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}