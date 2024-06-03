import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:eatery/utilities/data_filter_utility.dart';
import 'package:eatery/meal_model.dart';

class TodaysProteinWidget extends StatefulWidget {
  final String userId;

  const TodaysProteinWidget({Key? key, required this.userId}) : super(key: key);

  @override
  _TodaysProteinWidgetState createState() => _TodaysProteinWidgetState();
}

class _TodaysProteinWidgetState extends State<TodaysProteinWidget> {
  int _todayProtein = 0;
  Timer? _timer;
  StreamSubscription? _subscription; // Subscription to Firestore

  @override
  void initState() {
    super.initState();
    _subscribeToProteinUpdates();
    _scheduleMidnightReset();
  }

  void _subscribeToProteinUpdates() {
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && mounted) {
        DateTime lastUpdated = (snapshot.data()?['lastProteinUpdate'] as Timestamp?)?.toDate() ?? DateTime.now();
        DateTime today = DateTime.now();
        if (!isSameDay(lastUpdated, today)) {
          _todayProtein = 0;
        } else {
          _todayProtein = snapshot.data()?['todayProtein'] ?? 0;
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
      _loadData();  // Reload data to check and reset if necessary
    });
  }

  void _loadData() async {
    int proteinToday = await DataFilterUtility.computeTodayProtein(widget.userId);
    if (mounted) {
      setState(() {
        _todayProtein = proteinToday;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _subscription?.cancel();  // Make sure to cancel the subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_todayProtein g',
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
