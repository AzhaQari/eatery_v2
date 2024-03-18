import 'package:flutter/material.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                ListView.builder(
                  itemCount: 10, // Example count
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item $index'),
                    );
                  },
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
