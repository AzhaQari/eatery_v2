import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatery/widgets/meal_card.dart';
import 'package:eatery/meal_model.dart';

class YourEatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String? userId = auth.currentUser?.uid;

    // Adjust the stream to listen to changes in the user's document
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        // Extract the trackedMeals array from the user's document
        var trackedMealsData = snapshot.data!.get('trackedMeals') as List;
        var meals = trackedMealsData
            .map((mealData) => Meal.fromMap(mealData as Map<String, dynamic>))
            .toList();

        // If the array is empty, show a placeholder message
        if (meals.isEmpty) {
          return Center(child: Text("You haven't tracked any meals yet."));
        }

        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            return MealCard(
              meal: meals[index],
              meals:
                  meals, // Pass the entire list if needed for detail navigation
              index: index,
            );
          },
        );
      },
    );
  }
}
