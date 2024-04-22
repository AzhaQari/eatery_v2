import 'package:eatery/main.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart'; // Import Algolia library
import 'package:eatery/meal_model.dart';
import 'package:eatery/widgets/meal_card.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';
import 'search_feed_screen.dart'; // Import the search feed screen

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
  final Algolia algolia = Algolia.init(
    applicationId: '9EHWYVNJY9',
    apiKey: 'e1baf96f6dce70195bbe680d1ac8047e',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    AlgoliaQuery query = algolia
        .index('allmenuNutrition')
        .query('')
        .setHitsPerPage(_itemsPerPage)
        .setPage(_currentPage);
    AlgoliaQuerySnapshot snapshot = await query.getObjects();
    setState(() {
      _meals = snapshot.hits
          .map((hit) => Meal.fromMap(hit.data as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Food'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchFeedScreen()));
            },
          ),
        ],
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

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
          child: Text('Open Search'),
        ),
      ),
    );
  }
}
