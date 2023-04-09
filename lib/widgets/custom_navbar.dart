import 'package:flutter/material.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';

class CustomNavBar extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? action;

  const CustomNavBar({
    Key? key,
    required this.title,
    this.icon,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 8, vertical: 16),
      child: SizedBox(
        height: 64,
        child: ActionButton(
          icon: icon,
          title: title,
          color: accentColor,
          action: action,
        ),
      ),
    );
  }
}
