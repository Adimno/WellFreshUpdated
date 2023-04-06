import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget{
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
      margin: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
      clipBehavior: Clip.none,
      child: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 250, 255),
        foregroundColor: const Color.fromRGBO(8, 12, 47, .75),
        automaticallyImplyLeading: backButton,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: const Color.fromRGBO(8, 12, 47, .75),
          ),
        ),
        centerTitle: true,
        leading: (backButton == false) ?
        Container(
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(178, 178, 178, .2),
                blurRadius: 30,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.menu),
            constraints: const BoxConstraints(),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
        ) : Container(
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(178, 178, 178, .2),
                blurRadius: 30,
                offset: Offset(0, 5),
              ),
            ],
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