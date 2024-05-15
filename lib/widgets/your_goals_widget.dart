import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatery/utilities/data_filter_utility.dart';
import 'package:eatery/widgets/trackingwidgets/TotalProteinTrackerWidget.dart'; // Ensure this path is correct
import 'package:eatery/widgets/trackingwidgets/TodayProteinTrackerWidget.dart'; // Ensure this path is correct
import 'package:eatery/widgets/trackingwidgets/TodayCalorieTrackerWidget.dart'; // Ensure this path is correct

class YourGoalsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      return Center(child: Text("Please log in to view your goals."));
    }

    final String userId = user.uid;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row with protein trackers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: AllTimeProteinWidget(userId: userId),
                ),
                SizedBox(width: 10), // This adds space between the two widgets
                Expanded(
                  child: TodaysProteinWidget(userId: userId),
                ),
              ],
            ),
            SizedBox(height: 15), // Space between rows
            // Second row with calorie tracker
            TodaysCaloriesWidget(userId: userId),
          ],
        ),
      ),
    );
  }
}
