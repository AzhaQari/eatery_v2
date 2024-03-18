import 'package:eatery/main.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart'; // Import Algolia library
import 'package:eatery/widgets/bottom_app_bar.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<AlgoliaObjectSnapshot> _menuItems;
  int _currentPage = 0;
  int _itemsPerPage = 10; // Adjust the number of items per page as needed

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _menuItems = [];
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    AlgoliaQuery query = algolia.instance.index('allmenuNutrition')
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
              controller: _tabController, // Assign the TabController
              children: [
                // Content for FYP tab
                Placeholder(), // Placeholder for FYP tab
                // Content for Explore tab
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      _loadMoreItems(); // Load more items when reaching the end of the list
                      return true;
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      AlgoliaObjectSnapshot menuItem = _menuItems[index];
                      return ListTile(
                        title: Text(menuItem.data['item name']),
                        subtitle: Text(menuItem.data['restaurant']),
                        // Add more widget properties to display other attributes
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
    _tabController.dispose(); // Dispose the TabController to prevent memory leaks
    super.dispose();
  }
}

