import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && mounted) {
        setState(() {
          _todayProtein = snapshot.data()?['todayProtein'] ?? 0;
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
      '$_todayProtein g',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
