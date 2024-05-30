import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:eatery/widgets/trackingwidgets/TotalProteinTrackerWidget.dart';
import 'package:eatery/widgets/trackingwidgets/TodayProteinTrackerWidget.dart';
import 'package:eatery/widgets/trackingwidgets/TodayCalorieTrackerWidget.dart';

class YourGoalsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      return Center(child: Text("Please log in to view your goals."));
    }

    final String userId = user.uid;
    final String todayDate = DateFormat('dd MMMM, yyyy').format(DateTime.now());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full-width row with all-time protein tracker
            SizedBox(
              width: double.infinity,
              height:
                  120, // Set fixed height to match the height of the boxes below
              child: CustomCard(
                labelText: 'All Time Protein',
                labelColor: Colors.blue,
                child: AllTimeProteinWidget(userId: userId),
              ),
            ),
            // Display today's date
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                todayDate,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Second row with today's protein and calorie trackers
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 120, // Set fixed height
                    child: CustomCard(
                      labelText: 'Today\'s Protein',
                      labelColor: Colors.green,
                      child: TodaysProteinWidget(userId: userId),
                    ),
                  ),
                ),
                SizedBox(width: 16), // Add spacing between the two boxes
                Expanded(
                  child: SizedBox(
                    height: 120, // Set fixed height
                    child: CustomCard(
                      labelText: 'Today\'s Calories',
                      labelColor: Colors.orange,
                      child: TodaysCaloriesWidget(userId: userId),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String labelText;
  final Color labelColor;
  final Widget child;

  CustomCard(
      {required this.labelText, required this.labelColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850], // Gray background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: labelColor, width: 2), // Border color matches label color
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: TextStyle(
                  color: labelColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            DefaultTextStyle(
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
