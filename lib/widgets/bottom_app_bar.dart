import 'package:flutter/material.dart';
import 'package:eatery/screens/Home/home_screen.dart';
import 'package:eatery/screens/Discover/search_screen.dart';
import 'package:eatery/screens/Profile/profile_screen.dart';

class BottomAppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 60,  // Fixed height to ensure sufficient space
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildTabItem(context, icon: Icons.home, label: 'Home', route: '/home'),
            buildTabItem(context, icon: Icons.search, label: 'Discover', route: '/search'),
            buildTabItem(context, icon: Icons.person, label: 'Profile', route: '/profile'),
          ],
        ),
      ),
    );
  }

  Widget buildTabItem(BuildContext context, {required IconData icon, required String label, required String route}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),  // Slightly increased icon size
          SizedBox(height: 2),  // Adjust the space between the icon and the text
          Text(label, style: TextStyle(fontSize: 12)),  // Font size slightly increased
        ],
      ),
    );
  }
}
