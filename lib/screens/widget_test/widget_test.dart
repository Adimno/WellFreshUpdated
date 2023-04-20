import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wellfreshlogin/theme.dart';
import 'package:wellfreshlogin/widgets/widgets.dart';

class WidgetTest extends StatelessWidget {
  const WidgetTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    final TextEditingController text = TextEditingController();

    // Pill data
    var pills = [
      {
        'id': 1,
        'role': 'Dentist',
      },
      {
        'id': 2,
        'role': 'Therapist',
      },
      {
        'id': 3,
        'role': 'Psychiatrist',
      },
      {
        'id': 4,
        'role': 'Dermatologist',
      },
      {
        'id': 5,
        'role': 'Surgeon',
      },
    ];

    // List of actions
    List listActionItem = [
      {
        'icon': IconlyBroken.editSquare,
        'text': 'Edit profile',
        'action': () {
          FloatingSnackBar.show(context, 'Edit profile');
        },
      },
      {
        'icon': IconlyBroken.calendar,
        'text': 'View appointments',
        'action': () {
          FloatingSnackBar.show(context, 'Ye had no appointments, matey');
        },
      },
      {
        'icon': IconlyBroken.buy,
        'text': 'Purchase history',
        'action': () {
          FloatingSnackBar.show(context, 'You\'re broke, dude');
        },
      },
      {
        'icon': IconlyBroken.logout,
        'text': 'Logout',
        'action': () {
          FloatingSnackBar.show(context, 'You are now logged ou- just kidding');
        },
      },
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomTabBar(title: 'Widget Test', backButton: false, color: surfaceColor, scaffoldKey: scaffoldKey),
        drawer: const NavigationDrawerWidget(),
        body: TabBarView(
          children: [
            Widgets(
              scaffoldKey: scaffoldKey,
              pills: pills,
              listActionItem: listActionItem, text: text
            ),
            const Variables(),
            const TextSizes(),
          ],
        ),
      ),
    );
  }
}

class Widgets extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List pills;
  final List listActionItem;
  final TextEditingController text;

  const Widgets({
    super.key,
    required this.scaffoldKey,
    required this.pills,
    required this.listActionItem,
    required this.text
  });

  @override
  State<Widgets> createState() => _WidgetsState();
}

class _WidgetsState extends State<Widgets> {
  bool hidePass = true;
  int selectedPill = 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            WidgetContainer(
              title: 'Application bar',
              widgets: [
                AbsorbPointer(
                  absorbing: true,
                  child: CustomAppBar(
                    title: 'backButton: false',
                    color: cardColor,
                    backButton: false,
                    scaffoldKey: widget.scaffoldKey
                  ),
                ),
                AbsorbPointer(
                  absorbing: true,
                  child: CustomAppBar(
                    title: 'backButton: true',
                    color: cardColor,
                    backButton: true,
                    scaffoldKey: widget.scaffoldKey
                  ),
                ),
                AbsorbPointer(
                  absorbing: true,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: OverlayAppBar(
                      title: 'Overlay app bar',
                      scaffoldKey: widget.scaffoldKey
                    ),
                  ),
                ),
              ]
            ),
            WidgetContainer(
              title: 'Navigation bar',
              widgets: [
                CustomNavBar(title: 'Nav bar with button', icon: IconlyBroken.addUser, action: () {}),
              ]
            ),
            WidgetContainer(
              title: 'Pills',
              widgets: [
                PillCarousel(data: widget.pills, borderRadius: 12),
                PillCarouselPicker(data: widget.pills, borderRadius: 24),
              ]
            ),
            WidgetContainer(
              title: 'List actions',
              widgets: [
                ListActions(actions: widget.listActionItem),
              ]
            ),
            WidgetContainer(
              title: 'Text fields',
              widgets: [
                CustomTextField(
                  title: 'Text form field',
                  hintText: 'Text form field',
                  prefixIcon: const Icon(IconlyBroken.profile),
                  controller: widget.text,
                ),
                CustomTextField(
                  title: 'Text form field (prefix)',
                  hintText: 'Text form field (prefix)',
                  prefixIcon: const Icon(IconlyBroken.message),
                  controller: widget.text,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  title: 'Text form field (suffix)',
                  hintText: 'Text form field (suffix)',
                  suffixIcon: const Icon(IconlyBroken.search),
                  controller: widget.text,
                  keyboardType: TextInputType.text,
                ),
                CustomTextField(
                  title: 'Text form field (obscure + both icons)',
                  hintText: 'Text form field (obscure + both icons)',
                  obscureText: hidePass,
                  prefixIcon: const Icon(IconlyBroken.password),
                  suffixIcon: IconButton(
                    icon: Icon(hidePass ? IconlyBroken.show : IconlyBroken.hide),
                    onPressed: () {
                      setState(() { hidePass = !hidePass; });
                    },
                  ),
                  controller: widget.text,
                  keyboardType: TextInputType.visiblePassword,
                ),
                CustomTextField(
                  title: 'Multiline text form field',
                  hintText: 'Multiline text form field',
                  prefixIcon: const Icon(IconlyBroken.message),
                  lines: 4,
                  controller: widget.text,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            WidgetContainer(
              title: 'Buttons',
              widgets: [
                SizedBox(
                  height: 64,
                  child: ActionButton(
                    icon: IconlyBroken.bookmark,
                    title: 'Action button',
                    backgroundColor: accentColor,
                    action: () {},
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 64,
                  child: ActionButton(
                    icon: IconlyBroken.bookmark,
                    title: 'Colored button',
                    backgroundColor: errorColor,
                    action: () {},
                  ),
                ),
              ]
            ),
            const WidgetContainer(
              title: 'Section title',
              widgets: [
                SectionTitle(title: 'Section title'),
              ]
            ),
            const WidgetContainer(
              title: 'Item indicator',
              widgets: [
                ItemIndicator(
                  icon: IconlyBroken.activity,
                  text: 'No activty found!',
                ),
              ]
            ),
            WidgetContainer(
              title: 'Person card',
              widgets: [
                PersonCard(
                  name: 'Miguel Santos',
                  description: 'Professional Dentist',
                  imageUrl: 'https://pngimg.com/uploads/doctor/doctor_PNG16028.png',
                  rating: 5.0,
                  action: () => FloatingSnackBar.show(context, 'I am handsome'),
                ),
                const SizedBox(height: 12),
                PersonCard(
                  name: 'John Doe',
                  description: 'Denterist',
                  imageUrl: 'https://pngimg.com/uploads/doctor/doctor_PNG15959.png',
                  rating: 4.5,
                  action: () => FloatingSnackBar.show(context, 'I am generic'),
                ),
                const SizedBox(height: 12),
                const PersonCard(
                  name: 'Jayjay Naval',
                  description: 'May 30, 2023',
                  subtext: '3:30pm',
                  imageUrl: 'https://pngimg.com/uploads/doctor/doctor_PNG16041.png',
                ),
              ]
            ),
            const WidgetContainer(
              title: 'Product carousel and card',
              widgets: [
                AbsorbPointer(
                  absorbing: true,
                  child: ProductCarousel(category: 'Dental Floss')
                ),
              ]
            ),
            const WidgetContainer(
              title: 'Cart item',
              widgets: [
                AbsorbPointer(
                  absorbing: true,
                  child: CartProductCard(
                    id: 1,
                    name: 'Test item',
                    category: 'Test category',
                    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Wikipedia-logo-v2.svg/150px-Wikipedia-logo-v2.svg.png',
                    price: 500,
                    quantity: 1,
                  ),
                ),
              ]
            ),
            WidgetContainer(
              title: 'Snackbar',
              widgets: [
                SizedBox(
                  height: 64,
                  child: ActionButton(
                    icon: IconlyBroken.bookmark,
                    title: 'Show floating snackbar',
                    backgroundColor: accentColor,
                    action: () {
                      FloatingSnackBar.show(context, 'This is a floating snackbar');
                    },
                  ),
                ),
              ]
            ),
            WidgetContainer(
              title: 'Drawer',
              widgets: [
                DrawerItem(
                  icon: IconlyBroken.profile,
                  title: 'Profile',
                  action: () {}
                ),
                DrawerItem(
                  icon: IconlyBroken.home,
                  title: 'Home',
                  action: () {}
                ),
                DrawerItem(
                  icon: IconlyBroken.calendar,
                  title: 'Appointment',
                  action: () {}
                ),
                DrawerItem(
                  icon: IconlyBroken.bag,
                  title: 'Dental Store',
                  action: () {}
                ),
                DrawerItem(
                  icon: IconlyBroken.infoSquare,
                  title: 'About the app',
                  action: () {}
                ),
                DrawerItem(
                  icon: IconlyBroken.call,
                  title: 'Contact us',
                  action: () {}
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}

class Variables extends StatelessWidget {
  const Variables({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            WidgetContainer(
              title: 'Background colors',
              widgets: [
                Container(
                  color: surfaceColor,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Surface color (#F8FAFF)',
                    style: TextStyle(
                      color: primaryTextColor,
                    ),
                  ),
                ),
                Container(
                  color: accentColor,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Primary color (#51A8FF)',
                    style: TextStyle(
                      color: invertTextColor,
                    ),
                  ),
                ),
                Container(
                  color: tertiaryColor,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Tertiary color (#14376A, 45%)',
                    style: TextStyle(
                      color: invertTextColor,
                    ),
                  ),
                ),
                Container(
                  color: errorColor,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Error color (#FF4545)',
                    style: TextStyle(
                      color: invertTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const WidgetContainer(
              title: 'Text colors',
              widgets: [
                Text(
                  'Primary color (#080C2F)',
                  style: TextStyle(
                    color: primaryTextColor,
                  ),
                ),
                Text(
                  'Secondary text color (#5E6177)',
                  style: TextStyle(
                    color: secondaryTextColor,
                  ),
                ),
                Text(
                  'Tertiary text color (#080C2F, 65%)',
                  style: TextStyle(
                    color: tertiaryTextColor,
                  ),
                ),
                Text(
                  'Invert text color (#FFFFFF)',
                  style: TextStyle(
                    color: invertTextColor,
                    backgroundColor: primaryTextColor,
                  ),
                ),
                Text(
                  'Title text color (#080C2F)',
                  style: TextStyle(
                    color: titleTextColor,
                  ),
                ),
                Text(
                  'Accent text color (#51A8FF)',
                  style: TextStyle(
                    color: accentTextColor,
                  ),
                ),
                Text(
                  'Error text color (#FF4545)',
                  style: TextStyle(
                    color: errorTextColor,
                  ),
                ),
              ],
            ),
            WidgetContainer(
              title: 'Other variables',
              widgets: [
                Container(
                  color: cardColor,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Card color (#FFFFFF)',
                    style: TextStyle(
                      color: primaryTextColor,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: cardColor,
                    boxShadow: [containerShadow],
                  ),
                  child: const Text(
                    'Box shadow (#B2B2B2, 20%)',
                    style: TextStyle(
                      color: primaryTextColor,
                    ),
                  ),
                ),
                Container(
                  color: borderColor,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Border color (#B2B2B2)',
                    style: TextStyle(
                      color: invertTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextSizes extends StatelessWidget {
  const TextSizes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: WidgetContainer(
          title: 'Text sizes',
          widgets: [
            Text(
              'Display Large (32)',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              'Display Medium (24)',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              'Display Small (20)',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              'Title Large (18)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Title Medium (16)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Title Small (14)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              'Body Large (14)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Body Medium (12)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Body Small (10)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetContainer extends StatelessWidget {
  final String title;
  final dynamic widgets;

  const WidgetContainer({
    super.key,
    required this.title,
    required this.widgets,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: tertiaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ),
      ],
    );
  }
}