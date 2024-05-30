import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class TodaysCaloriesWidget extends StatefulWidget {
  final String userId;

  const TodaysCaloriesWidget({Key? key, required this.userId})
      : super(key: key);

  @override
  _TodaysCaloriesWidgetState createState() => _TodaysCaloriesWidgetState();
}

class _TodaysCaloriesWidgetState extends State<TodaysCaloriesWidget> {
  int _todayCalories = 0;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && mounted) {
        setState(() {
          _todayCalories = snapshot.data()?['todayCalories'] ?? 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
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
}
