import 'package:eatery/main.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart'; // Import Algolia library
import 'package:eatery/meal_model.dart';
import 'package:eatery/widgets/meal_card.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Meal> _meals = []; // Now stores Meal objects
  int _currentPage = 0;
  int _itemsPerPage = 100;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    AlgoliaQuery query = algolia.instance
        .index('allmenuNutrition')
        .query('')
        .setHitsPerPage(_itemsPerPage)
        .setPage(_currentPage);
    AlgoliaQuerySnapshot snapshot = await query.getObjects();
    setState(() {
      _meals = snapshot.hits
          .map((hit) => Meal(
                name: hit.data['item name'] ?? 'N/A',
                restaurant: hit.data['restaurant'] ?? 'N/A',
                calories: hit.data['calories'] ?? 0,
                protein: hit.data['protein'] ?? 0,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [Tab(text: 'FYP'), Tab(text: 'Explore')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Placeholder(), // Placeholder for FYP tab
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      _loadMoreItems();
                      return true;
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: _meals.length,
                    itemBuilder: (context, index) {
                      return MealCard(
                        meal: _meals[index],
                        meals: _meals,
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarWidget(), // Your BottomAppBarWidget
    );
  }

  void _loadMoreItems() {
    _currentPage++;
    _fetchMenuItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
