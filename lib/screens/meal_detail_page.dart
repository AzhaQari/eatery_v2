import 'package:flutter/material.dart';
import 'package:eatery/theme.dart'; // Confirm this path matches where menuItemColors is defined
import 'package:eatery/meal_model.dart'; // Confirm this path is correct

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
                          child:
                              NutritionalInfoBox(label: 'Price', value: '\$X')),
                      SizedBox(width: 8), // Spacing between boxes
                      Expanded(
                          child: NutritionalInfoBox(
                              label: 'Cals', value: '${meal.calories}')),
                      SizedBox(width: 8), // Spacing between boxes
                      Expanded(
                          child: NutritionalInfoBox(
                              label: 'Protein', value: '${meal.protein}g')),
                      SizedBox(width: 8), // Spacing between boxes
                      Expanded(child: TrackButton()),
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
}

class NutritionalInfoBox extends StatelessWidget {
  final String label;
  final String value;

  const NutritionalInfoBox({
    required this.label,
    required this.value,
  });

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
  final Function(Meal) onTrack;

  TrackButton({Key? key, required this.meal, required this.onTrack})
      : super(key: key);

  // ... rest of your TrackButton code
}

class _TrackButtonState extends State<TrackButton> {
  bool _isTracked = false; // Initial state of tracking

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isTracked = !_isTracked; // Toggle the tracked state
        });
        if (_isTracked) {
          widget.onTrack(widget.meal); // Notify when a meal is tracked
        }
      },
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
              _isTracked
                  ? Icons.check_circle
                  : Icons
                      .add_circle_outline, // Conditional icon based on tracking state
              color: _isTracked
                  ? Colors.lightGreen
                  : Colors.white, // Conditional color based on tracking state
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              'Track',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
