import 'package:flutter/material.dart';
import 'package:eatery/utilities/data_filter_utility.dart';

class TodaysProteinWidget extends StatefulWidget {
  final String userId;

  const TodaysProteinWidget({Key? key, required this.userId}) : super(key: key);

  @override
  _TodaysProteinWidgetState createState() => _TodaysProteinWidgetState();
}

class _TodaysProteinWidgetState extends State<TodaysProteinWidget> {
  int _todayProtein = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    int protein = await DataFilterUtility.computeTodayProtein(widget.userId);
    setState(() {
      _todayProtein = protein;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('Today\'s Protein',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 8),
          Text('$_todayProtein g',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }
}