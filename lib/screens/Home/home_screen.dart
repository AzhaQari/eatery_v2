import 'package:flutter/material.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';
import 'package:eatery/widgets/vertical_card.dart';
import 'package:eatery/widgets/menu_playlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatery/theme.dart'; // Ensure this path is correct
import 'package:eatery/widgets/trackingwidgets/eat_pass_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> boxTitles = ['High Protein', 'Chicken', 'Keto'];
    final List<Color> boxColors = [Colors.green, Colors.blue, Colors.orange];
    const double horizontalPadding = 16.0;
    const double verticalPadding = 8.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: verticalPadding),
              Padding(
                padding: EdgeInsets.only(bottom: verticalPadding),
                child: Text(
                  'Eat Pass',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
              ),
              EatPassCard(), // Include the EatPassCard widget here
              SizedBox(height: verticalPadding),
              Padding(
                padding: EdgeInsets.only(bottom: verticalPadding),
                child: Text(
                  'Personalized Menus',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
              ),
              SizedBox(height: verticalPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  boxTitles.length,
                  (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: VerticalCard(
                        title: boxTitles[index],
                        onPressed: () {},
                        color: boxColors[index],
                        height: 200.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: verticalPadding),
              Padding(
                padding: EdgeInsets.only(bottom: verticalPadding),
                child: Text(
                  'Your Menus',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data?.data() as Map<String, dynamic>?;
                  final List<dynamic> menulists = data?['menulists'] as List<dynamic>? ?? [];

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: menulists.length,
                    itemBuilder: (context, index) {
                      final menulist = menulists[index] as Map<String, dynamic>;
                      return MenuPlaylist(
                        menulist: menulist,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: verticalPadding),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }
}
