import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eatery/widgets/custom_text_field.dart'; // Confirm this is the correct path

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  TextEditingController _bodyFatController = TextEditingController();
  TextEditingController _activityController = TextEditingController();
  TextEditingController _exerciseController = TextEditingController();
  TextEditingController _cardioController = TextEditingController();
  TextEditingController _liftingController = TextEditingController();
  TextEditingController _subscriptionController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _privacyController = TextEditingController();
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
        title: Text('Edit Profile'),
        elevation: 0, //removes shadow
        backgroundColor:
            Colors.transparent, // Make the AppBar background transparent
      ),
      body: Column(
        children: [
          SizedBox(height: 10), // Added space between app bar and tabs
          _buildFloatingMenuBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                _buildGeneralTab(),
                _buildGoalDataTab(),
                _buildAccountTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingMenuBar() {
    // Use Theme.of(context).scaffoldBackgroundColor to match the color of your scaffold
    return Container(
      color: Theme.of(context)
          .scaffoldBackgroundColor, // Match the background color with the scaffold
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMenuItem('General', 0),
          _buildMenuItem('Goal Data', 1),
          _buildMenuItem('Account', 2),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 16, // Adjusted font size for better visibility
        ),
      ),
    );
  }

  Widget _buildGeneralTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        CustomTextField(label: "First Name", controller: _firstNameController),
        SizedBox(height: 20), // Increased spacing between text fields
        CustomTextField(label: "Last Name", controller: _lastNameController),
        SizedBox(height: 20),
        CustomTextField(label: "Email", controller: _emailController),
        SizedBox(height: 20),
        CustomTextField(label: "Birthday", controller: _birthdayController),
        SizedBox(height: 20),
        CustomTextField(label: "Height", controller: _heightController),
        SizedBox(height: 20),
        CustomTextField(label: "Weight", controller: _weightController),
        SizedBox(height: 20),
        CustomTextField(label: "Gender", controller: _sexController),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGoalDataTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        CustomTextField(label: "Body Fat", controller: _bodyFatController),
        SizedBox(height: 20),
        CustomTextField(label: "Activity", controller: _activityController),
        SizedBox(height: 20),
        CustomTextField(label: "Exercise", controller: _exerciseController),
        SizedBox(height: 20),
        CustomTextField(label: "Cardio", controller: _cardioController),
        SizedBox(height: 20),
        CustomTextField(label: "Lifting", controller: _liftingController),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAccountTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        CustomTextField(
            label: "Subscription", controller: _subscriptionController),
        SizedBox(height: 20),
        CustomTextField(label: "Password", controller: _passwordController),
        SizedBox(height: 20),
        CustomTextField(
            label: "Data & Privacy", controller: _privacyController),
        SizedBox(height: 20),
        ListTile(
          title: Text('Sign Out'),
          onTap: () {
            // Handle sign out
          },
        ),
      ],
    );
  }
}
