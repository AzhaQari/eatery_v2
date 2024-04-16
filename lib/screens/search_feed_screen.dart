import 'package:eatery/main.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart'; // Import Algolia library
import 'package:eatery/meal_model.dart';
import 'package:eatery/widgets/meal_card.dart';

class SearchFeedScreen extends StatefulWidget {
  @override
  _SearchFeedScreenState createState() => _SearchFeedScreenState();
}

class _SearchFeedScreenState extends State<SearchFeedScreen> {
  late TextEditingController _searchController;
  List<Meal> _filteredMeals = []; // List to hold filtered meals

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMeals(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredMeals = []; // Clear results when query is empty
      });
      return;
    }

    AlgoliaQuery searchQuery = algolia.instance
        .index('allmenuNutrition')
        .query(query)
        .setHitsPerPage(100); // Adjust the hits per page as needed
    AlgoliaQuerySnapshot snapshot = await searchQuery.getObjects();

    // Convert Algolia hits to Meal objects
    List<Meal> newMeals = snapshot.hits
        .map((hit) => Meal(
      name: hit.data['item name'] ?? 'N/A',
      restaurant: hit.data['restaurant'] ?? 'N/A',
      calories: hit.data['calories'] ?? 0,
      protein: hit.data['protein'] ?? 0,
    ))
        .toList();

    // Using a set to avoid duplicates, considering unique identifier as name and restaurant
    Set<Map<String, dynamic>> mealsSet = Set();
    List<Meal> filteredMeals = [];

    for (Meal meal in newMeals) {
      var key = {'name': meal.name, 'restaurant': meal.restaurant};
      if (mealsSet.add(key)) {
        filteredMeals.add(meal);
      }
    }

    // Filter meals by both menu items and restaurants
    filteredMeals = filteredMeals.where((meal) =>
    meal.restaurant.toLowerCase().contains(query.toLowerCase()) ||
        meal.name.toLowerCase().contains(query.toLowerCase())).toList();

    // Sort meals by protein values in descending order
    filteredMeals.sort((a, b) => b.protein.compareTo(a.protein));

    setState(() {
      _filteredMeals = filteredMeals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search food or restaurant',
            border: InputBorder.none,
          ),
          onChanged: _searchMeals,
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredMeals.length,
        itemBuilder: (context, index) {
          return MealCard(
            meal: _filteredMeals[index],
            meals: _filteredMeals,
            index: index,
          );
        },
      ),
    );
  }
}