import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';

class _ProfileScreenState extends State<ProfileScreen> {
  List<Meal> trackedMeals = []; // This holds the list of tracked meals
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
                YourGoalsSection(),
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
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: isSelected ? 18 : 16,
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
          Container(
            color: Colors.green,
            child: Center(
              child: Text(
                'Your Eats',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            color: Colors.orange,
            child: Center(
              child: Text(
                'Your Goals',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
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

  Widget _buildProfileTextField(
      String label, TextEditingController controller, TargetPlatform platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: platform == TargetPlatform.iOS
          ? _buildCupertinoTextField(label, controller)
          : _buildMaterialTextField(label, controller),
    );
  }

  Widget _buildMaterialTextField(
      String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCupertinoTextField(
      String label, TextEditingController controller) {
    return CupertinoTextField(
      controller: controller,
      placeholder: label,
    );
  }
}

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
            child: _buildPageView(Theme.of(context).platform),
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

  Widget _buildPageView(TargetPlatform platform) {
    switch (_selectedIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileTextField(
                'First Name', _firstNameController, platform),
            _buildProfileTextField('Last Name', _lastNameController, platform),
            _buildProfileTextField('Email', _emailController, platform),
            _buildProfileDatePicker('Birthday', _birthdayController, platform),
            _buildProfileHeightPicker('Height', _heightController, platform),
            _buildProfileWeightPicker('Weight', _weightController, platform),
            _buildProfileSexPicker(platform),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileTextField(
                'Body Fat', TextEditingController(), platform),
            _buildProfileTextField(
                'Activity', TextEditingController(), platform),
            _buildProfileTextField(
                'Exercise', TextEditingController(), platform),
            _buildProfileTextField('Cardio', TextEditingController(), platform),
            _buildProfileTextField(
                'Lifting', TextEditingController(), platform),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileTextField(
                'Subscription', TextEditingController(), platform),
            _buildProfileTextField(
                'Password', TextEditingController(), platform),
            _buildProfileTextField(
                'Data & Privacy', TextEditingController(), platform),
            _buildProfileTextField('Sign Out', TextEditingController(),
                platform), // Placeholder for Sign Out
          ],
        );
      default:
        return SizedBox(); // Return empty container if index is out of bounds
    }
  }

  Widget _buildProfileTextField(
      String label, TextEditingController controller, TargetPlatform platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: platform == TargetPlatform.iOS
          ? _buildCupertinoTextField(label, controller)
          : _buildMaterialTextField(label, controller),
    );
  }

  Widget _buildMaterialTextField(
      String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCupertinoTextField(
      String label, TextEditingController controller) {
    return CupertinoTextField(
      controller: controller,
      placeholder: label,
    );
  }

  Widget _buildProfileDatePicker(
      String label, TextEditingController controller, TargetPlatform platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: platform == TargetPlatform.iOS
          ? _buildCupertinoDatePicker(label, controller)
          : _buildMaterialDatePicker(label, controller),
    );
  }

  Widget _buildMaterialDatePicker(
      String label, TextEditingController controller) {
    return TextField(
      readOnly: true,
      controller: controller,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          controller.text = pickedDate.toString();
        }
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCupertinoDatePicker(
      String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showCupertinoModalPopup<DateTime>(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime dateTime) {
                  controller.text = dateTime.toString();
                },
              ),
            );
          },
        );
        if (pickedDate != null) {
          controller.text = pickedDate.toString();
        }
      },
      child: AbsorbPointer(
        child: CupertinoTextField(
          controller: controller,
          placeholder: label,
        ),
      ),
    );
  }

  Widget _buildProfileHeightPicker(
      String label, TextEditingController controller, TargetPlatform platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: platform == TargetPlatform.iOS
          ? _buildCupertinoHeightPicker(label, controller)
          : _buildMaterialHeightPicker(label, controller),
    );
  }

  Widget _buildMaterialHeightPicker(
      String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCupertinoHeightPicker(
      String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () {
        // Implement height picker logic for Cupertino
      },
      child: AbsorbPointer(
        child: CupertinoTextField(
          controller: controller,
          placeholder: label,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Widget _buildProfileWeightPicker(
      String label, TextEditingController controller, TargetPlatform platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: platform == TargetPlatform.iOS
          ? _buildCupertinoWeightPicker(label, controller)
          : _buildMaterialWeightPicker(label, controller),
    );
  }

  Widget _buildMaterialWeightPicker(
      String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCupertinoWeightPicker(
      String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () {
        // Implement weight picker logic for Cupertino
      },
      child: AbsorbPointer(
        child: CupertinoTextField(
          controller: controller,
          placeholder: label,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Widget _buildProfileSexPicker(TargetPlatform platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: platform == TargetPlatform.iOS
          ? _buildCupertinoSexPicker()
          : _buildMaterialSexPicker(),
    );
  }

  Widget _buildMaterialSexPicker() {
    return Row(
      children: [
        Text('Sex:'),
        SizedBox(width: 10),
        DropdownButton<String>(
          items: <String>['Male', 'Female'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _sexController.text = value!;
            });
          },
          value: _sexController.text,
        ),
      ],
    );
  }

  Widget _buildCupertinoSexPicker() {
    return GestureDetector(
      onTap: () async {
        List<String> sexes = ['Male', 'Female'];
        final result = await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoPicker(
              itemExtent: 32.0,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _sexController.text = sexes[index];
                });
              },
              children: sexes.map((String sex) {
                return Text(sex);
              }).toList(),
            );
          },
        );
        if (result != null) {
          setState(() {
            _sexController.text = sexes[result];
          });
        }
      },
      child: AbsorbPointer(
        child: CupertinoTextField(
          controller: _sexController,
          placeholder: 'Select Gender',
        ),
      ),
    );
  }
}

class YourProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'placeholder',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'weight',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              // Implement action when 'show more' is pressed
            },
            child: Text(
              'Show More',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}

class YourBudgetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Budget',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'placeholder',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'budget',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              // Implement action when 'show more' is pressed
            },
            child: Text(
              'Show More',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}

class YourGoalsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Your Budget',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        YourBudgetWidget(),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Your Progress',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        YourProgressWidget(),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
