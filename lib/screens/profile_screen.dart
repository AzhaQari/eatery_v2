import 'package:flutter/material.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'John Doe';
  String _age = '30';
  String _gender = 'Male';
  int _selectedIndex = 0;
  PageController _pageController = PageController();

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
                    fontSize: 24, // Increased font size
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
                        builder: (context) => EditProfileScreen(),
                      ),
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
        _buildMenuItem('Your Menus', index: 2), // Changed to 'Your Menus'
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
            color: isSelected
                ? Colors.black
                : Colors.grey, // Change text color based on selection
            fontWeight: FontWeight.bold,
            fontSize:
                isSelected ? 18 : 16, // Change font size based on selection
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
          // Your Eats section
          Container(
            color: Colors.green,
            child: Center(
              child: Text(
                'Your Eats',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Your Goals section
          Container(
            color: Colors.orange,
            child: Center(
              child: Text(
                'Your Goals',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Your Menus section
          Container(
            color: Colors.purple,
            child: Center(
              child: Text(
                'Your Menus',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _bodyFatController = TextEditingController();
  TextEditingController _activityController = TextEditingController();
  TextEditingController _exerciseController = TextEditingController();
  TextEditingController _cardioController = TextEditingController();
  TextEditingController _liftingController = TextEditingController();
  TextEditingController _subscriptionController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _dataPrivacyController = TextEditingController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFloatingMenuBar(),
          Expanded(
            child: _buildPageView(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingMenuBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMenuItem('General', index: 0),
        _buildMenuItem('Goal Data', index: 1),
        _buildMenuItem('Account', index: 2),
      ],
    );
  }

  Widget _buildMenuItem(String title, {required int index}) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: isSelected ? 18 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileTextField('Name', _nameController),
            _buildProfileTextField('Email', _emailController),
            _buildProfileTextField('Birthday', _birthdayController),
            _buildProfileTextField('Sex', _sexController),
            _buildProfileTextField('Height', _heightController),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileTextField('Body Fat', _bodyFatController),
            _buildProfileTextField('Activity', _activityController),
            _buildProfileTextField('Exercise', _exerciseController),
            _buildProfileTextField('Cardio', _cardioController),
            _buildProfileTextField('Lifting', _liftingController),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileTextField('Subscription', _subscriptionController),
            _buildProfileTextField('Password', _passwordController),
            _buildProfileTextField('Data & Privacy', _dataPrivacyController),
            _buildProfileTextField('Sign Out',
                TextEditingController()), // Placeholder for Sign Out
          ],
        );
      default:
        return SizedBox(); // Return empty container if index is out of bounds
    }
  }

  Widget _buildProfileTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
