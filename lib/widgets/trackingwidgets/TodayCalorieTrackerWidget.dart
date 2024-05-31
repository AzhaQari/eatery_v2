import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // Import intl to format dates.

class TodaysCaloriesWidget extends StatefulWidget {
  final String userId;

  const TodaysCaloriesWidget({Key? key, required this.userId}) : super(key: key);

  @override
  _TodaysCaloriesWidgetState createState() => _TodaysCaloriesWidgetState();
}

class _TodaysCaloriesWidgetState extends State<TodaysCaloriesWidget> {
  int _todayCalories = 0;
  Timer? _timer;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _loadData();
    _scheduleMidnightReset();
  }

  void _loadData() {
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && mounted) {
        DateTime lastUpdated = (snapshot.data()?['lastCalorieUpdate'] as Timestamp?)?.toDate() ?? DateTime.now();
        DateTime today = DateTime.now();
        if (!isSameDay(lastUpdated, today)) {
          _todayCalories = 0;
        } else {
          _todayCalories = snapshot.data()?['todayCalories'] ?? 0;
        }
        setState(() {});
      }
    });
  }

  void _scheduleMidnightReset() {
    DateTime now = DateTime.now();
    DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1);
    Duration timeToMidnight = nextMidnight.difference(now);
    _timer = Timer(timeToMidnight, () {
      setState(() {
        _todayCalories = 0; // Reset calories at midnight
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _subscription?.cancel();  // Correctly call cancel on the declared _subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_todayCalories cal',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
