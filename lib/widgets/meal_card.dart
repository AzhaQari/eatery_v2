import 'package:flutter/material.dart';
import 'package:eatery/theme.dart'; // Ensure this path is correct
import 'package:eatery/meal_model.dart';
import 'package:eatery/screens/Discover/meal_detail_page.dart'; // Verify this import

class MealCard extends StatelessWidget {
  final Meal meal; // The current meal
  final List<Meal> meals; // The entire list of meals
  final int index; // Index of the current meal in the list

  const MealCard({
    Key? key,
    required this.meal,
    required this.meals,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int colorIndex =
        meal.name.length % menuItemColors.length; // Example calculation
    final Color cardColor =
        menuItemColors[colorIndex]; // Access the color from your theme

    return GestureDetector(
      onTap: () {
        // Navigate to MealDetailPage with meals and index
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MealDetailPage(meals: meals, initialIndex: index),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 3,
        color: cardColor, // Use the dynamically determined color
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      meal.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2),
                    Text(
                      meal.restaurant,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    Text(
                      '\$X | ${meal.calories} cal | ${meal.protein}g',
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


// trackedMeals should be an array that holds meal-card maps. each map in this list should have the following attributes:
//
// -> mealPrice (int)
// -> mealName (string)
// -> mealCalories (int)
// -> mealProtein (int)
// -> mealRestaurant (string)