import 'package:flutter/material.dart';
import 'package:wellfreshlogin/theme.dart';

class CustomNavBar extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback action;

  const CustomNavBar({
    Key? key,
    required this.title,
    required this.icon,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 110,
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
        child: ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
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
              icon,
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}