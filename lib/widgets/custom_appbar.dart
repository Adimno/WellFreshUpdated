import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfreshlogin/theme.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Color color;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.backButton,
    required this.color,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      clipBehavior: Clip.none,
      child: AppBar(
        backgroundColor: color,
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
            borderRadius: BorderRadius.circular(15),
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
            borderRadius: BorderRadius.circular(15),
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
  Size get preferredSize => const Size.fromHeight(80);
}

class OverlayAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const OverlayAppBar({
    Key? key,
    required this.title,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentColor,
      clipBehavior: Clip.none,
      child: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: const Icon(Icons.menu),
                constraints: const BoxConstraints(),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: const Icon(IconlyBroken.notification),
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

// For widget test screen only
class CustomTabBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Color color;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomTabBar({
    Key? key,
    required this.title,
    required this.backButton,
    required this.color,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      clipBehavior: Clip.none,
      child: AppBar(
        backgroundColor: color,
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
            borderRadius: BorderRadius.circular(15),
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
            borderRadius: BorderRadius.circular(15),
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
        bottom: const TabBar(
          labelColor: accentTextColor,
          unselectedLabelColor: primaryTextColor,
          indicatorColor: accentColor,
          tabs: [
            Tab(
              text: 'Widgets',
            ),
            Tab(
              text: 'Variables',
            ),
            Tab(
              text: 'Text',
            ),
          ],
        ),
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(130);
}