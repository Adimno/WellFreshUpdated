import 'package:flutter/material.dart';
import 'package:wellfreshlogin/theme.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback action;

  const CustomListTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: primaryTextColor,
        ),
      ),
      onTap: action,
    );
  }
}