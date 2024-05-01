import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eatery/theme.dart'; // Confirm this path matches where menuItemColors is defined
import 'package:eatery/meal_model.dart'; // Confirm this path is correct
import 'package:firebase_auth/firebase_auth.dart'; // Add this import for FirebaseAuth
import 'package:eatery/utilities/data_filter_utility.dart'; // Ensure this import is correct

class MealDetailPage extends StatefulWidget {
  final List<Meal> meals;
  final int initialIndex;

  MealDetailPage({required this.meals, required this.initialIndex});

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meals[widget.initialIndex].name),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.meals.length,
        itemBuilder: (context, index) {
          Meal meal = widget.meals[index];
          final int colorIndex = meal.name.length % menuItemColors.length;
          final Color cardColor = menuItemColors[colorIndex];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    meal.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    meal.restaurant,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child:
                              NutritionalInfoBox(label: 'Price', value: '0')),
                      SizedBox(width: 8), // Spacing between boxes
                      Expanded(
                          child: NutritionalInfoBox(
                              label: 'Cals', value: '${meal.calories}')),
                      SizedBox(width: 8), // Spacing between boxes
                      Expanded(
                          child: NutritionalInfoBox(
                              label: 'Protein', value: '${meal.protein}g')),
                      SizedBox(width: 8), // Spacing between boxes
                      Expanded(
                          child:
                              TrackButton(meal: meal)), // Pass the meal object
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        scrollDirection: Axis.vertical,
      ),
    );
  }
}

class NutritionalInfoBox extends StatelessWidget {
  final String label;
  final String value;

  NutritionalInfoBox({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.white60),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TrackButton extends StatefulWidget {
  final Meal meal;

  TrackButton({Key? key, required this.meal}) : super(key: key);

  @override
  _TrackButtonState createState() => _TrackButtonState();
}

class _TrackButtonState extends State<TrackButton> {
  bool _isTracked = false; // Initial state of tracking

  Future<void> _trackMeal() async {
    // Ensure we have a user id, otherwise, abort the tracking
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Not logged in')));
      return;
    }

    if (!_isTracked) {
      // Create a map of the meal's details
      Map<String, dynamic> mealData = {
        'dateTracked': DateTime.now(),
        'restaurant': widget.meal.restaurant,
        'item name': widget.meal.name,
        'protein': widget.meal.protein,
        'calories': widget.meal.calories,
        'price': widget.meal.price, // Update this if price handling changes
      };

      // Reference to the user's document in Firestore
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        // Get the user's current document to calculate the new protein total
        DocumentSnapshot snapshot = await transaction.get(userDoc);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }
        Map<String, dynamic> userData =
            snapshot.data() as Map<String, dynamic>; // Proper casting
        int currentProtein =
            userData['allTimeProtein'] ?? 0; // Use of the casted data

        // Update the total protein with the protein from the new meal
        int updatedProtein = currentProtein + widget.meal.protein;

        // Perform the updates within a transaction
        transaction.update(userDoc, {
          'allTimeProtein': updatedProtein,
          'trackedMeals': FieldValue.arrayUnion([mealData]),
        });
      }).then((_) {
        setState(() {
          _isTracked = true; // Update the tracked state
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Meal tracked!')));

        // Set the state back to untracked after 3 seconds
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _isTracked = false;
          });
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to track meal: $error')));
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Meal already tracked')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _trackMeal,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isTracked ? Icons.check_circle : Icons.add_circle_outline,
              color: _isTracked ? Colors.lightGreen : Colors.white,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              _isTracked ? 'Tracked' : 'Track',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
