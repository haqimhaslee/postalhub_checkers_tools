import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:postalhub_checkers_tools/pages/check_in_parcel/checkers_parcel.dart';
import 'package:postalhub_checkers_tools/pages/parcel_inventory/parcel_inventory.dart';
import 'package:postalhub_checkers_tools/pages/profile_settings/profile_settings.dart';

class NavigatorServices extends StatefulWidget {
  const NavigatorServices({super.key});
  @override
  State<NavigatorServices> createState() => _NavigatorServicesState();
}

class _NavigatorServicesState extends State<NavigatorServices> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var _selectedIndex = 0;
  final List<Widget> _windgetOption = <Widget>[
    const ParcelInventory(),
    const CheckersParcel(),
    const ProfileSettings(),
  ];
  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          //height: 70,
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            destinations: const [
              /// Home
              NavigationDestination(
                label: "Inventory",
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2_rounded),
              ),
              NavigationDestination(
                label: "Checker Tools",
                icon: Icon(Icons.barcode_reader),
                selectedIcon: Icon(Icons.barcode_reader),
              ),

              NavigationDestination(
                label: "Profile Settings",
                icon: Icon(Icons.manage_accounts_outlined),
                selectedIcon: Icon(Icons.manage_accounts_rounded),
              ),

              /// Profile
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 1,
          scrolledUnderElevation: 1,
          title: const Row(children: [
            Text('Postal Hub Checker Tools'),
          ]),
        ),
        body: Expanded(
          child: PageTransitionSwitcher(
            transitionBuilder: (child, animation, secondaryAnimation) =>
                SharedAxisTransition(
              transitionType: SharedAxisTransitionType.vertical,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
            child: _windgetOption.elementAt(_selectedIndex),
          ),
        ));
  }
}
