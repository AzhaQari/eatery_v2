import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatery/utilities/data_filter_utility.dart';

// Make sure these paths match the actual file locations
import 'package:eatery/widgets/trackingwidgets/TotalProteinTrackerWidget.dart';
import 'package:eatery/widgets/trackingwidgets/TodayProteinTrackerWidget.dart';

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
            // Widgets are now placed side by side using a Row.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  // Instantiate AllTimeProteinWidget with userId
                  child: AllTimeProteinWidget(userId: userId),
                ),
                SizedBox(width: 16), // This adds space between the two widgets
                Expanded(
                  // Instantiate TodaysProteinWidget with userId
                  child: TodaysProteinWidget(userId: userId),
                ),
              ],
            ),
            // Additional widgets for calories and budget tracking can be added here.
          ],
        ),
      ),
    );
  }
}
