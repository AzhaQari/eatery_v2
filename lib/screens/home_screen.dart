import 'package:flutter/material.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';
import 'package:eatery/widgets/vertical_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> boxTitles = ['High Protein', 'Chicken', 'Keto'];
    final List<Color> boxColors = [Colors.green, Colors.blue, Colors.orange];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
            child: Text(
              'Eat Pass',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
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
                height: 160.0, // Set the height of the Eat Pass card
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blue, // Example color
                ),
                child: Text(
                  'Eat Pass',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
            child: Text(
              'Personalized Menus',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                boxTitles.length,
                (index) => VerticalCard(
                  title: boxTitles[index],
                  onPressed: () {},
                  color: boxColors[index],
                  height: 160.0, // Set the height of the vertical card
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarWidget(), // Add the bottom app bar
    );
  }
}
