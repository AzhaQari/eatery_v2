import 'package:flutter/material.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';
import 'package:eatery/widgets/vertical_card.dart';
import 'package:eatery/widgets/menu_playlist.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> boxTitles = ['High Protein', 'Chicken', 'Keto'];
    final List<Color> boxColors = [Colors.green, Colors.blue, Colors.orange];
    final List<Color> menuColors = [
      Colors.red,
      Colors.deepOrange,
      Colors.purple,
      Colors.teal
    ]; // New list of colors for MenuPlaylist

    final double cardWidth = (MediaQuery.of(context).size.width - 32 - 12) / 3;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 4.0),
              child: Text(
                'Eat Pass',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  // Handle Eat Pass button tap
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32 - 12,
                  height: 160.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Eat Pass',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0.0, 4.0),
              child: Text(
                'Personalized Menus',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  boxTitles.length,
                  (index) => Container(
                    width: cardWidth,
                    child: VerticalCard(
                      title: boxTitles[index],
                      onPressed: () {},
                      color: boxColors[index],
                      height: 200.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 4.0),
              child: Text(
                'Your Menus',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 8.0,
              children: List.generate(
                4,
                (index) => MenuPlaylist(
                  title: 'Menu ${index + 1}',
                  onPressed: () {},
                  color: menuColors[index], // Set color for MenuPlaylist
                  height: 200.0,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }
}
