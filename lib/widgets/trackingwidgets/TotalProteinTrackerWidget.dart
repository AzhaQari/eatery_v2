import 'package:flutter/material.dart';
import 'package:eatery/utilities/data_filter_utility.dart';

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

  void _loadData() async {
    int protein = await DataFilterUtility.computeAllTimeProtein(widget.userId);
    setState(() {
      _totalProtein = protein;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('All Time Protein',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 8),
          Text('$_totalProtein g',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
