import 'package:flutter/material.dart';
import 'package:eatery/screens/Profile/YourMenus/menulist_widget.dart';
import 'package:eatery/theme.dart'; // Ensure this path is correct

class MenuPlaylist extends StatelessWidget {
  final Map<String, dynamic> menulist;

  MenuPlaylist({required this.menulist});

  @override
  Widget build(BuildContext context) {
    final menulistName = menulist['name'] as String;
    final menulistDescription = menulist['description'] as String;
    final mealCount = menulist['meals'].length as int;
    final backgroundColor = menuItemColors[menulistName.length % menuItemColors.length];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenulistDetailPage(menulist: menulist),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: AssetImage('assets/images/default.png'), // Placeholder for customizable image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menulistName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    menulistDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$mealCount items saved',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
