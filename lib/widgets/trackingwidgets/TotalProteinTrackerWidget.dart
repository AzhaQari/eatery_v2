import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllTimeProteinWidget extends StatefulWidget {
  final String userId;

  const AllTimeProteinWidget({Key? key, required this.userId})
      : super(key: key);

  @override
  _AllTimeProteinWidgetState createState() => _AllTimeProteinWidgetState();
}

class _AllTimeProteinWidgetState extends State<AllTimeProteinWidget> {
  int _totalProtein = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && mounted) {
        setState(() {
          _totalProtein = snapshot.data()?['allTimeProtein'] ?? 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_totalProtein g',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
  }
}
