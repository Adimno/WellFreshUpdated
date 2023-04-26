import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellfreshlogin/screens/screens.dart';
import 'package:wellfreshlogin/services/firebase_services.dart';
import 'package:wellfreshlogin/theme.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Color color;
  final bool fadeTitle;
  final IconData? endIcon;
  final VoidCallback? endAction;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.backButton,
    required this.color,
    this.fadeTitle = false,
    this.endIcon,
    this.endAction,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      foregroundColor: tertiaryTextColor,
      automaticallyImplyLeading: backButton,
      toolbarHeight: 85,
      title: !fadeTitle ? Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: primaryTextColor,
        ),
      ) : AnimatedOpacity(
        opacity: fadeTitle ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: primaryTextColor,
          ),
        ),
      ),
      centerTitle: true,
      leadingWidth: 70,
      leading: (backButton == false) ?
      Container(
        margin: const EdgeInsets.fromLTRB(15, 15, 0, 15),
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
        margin: const EdgeInsets.fromLTRB(15, 15, 0, 15),
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
      actions: endIcon != null ? [
        Container(
          width: 56,
          margin: const EdgeInsets.fromLTRB(0, 15, 15, 15),
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [containerShadow],
          ),
          child: IconButton(
            icon: Icon(endIcon, color: secondaryTextColor),
            constraints: const BoxConstraints(),
            onPressed: endAction,
          ),
        ),
      ] : null,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(85);
}

class OverlayAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool fadeTitle;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const OverlayAppBar({
    Key? key,
    required this.title,
    this.backgroundColor = accentColor,
    this.foregroundColor = Colors.white,
    this.fadeTitle = false,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: backgroundColor,
      clipBehavior: Clip.none,
      duration: const Duration(milliseconds: 250),
      child: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: backgroundColor == accentColor ? Brightness.light : Brightness.dark,
        ),
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
            AnimatedOpacity(
              opacity: fadeTitle ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: primaryTextColor,
                ),
              ),
            ),
            FittedBox(
              child: Stack(
                alignment: const Alignment(1.75, -0.9),
                children: [
                  StreamBuilder(
                    stream: FirestoreServices.getUnreadNotifications(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Container();
                      }
                      else {
                        return Container(
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(minHeight: 24, minWidth: 24),
                          decoration: BoxDecoration(
                            boxShadow: const [containerShadow],
                            borderRadius: BorderRadius.circular(16),
                            color: errorColor,
                          ),
                          child: Center(
                            child: Text(
                              snapshot.data!.docs.length.toString(),
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: invertTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                    }
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
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ));
                      },
                    ),
                  ),
                ],
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