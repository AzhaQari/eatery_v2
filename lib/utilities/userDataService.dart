import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user = FirebaseAuth.instance.currentUser;

  int todayProtein = 0;
  int todayCalories = 0;

  UserDataService() {
    if (_user != null) {
      _checkAndUpdate();
    }
  }

  void _checkAndUpdate() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Fetch the last meal entry
    var snapshot = await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('trackedMeals')
        .orderBy('dateTracked', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var lastMeal = snapshot.docs.first;
      var lastDateTracked =
          DateFormat('yyyy-MM-dd').format(lastMeal['dateTracked'].toDate());

      if (today == lastDateTracked) {
        todayProtein = lastMeal['protein'];
        todayCalories = lastMeal['calories'];
      } else {
        todayProtein = 0;
        todayCalories = 0;
      }
    } else {
      todayProtein = 0;
      todayCalories = 0;
    }
  }
}
