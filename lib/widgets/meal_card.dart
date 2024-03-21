import 'package:flutter/material.dart';
import 'package:eatery/theme.dart';

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
            cardColor: cardColor, // Pass cardColor to MealDetailsScreen
          ),
        ));
      },
      child: Hero(
        tag: mealName,
        child: Card(
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 3,
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Restaurant: $restaurantName',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calories: $calories cal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Protein: $protein g',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
  final Color cardColor; // Add cardColor property

  const MealDetailsScreen({
    required this.mealName,
    required this.restaurantName,
    required this.calories,
    required this.protein,
    required this.cardColor, // Receive cardColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Meal Details'),
        ),
        body: Center(
          child: Hero(
            tag: mealName,
            child: Material(
              type: MaterialType.transparency,
              child: Card(
                margin: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
                color: cardColor, // Use cardColor here
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          mealName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Restaurant: $restaurantName',
                          style: TextStyle(
                            fontSize: 18,
                            color: darkColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Calories: $calories cal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Protein: $protein g',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}