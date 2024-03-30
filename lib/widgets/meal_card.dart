import 'package:flutter/material.dart';
import 'package:eatery/theme.dart'; // Make sure this file defines 'menuItemColors'

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eatery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MealCard(
              mealName: 'Spaghetti Carbonara',
              restaurantName: 'Italian Bistro',
              calories: 650,
              protein: 20,
            ),
            MealCard(
              mealName: 'Grilled Salmon',
              restaurantName: 'Seafood Delight',
              calories: 430,
              protein: 30,
            ),
            // Add more MealCard widgets as needed
          ],
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String mealName;
  final String restaurantName;
  final int calories;
  final int protein;

  const MealCard({
    required this.mealName,
    required this.restaurantName,
    required this.calories,
    required this.protein,
  });

  @override
  Widget build(BuildContext context) {
    final int colorIndex = mealName.length % menuItemColors.length;
    final Color cardColor = menuItemColors[colorIndex];

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => MealDetailsScreen(
            mealName: mealName,
            restaurantName: restaurantName,
            calories: calories,
            protein: protein,
            cardColor: cardColor,
          ),
        ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 3,
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Placeholder image
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      color: Colors.grey,
                      child: Center(
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Text content, centered
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      mealName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2),
                    Text(
                      restaurantName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    Text(
                      '\$X | $calories | ${protein}g',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealDetailsScreen extends StatelessWidget {
  final String mealName;
  final String restaurantName;
  final int calories;
  final int protein;
  final Color cardColor;

  const MealDetailsScreen({
    required this.mealName,
    required this.restaurantName,
    required this.calories,
    required this.protein,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder image
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3,
            color: cardColor,
            child: Center(
              child: Icon(
                Icons.restaurant_menu,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Text(
              mealName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 4.0), // Reduced top padding
            child: Text(
              restaurantName,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NutritionalInfoBox(label: 'Spent', value: '\$X'),
                NutritionalInfoBox(
                    label: 'Cals', value: '$calories'), // Updated here
                NutritionalInfoBox(label: 'Protein', value: '${protein}g'),
                ShareButton(), // Instagram share button
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionalInfoBox extends StatelessWidget {
  final String label;
  final String value;

  const NutritionalInfoBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width / 4 -
        24; // Calculate width dynamically

    return Container(
      width: boxWidth,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850], // Adjust to match your design
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white60,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width / 4 -
        24; // Calculate width dynamically

    return Container(
      width: boxWidth,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850], // Adjust to match your design
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons
                .camera_alt, // Placeholder for the Instagram logo, use the actual logo if you have it
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            'Share',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
