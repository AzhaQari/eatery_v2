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
  final Algolia algolia = Algolia.init(
    applicationId: '9EHWYVNJY9',
    apiKey: 'e1baf96f6dce70195bbe680d1ac8047e',
  );

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

    AlgoliaQuery searchQuery = algolia
        .index('allmenuNutrition')
        .query(query)
        .setHitsPerPage(100); // Adjust the hits per page as needed
    AlgoliaQuerySnapshot snapshot = await searchQuery.getObjects();

    List<Meal> newMeals =
        snapshot.hits.map((hit) => Meal.fromMap(hit.data)).toList();

    Set<Map<String, dynamic>> mealsSet = Set();
    List<Meal> filteredMeals = [];

    for (Meal meal in newMeals) {
      var key = {'name': meal.name, 'restaurant': meal.restaurant};
      if (mealsSet.add(key)) {
        filteredMeals.add(meal);
      }
    }

    filteredMeals = filteredMeals
        .where((meal) =>
            meal.restaurant.toLowerCase().contains(query.toLowerCase()) ||
            meal.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

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
            meals:
                _filteredMeals, // Ensure the list is passed correctly for navigation
            index: index,
          );
        },
      ),
    );
  }
}
