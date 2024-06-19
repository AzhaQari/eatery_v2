import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatery/meal_model.dart';
import 'package:eatery/screens/Profile/YourMenus/create_a_menu_widget.dart';
import 'package:eatery/theme.dart'; // Ensure this path is correct

class AddToMenuWidget extends StatefulWidget {
  final Meal currentMeal;

  const AddToMenuWidget({Key? key, required this.currentMeal}) : super(key: key);

  @override
  _AddToMenuWidgetState createState() => _AddToMenuWidgetState();
}

class _AddToMenuWidgetState extends State<AddToMenuWidget> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  List<Map<String, dynamic>> menulists = [];
  Map<String, bool> selectedMenulists = {};
  String searchQuery = '';

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
      selectedMenulists = Map.fromIterable(menulists, key: (item) => item['id'], value: (item) => false);
    });
  }

  void toggleMenulistSelection(String menulistId) {
    setState(() {
      selectedMenulists[menulistId] = !selectedMenulists[menulistId]!;
    });
  }

  Future<void> addMealToSelectedMenulists() async {
    if (userId == null) {
      print("User ID is null.");
      return;
    }

    final DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final DocumentSnapshot userDocSnapshot = await userDocRef.get();
    final userData = userDocSnapshot.data() as Map<String, dynamic>;
    final List<dynamic> existingMenulists = userData['menulists'] as List<dynamic>? ?? [];

    final mealData = {
      'calories': widget.currentMeal.calories,
      'dateTracked': widget.currentMeal.dateTracked,
      'item name': widget.currentMeal.name,
      'price': widget.currentMeal.price,
      'protein': widget.currentMeal.protein,
      'restaurant': widget.currentMeal.restaurant,
    };

    List<String> addedToMenulists = [];

    for (var menulistId in selectedMenulists.keys) {
      if (selectedMenulists[menulistId]!) {
        final menulistIndex = existingMenulists.indexWhere((element) => element['id'] == menulistId);
        if (menulistIndex != -1) {
          List<dynamic> meals = List<dynamic>.from(existingMenulists[menulistIndex]['meals'] ?? []);
          meals.add(mealData);
          existingMenulists[menulistIndex]['meals'] = meals;
          addedToMenulists.add(existingMenulists[menulistIndex]['name']);
        }
      }
    }

    await userDocRef.update({'menulists': existingMenulists});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.currentMeal.name} was added to ${addedToMenulists.join(', ')}')),
    );

    // Navigate back to the previous screen after showing the SnackBar
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final filteredMenulists = menulists.where((menulist) {
      final nameLower = menulist['name'].toLowerCase();
      final descriptionLower = menulist['description'].toLowerCase();
      final searchLower = searchQuery.toLowerCase();
      return nameLower.contains(searchLower) || descriptionLower.contains(searchLower);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Menulist'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateMenulistPage(mealToInclude: widget.currentMeal),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search menulists',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredMenulists.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredMenulists.length,
                    itemBuilder: (context, index) {
                      final menulist = filteredMenulists[index];
                      final menulistId = menulist['id'] as String;
                      final menulistName = menulist['name'] as String;
                      final menulistDescription = menulist['description'] as String;
                      final int colorIndex = menulistName.length % menuItemColors.length;
                      final Color boxColor = menuItemColors[colorIndex];

                      final isSelected = selectedMenulists[menulistId] ?? false;

                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        title: Text(menulistName),
                        subtitle: Text(menulistDescription),
                        trailing: Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isSelected ? Colors.green : null,
                        ),
                        onTap: () {
                          toggleMenulistSelection(menulistId);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          onPressed: addMealToSelectedMenulists,
          label: Text(
            'Add to menulist',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          icon: Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
