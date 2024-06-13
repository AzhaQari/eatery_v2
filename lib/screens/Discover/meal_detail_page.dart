import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatery/theme.dart'; // Confirm this path matches where menuItemColors is defined
import 'package:eatery/meal_model.dart'; // Confirm this path is correct
import 'package:eatery/utilities/data_filter_utility.dart'; // Ensure this import is correct
import 'package:eatery/screens/Profile/YourMenus/create_a_menu_widget.dart';
import 'package:eatery/screens/Profile/YourMenus/add_to_menu_widget.dart';

class MealDetailPage extends StatefulWidget {
  final List<Meal> meals;
  final int initialIndex;

  MealDetailPage({required this.meals, required this.initialIndex});

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meals[widget.initialIndex].name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () => showMenuOptions(context),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.meals.length,
        itemBuilder: (context, index) {
          Meal meal = widget.meals[index];
          final int colorIndex = meal.name.length % menuItemColors.length;
          final Color cardColor = menuItemColors[colorIndex];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3,
                  color: cardColor,
                  child: Center(
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    meal.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    meal.restaurant,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: NutritionalInfoBox(label: 'Price', value: '0')),
                      SizedBox(width: 8),
                      Expanded(
                          child: NutritionalInfoBox(label: 'Cals', value: '${meal.calories}')),
                      SizedBox(width: 8),
                      Expanded(
                          child: NutritionalInfoBox(label: 'Protein', value: '${meal.protein}g')),
                      SizedBox(width: 8),
                      Expanded(
                          child: TrackButton(meal: meal)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        scrollDirection: Axis.vertical,
      ),
    );
  }

  void showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.playlist_add),
              title: Text('Add to Menulist'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddToMenuWidget(currentMeal: widget.meals[widget.initialIndex])
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.playlist_add_check),
              title: Text('Create Menulist'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateMenulistPage(mealToInclude: widget.meals[widget.initialIndex])
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                // Implement the functionality to share
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class NutritionalInfoBox extends StatelessWidget {
  final String label;
  final String value;

  NutritionalInfoBox({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.white60),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TrackButton extends StatefulWidget {
  final Meal meal;

  TrackButton({Key? key, required this.meal}) : super(key: key);

  @override
  _TrackButtonState createState() => _TrackButtonState();
}

class _TrackButtonState extends State<TrackButton> {
  bool _isTracked = false; // Initial state of tracking

  Future<void> _trackMeal() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not logged in')));
      return;
    }

    if (!_isTracked) {
      Map<String, dynamic> mealData = {
        'dateTracked': DateTime.now(),
        'restaurant': widget.meal.restaurant,
        'item name': widget.meal.name,
        'protein': widget.meal.protein,
        'calories': widget.meal.calories,
        'price': widget.meal.price,
      };

      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userDoc);
          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }

          Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
          DateTime lastProteinUpdate = (userData['lastProteinUpdate'] as Timestamp?)?.toDate() ?? DateTime.now();
          DateTime lastCalorieUpdate = (userData['lastCalorieUpdate'] as Timestamp?)?.toDate() ?? DateTime.now();

          bool isProteinNewDay = !isSameDay(DateTime.now(), lastProteinUpdate);
          bool isCalorieNewDay = !isSameDay(DateTime.now(), lastCalorieUpdate);

          int updatedProtein = isProteinNewDay ? widget.meal.protein : (userData['todayProtein'] ?? 0) + widget.meal.protein;
          int updatedCalories = isCalorieNewDay ? widget.meal.calories : (userData['todayCalories'] ?? 0) + widget.meal.calories;

          transaction.update(userDoc, {
            'todayProtein': updatedProtein,
            'allTimeProtein': (userData['allTimeProtein'] ?? 0) + widget.meal.protein,
            'todayCalories': updatedCalories,
            'lastProteinUpdate': isProteinNewDay ? FieldValue.serverTimestamp() : lastProteinUpdate,
            'lastCalorieUpdate': isCalorieNewDay ? FieldValue.serverTimestamp() : lastCalorieUpdate,
            'trackedMeals': FieldValue.arrayUnion([mealData]),
          });
        });

        if (mounted) {
          setState(() { _isTracked = true; });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Meal tracked!')));

          Future.delayed(Duration(seconds: 3), () {
  if (mounted) {
    setState(() {
      _isTracked = false;
    });
  }
});

        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to track meal: $error')));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Meal already tracked')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _trackMeal,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isTracked ? Icons.check_circle : Icons.add_circle_outline,
              color: _isTracked ? Colors.lightGreen : Colors.white,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              _isTracked ? 'Tracked' : 'Track',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}



