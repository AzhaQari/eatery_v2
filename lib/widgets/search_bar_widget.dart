import 'package:eatery/widgets/meal_card.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart'; // Import Algolia library
import 'package:eatery/main.dart';

class SearchResultsScreen extends StatefulWidget {
  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late List<AlgoliaObjectSnapshot> _searchResults = [];
  // final Algolia algolia = Algolia.init(
  //   applicationId: 'YOUR_APPLICATION_ID',
  //   apiKey: 'YOUR_API_KEY',
  // );
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            _performSearch(value);
          },
        ),
      ),
      body: _buildSearchResults(),
    );
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    AlgoliaQuery algoliaQuery = algolia.instance.index('allmenuNutrition').query(query);
    AlgoliaQuerySnapshot snapshot = await algoliaQuery.getObjects();

    setState(() {
      _searchResults = snapshot.hits;
    });
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results found'),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        AlgoliaObjectSnapshot searchResult = _searchResults[index];
        // Extract meal details from search result
        String mealName = searchResult.data['item name'] ?? 'N/A';
        String restaurantName = searchResult.data['restaurant'] ?? 'N/A';
        int calories = int.tryParse(searchResult.data['calories']?.toString() ?? '0') ?? 0;
        int protein = int.tryParse(searchResult.data['protein']?.toString() ?? '0') ?? 0;



        // Return MealCard widget with extracted meal details
        return MealCard(
          mealName: mealName,
          restaurantName: restaurantName,
          calories: calories,
          protein: protein,
        );
      },
    );
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
