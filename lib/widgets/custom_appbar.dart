import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfreshlogin/theme.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool backButton;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.backButton,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      clipBehavior: Clip.none,
      child: AppBar(
        backgroundColor: surfaceColor,
        foregroundColor: tertiaryTextColor,
        automaticallyImplyLeading: backButton,
        toolbarHeight: 80,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: tertiaryTextColor,
          ),
        ),
        centerTitle: true,
        leading: (backButton == false) ?
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [containerShadow],
          ),
          child: IconButton(
            icon: const Icon(Icons.menu),
            constraints: const BoxConstraints(),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
        ) : Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [containerShadow],
          ),
          child: IconButton(
            icon: const Icon(IconlyBroken.arrowLeft2),
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}