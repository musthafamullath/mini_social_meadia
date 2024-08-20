import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:mechine_task_cumin360/sources/constants/colors.dart';
import 'package:mechine_task_cumin360/views/feed_tab/feed_tab_view.dart';
import 'package:mechine_task_cumin360/views/profile-tab/profile_tab_views.dart';


class MainViews extends StatefulWidget {
  const MainViews({super.key});

  @override
  MainViewsState createState() => MainViewsState();
}

class MainViewsState extends State<MainViews> {
  late CircularBottomNavigationController _navigationController;
  int _currentIndex = 0; 

  static const List<Widget> _widgetOptions = <Widget>[
    FeedTabView(),
    ProfileViews(),
  ];

  final List<TabItem> tabItems = List.of([
    TabItem(
      Mdi.homeVariant,
      "Home",
      yellow,
    ),
    TabItem(
      Mdi.account,
      "Profile",
      yellow,
    ),
  ]);

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: CircularBottomNavigation(
        normalIconColor: black,
        tabItems.map((tabItem) {
          return TabItem(tabItem.icon, tabItem.title, tabItem.circleColor,
              labelStyle: tabItem.labelStyle);
        }).toList(),
        controller: _navigationController,
        circleSize: 50,
        iconsSize: 22,
        barBackgroundColor: grey,
        selectedCallback: (int? selectedPos) {
          setState(() {
            _currentIndex = selectedPos ?? 0;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }
}
