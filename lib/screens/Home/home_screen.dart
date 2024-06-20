import 'package:flutter/material.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';
import 'package:eatery/widgets/vertical_card.dart';
import 'package:eatery/widgets/menu_playlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatery/theme.dart'; // Ensure this path is correct

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> boxTitles = ['High Protein', 'Chicken', 'Keto'];
    final List<Color> boxColors = [Colors.green, Colors.blue, Colors.orange];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 4.0),
              child: Text(
                'Eat Pass',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  // Handle Eat Pass button tap
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 32 - 12,
                  height: 160.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Eat Pass',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0.0, 4.0),
              child: Text(
                'Personalized Menus',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  boxTitles.length,
                  (index) => Container(
                    width: (MediaQuery.of(context).size.width - 32 - 12) / 3,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 4.0),
              child: Text(
                'Your Menus',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: StreamBuilder<DocumentSnapshot>(
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
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }
}
