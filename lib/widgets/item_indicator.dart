import 'package:flutter/material.dart';
import 'package:wellfreshlogin/theme.dart';

class ItemIndicator extends StatelessWidget {
  final IconData icon;
  final String text;

  const ItemIndicator({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36.0,
            color: tertiaryTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: tertiaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}