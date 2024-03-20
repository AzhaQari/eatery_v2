import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => MealDetailsScreen(
            mealName: mealName,
            restaurantName: restaurantName,
            calories: calories,
            protein: protein,
          ),
        ));
      },
      child: Hero(
        tag: mealName, // Unique tag for each meal card
        child: Card(
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 3,
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
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Restaurant: $restaurantName',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
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
                      ),
                    ),
                    Text(
                      'Protein: $protein g',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  const MealDetailsScreen({
    required this.mealName,
    required this.restaurantName,
    required this.calories,
    required this.protein,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Navigate back when tapped outside
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Meal Details'),
        ),
        body: Center(
          child: Hero(
            tag: mealName, // Same tag as the MealCard
            child: Material(
              type: MaterialType.transparency,
              child: Card(
                margin: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
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
                            color: Colors.grey[600],
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
