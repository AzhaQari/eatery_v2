import 'package:eatery/main.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart'; // Import Algolia library
import 'package:eatery/widgets/bottom_app_bar.dart';
import 'package:eatery/widgets/meal_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<AlgoliaObjectSnapshot> _menuItems;
  int _currentPage = 0;
  int _itemsPerPage = 100; // Adjust the number of items per page as needed

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _menuItems = [];
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
      _menuItems.addAll(snapshot.hits);
    });
  }

  void _loadMoreItems() {
    _currentPage++;
    _fetchMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          // Tabs for explore and FYP
          TabBar(
            controller: _tabController, // Assign the TabController
            tabs: [
              Tab(text: 'FYP'), // FYP tab on the right
              Tab(text: 'Explore'), // Explore tab on the left
            ],
          ),
          // Content based on selected tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Placeholder(), // Placeholder for FYP tab
                // Content for Explore tab
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
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      AlgoliaObjectSnapshot menuItem = _menuItems[index];
                      // Handling "None" values
                      String mealName = menuItem.data['item name'] ?? 'N/A';
                      String restaurantName =
                          menuItem.data['restaurant'] ?? 'N/A';
                      int calories = (menuItem.data['calories'] is num)
                          ? (menuItem.data['calories'] as num).toInt()
                          : 0;
                      int protein = (menuItem.data['protein'] is num)
                          ? (menuItem.data['protein'] as num).toInt()
                          : 0;
                      return MealCard(
                        mealName: mealName,
                        restaurantName: restaurantName,
                        calories: calories,
                        protein: protein,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarWidget(), // Add the bottom app bar
    );
  }

  @override
  void dispose() {
    _tabController
        .dispose(); // Dispose the TabController to prevent memory leaks
    super.dispose();
  }
}
