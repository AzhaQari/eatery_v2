import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class EatPassCard extends StatefulWidget {
  @override
  _EatPassCardState createState() => _EatPassCardState();
}

class _EatPassCardState extends State<EatPassCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;
  late Future<Map<String, dynamic>> _userStatsFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _userStatsFuture = _fetchUserStats();
  }

  Future<Map<String, dynamic>> _fetchUserStats() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      return {'meals': 0, 'spent': 0.0, 'protein': 0};
    }

    final String userId = user.uid;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    final List<dynamic> trackedMeals = userData['trackedMeals'] ?? [];
    final DateTime now = DateTime.now();
    final DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);

    int mealsCount = 0;
    double totalSpent = 0.0;
    int totalProtein = 0;

    for (var meal in trackedMeals) {
      DateTime mealDate = (meal['dateTracked'] as Timestamp).toDate();
      if (mealDate.isAfter(oneMonthAgo)) {
        mealsCount++;
        totalSpent += (meal['price'] as num?)?.toDouble() ?? 0.0;
        totalProtein += (meal['protein'] as num?)?.toInt() ?? 0;
      }
    }

    return {
      'meals': mealsCount,
      'spent': totalSpent,
      'protein': totalProtein,
    };
  }

  void _toggleCard() {
    setState(() {
      _isFlipped = !_isFlipped;
      if (_isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _userStatsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final userStats = snapshot.data!;
        final int mealsCount = userStats['meals'];
        final double totalSpent = userStats['spent'];
        final int totalProtein = userStats['protein'];
        final String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

        return GestureDetector(
          onTap: _toggleCard,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final angle = _animation.value * 3.14159;
              final isFront = angle < 3.14159 / 2;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: isFront
                    ? _buildFront()
                    : Transform(
                        transform: Matrix4.identity()..rotateY(3.14159),
                        alignment: Alignment.center,
                        child: _buildBack(mealsCount, totalSpent, totalProtein, formattedDate),
                      ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFront() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        height: 160.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.blue,
        ),
        child: Image.asset(
          'lib/images/EatForHat1.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }

  Widget _buildBack(int mealsCount, double totalSpent, int totalProtein, String formattedDate) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        height: 160.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.green,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome User',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildStatBox('Meals', '$mealsCount'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildStatBox('Spent', '\$${totalSpent.toStringAsFixed(2)}'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildStatBox('Protein', '${totalProtein}g'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildStatBox('Share', '', Icons.share),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              formattedDate,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, [IconData? icon]) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: Colors.white, size: 24)
          else
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.white60),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
