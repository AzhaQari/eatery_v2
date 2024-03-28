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
                padding:
                    const EdgeInsets.only(right: 16.0), // Adjusted left padding
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
              // Text content
              Expanded(
                child: Center(
                  child: Column(
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
                      SizedBox(height: 2), // Reduced the height
                      Text(
                        restaurantName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6), // Adjusted the height
                      Text(
                        '\$$protein | $calories cal | ${protein}g',
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Meal Details'),
        ),
        body: Center(
          child: Card(
            margin: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 5,
            color: cardColor,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Restaurant: $restaurantName',
                      style: TextStyle(
                        fontSize: 16,
                        color: darkColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Calories: $calories cal',
                      style: TextStyle(
                        fontSize: 16,
                        color: darkColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Protein: $protein g',
                      style: TextStyle(
                        fontSize: 16,
                        color: darkColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
