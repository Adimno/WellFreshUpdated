import 'package:flutter/material.dart';
import 'package:wellfresh/theme.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final bool dense;
  final bool selected;
  final double minVerticalPadding;
  final Widget? trailingIcon;
  final VoidCallback? action;

  const CustomListTile({
    Key? key,
    required this.icon,
    required this.text,
    this.color = secondaryTextColor,
    this.dense = false,
    this.selected = false,
    this.minVerticalPadding = 0,
    this.trailingIcon,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(20),
      child: ListTile(
        minVerticalPadding: minVerticalPadding,
        leading: Icon(
          icon,
          color: selected ? accentColor : tertiaryTextColor,
        ),
        trailing: trailingIcon,
        dense: dense,
        contentPadding: dense ? const EdgeInsets.symmetric(horizontal: 16) : null,
        visualDensity: dense ? const VisualDensity(horizontal: 0, vertical: -1) : null,
        title: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: selected ? accentColor : primaryTextColor,
          ),
        ),
        onTap: action,
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback action;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 20,
      leading: Icon(
        icon,
        color: primaryTextColor,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: primaryTextColor,
        ),
      ),
      onTap: action,
    );
  }
}

class ListActions extends StatelessWidget {
  final List actions;

  const ListActions({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [containerShadow],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          return CustomListTile(
            icon: actions[index]['icon'],
            text: actions[index]['text'],
            action: actions[index]['action'],
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}