import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatery/meal_model.dart';
import 'package:eatery/screens/Profile/YourMenus/create_a_menu_widget.dart';

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
        String id = map['id'] as String? ?? 'default-id';
        String name = map['name'] as String? ?? 'Unnamed Menulist';
        return {
          'id': id,
          'name': name,
        };
      })
    );
    selectedMenulists = {
      for (var m in menulists) m['id']: false,
    };
  });
}


  void toggleMenulistSelection(String menulistId) {
    setState(() {
      // Ensure we only toggle the selected menulist
      selectedMenulists[menulistId] = !selectedMenulists[menulistId]!;
      print("Toggled $menulistId to ${selectedMenulists[menulistId]}"); // Debug output
    });
  }

  Future<void> addMealToSelectedMenulists() async {
    for (var menulistId in selectedMenulists.keys) {
      if (selectedMenulists[menulistId]!) {
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
        Map<String, dynamic> mealData = {
          'calories': widget.currentMeal.calories,
          'dateTracked': widget.currentMeal.dateTracked,
          'item name': widget.currentMeal.name,
          'price': widget.currentMeal.price,
          'protein': widget.currentMeal.protein,
          'restaurant': widget.currentMeal.restaurant,
        };

        await userDocRef.update({
          'menulists': FieldValue.arrayUnion([
            {'id': menulistId, 'meals': FieldValue.arrayUnion([mealData])}
          ])
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.currentMeal.name} was added to menulist')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Menulist'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateMenulistPage(mealToInclude: widget.currentMeal)
              )
            ),
          ),
        ],
      ),
      body: menulists.isEmpty ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: menulists.length,
        itemBuilder: (context, index) {
          final menulist = menulists[index];
          final menulistId = menulist['id'] as String?;
          final menulistName = menulist['name'] as String?;

          if (menulistId == null || menulistName == null) {
            return Container();
          }

          var isSelected = selectedMenulists[menulistId] ?? false;

          return ListTile(
            title: Text(menulistName),
            trailing: Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green : null,
            ),
            onTap: () => toggleMenulistSelection(menulistId),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addMealToSelectedMenulists,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
