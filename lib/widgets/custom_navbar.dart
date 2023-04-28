import 'package:flutter/material.dart';
import 'package:wellfresh/theme.dart';
import 'package:wellfresh/widgets/widgets.dart';

class CustomNavBar extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? action;
  final bool loadingIndicator;

  const CustomNavBar({
    Key? key,
    required this.title,
    this.icon,
    this.action,
    this.loadingIndicator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 8, vertical: 16),
      child: SizedBox(
        height: 64,
        child: !loadingIndicator ? ActionButton(
          icon: icon,
          title: title,
          backgroundColor: accentColor,
          action: action,
        ) : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
