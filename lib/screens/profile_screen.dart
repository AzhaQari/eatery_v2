import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';
import 'package:eatery/screens/edit_profile_screen.dart';
import 'package:eatery/widgets/your_eats_widget.dart';
import 'package:eatery/widgets/your_goals_widget.dart';
import 'package:eatery/widgets/your_menus_widget.dart';
import 'package:eatery/widgets/custom_text_field.dart'; // Importing the custom text field

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'John Doe';
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Welcome ${_name.split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 80,
                  backgroundImage:
                      AssetImage('assets/default_profile_image.jpg'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()),
                    );
                  },
                  child: Text('Edit Profile'),
                ),
                SizedBox(height: 40),
                _buildFloatingMenuBar(),
                SizedBox(height: 20),
                _buildPageView(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }

  Widget _buildFloatingMenuBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMenuItem('Your Eats', index: 0),
        _buildMenuItem('Your Goals', index: 1),
        _buildMenuItem('Your Menus', index: 2),
      ],
    );
  }

  Widget _buildMenuItem(String title, {required int index}) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 16, // Adjusted font size for better visibility
          ),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return SizedBox(
      height: 300,
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          YourEatsWidget(), // Replace with actual widget for displaying user's eats
          YourGoalsWidget(), // Replace with actual widget for displaying user's goals
          YourMenusWidget(), // Replace with actual widget for displaying user's menus
        ],
      ),
    );
  }
}
