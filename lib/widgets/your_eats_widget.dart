import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatery/widgets/meal_card.dart';
import 'package:eatery/meal_model.dart';
import 'package:intl/intl.dart';

class YourEatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String? userId = auth.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Extract the trackedMeals array from the snapshot
        var trackedMealsData = snapshot.data!.get('trackedMeals') as List<dynamic>;

        // Convert the dynamic meals to a list of Meal objects
        List<Meal> meals = trackedMealsData.map((mealData) => Meal.fromMap(mealData as Map<String, dynamic>)).toList();

        // Group meals by the 'dateTracked' field using DateTime for accurate sorting
        Map<DateTime, List<Meal>> mealsGroupedByDate = {};
        for (var meal in meals) {
          DateTime justDate = DateTime(meal.dateTracked.year, meal.dateTracked.month, meal.dateTracked.day); // Strip time part
          mealsGroupedByDate.putIfAbsent(justDate, () => []).add(meal);
        }

        // Convert the map into a list of map entries and sort by date in descending order
        List<MapEntry<DateTime, List<Meal>>> sortedMeals = mealsGroupedByDate.entries.toList()
          ..sort((a, b) => b.key.compareTo(a.key)); // Sort to display most recent dates first

        return ListView.builder(
          itemCount: sortedMeals.length,
          itemBuilder: (context, index) {
            var entry = sortedMeals[index];
            var date = DateFormat('dd MMMM, yyyy').format(entry.key); // Format date for display
            var mealsForDate = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    date, // Formatted date string
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...mealsForDate.map((meal) {
                  return MealCard(
                    meal: meal,
                    meals: mealsForDate, // Pass the list of meals for this date to the MealCard
                    index: mealsForDate.indexOf(meal), // Pass the index of the meal in the list
                  );
                }).toList(),
              ],
            );
          },
        );
      },
    );
  }
}
