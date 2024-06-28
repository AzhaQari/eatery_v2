import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatery/theme.dart'; // Ensure this path is correct
import 'package:eatery/meal_model.dart'; // Ensure this path is correct
import 'package:eatery/widgets/meal_card.dart'; // Import MealCard

class MenulistWidget extends StatefulWidget {
  @override
  _MenulistWidgetState createState() => _MenulistWidgetState();
}

class _MenulistWidgetState extends State<MenulistWidget> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  List<Map<String, dynamic>> menulists = [];

  @override
  void initState() {
    super.initState();
    fetchMenulists();
  }

  void fetchMenulists() async {
    if (userId == null) {
      print("User ID is null.");
      return;
    }

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = userDoc.data();

    if (data == null) {
      print("No data found for user.");
      return;
    }

    final Map<String, dynamic> userData = data as Map<String, dynamic>;
    final List<dynamic> loadedMenulists = userData['menulists'] as List<dynamic>? ?? [];

    setState(() {
      menulists = List<Map<String, dynamic>>.from(
        loadedMenulists.map((e) {
          var map = e as Map<String, dynamic>;
          String id = map['id'] as String? ?? FirebaseFirestore.instance.collection('dummy').doc().id;
          String name = map['name'] as String? ?? 'Unnamed Menulist';
          String description = map['description'] as String? ?? '';
          List<dynamic> meals = map['meals'] as List<dynamic>? ?? [];
          return {
            'id': id,
            'name': name,
            'description': description,
            'meals': meals,
          };
        })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return menulists.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: menulists.length,
            itemBuilder: (context, index) {
              final menulist = menulists[index];
              final menulistId = menulist['id'] as String;
              final menulistName = menulist['name'] as String;
              final menulistDescription = menulist['description'] as String;
              final List<dynamic> meals = menulist['meals'];
              final mealCount = meals.length;
              final Color backgroundColor = menuItemColors[index % menuItemColors.length];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0), // Adjust spacing here
                child: Card(
                  margin: EdgeInsets.zero, // Remove card margin
                  color: backgroundColor,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/images/default.png'), // Placeholder for customizable image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      menulistName,
                      style: TextStyle(
                        fontSize: 18, // Larger font size for the menulist name
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menulistDescription,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$mealCount items saved',
                          style: TextStyle(fontSize: 12, color: Colors.white70), // Smaller font size for items saved
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward, color: Colors.white),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenulistDetailPage(menulist: menulist),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
  }
}

class MenulistDetailPage extends StatefulWidget {
  final Map<String, dynamic> menulist;
  final bool editable;

  MenulistDetailPage({required this.menulist, this.editable = true});

  @override
  _MenulistDetailPageState createState() => _MenulistDetailPageState();
}

class _MenulistDetailPageState extends State<MenulistDetailPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> filteredMeals = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterMeals);
    filteredMeals = widget.menulist['meals'];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMeals() {
    final query = _searchController.text.toLowerCase();
    final meals = widget.menulist['meals'];

    setState(() {
      filteredMeals = meals.where((meal) {
        final mealName = meal['item name'].toString().toLowerCase();
        final restaurantName = meal['restaurant'].toString().toLowerCase();
        return mealName.contains(query) || restaurantName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String menulistName = widget.menulist['name'];
    final String menulistDescription = widget.menulist['description'];

    return Scaffold(
      appBar: AppBar(
        title: Text(menulistName),
        actions: widget.editable
            ? [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // Implement the share functionality
                  },
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.black), // Ensure text color is black
              decoration: InputDecoration(
                hintText: 'Search menu',
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        color: Colors.green, // Placeholder color
                        child: Center(
                          child: Icon(
                            Icons.photo,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menulistName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                menulistDescription,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.editable)
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              // Implement the edit functionality
                            },
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredMeals.length,
                      itemBuilder: (context, index) {
                        final mealData = filteredMeals[index];
                        final Meal meal = Meal.fromMap(mealData as Map<String, dynamic>);
                        return MealCard(
                          meal: meal,
                          meals: filteredMeals.map((mealData) => Meal.fromMap(mealData as Map<String, dynamic>)).toList(),
                          index: index,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
