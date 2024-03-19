import 'package:flutter/material.dart';
import 'package:eatery/widgets/bottom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'John Doe';
  double _weight = 70; // weight in kg
  double _weeklyBudget = 100; // weekly budget in dollars
  double _goalWeight = 65; // goal weight in kg
  String _age = '30';
  String _gender = 'Male';
  String _weightUnit = 'kg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileField(
              label: 'Name',
              value: _name,
              onTap: () {
                _navigateToEditScreen(context, 'Name');
              },
            ),
            ProfileField(
              label: 'Weight (${_weightUnit})',
              value: _weight.toStringAsFixed(1),
              onTap: () {
                _navigateToEditScreen(context, 'Weight');
              },
              trailing: IconButton(
                icon: Icon(Icons.swap_horiz),
                onPressed: () {
                  setState(() {
                    _toggleWeightUnit();
                  });
                },
              ),
            ),
            ProfileField(
              label: 'Weekly Budget (\$)',
              value: _weeklyBudget.toStringAsFixed(2),
              onTap: () {
                _navigateToEditScreen(context, 'Weekly Budget');
              },
            ),
            ProfileField(
              label: 'Goal Weight (${_weightUnit})',
              value: _goalWeight.toStringAsFixed(1),
              onTap: () {
                _navigateToEditScreen(context, 'Goal Weight');
              },
              trailing: IconButton(
                icon: Icon(Icons.swap_horiz),
                onPressed: () {
                  setState(() {
                    _toggleWeightUnit();
                  });
                },
              ),
            ),
            ProfileField(
              label: 'Age',
              value: _age,
              onTap: () {
                _navigateToEditScreen(context, 'Age');
              },
            ),
            ProfileField(
              label: 'Gender',
              value: _gender,
              onTap: () {
                _navigateToGenderSelection(context);
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle save functionality here if needed
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(), // Add the bottom app bar
    );
  }

  void _navigateToEditScreen(BuildContext context, String field) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          field: field,
          initialValue: _getFieldValue(field),
        ),
      ),
    ).then((updatedValue) {
      if (updatedValue != null) {
        setState(() {
          _updateFieldValue(field, updatedValue);
        });
      }
    });
  }

  String _getFieldValue(String field) {
    switch (field) {
      case 'Name':
        return _name;
      case 'Weight':
        return _weight.toStringAsFixed(1);
      case 'Weekly Budget':
        return _weeklyBudget.toStringAsFixed(2);
      case 'Goal Weight':
        return _goalWeight.toStringAsFixed(1);
      case 'Age':
        return _age;
      default:
        return '';
    }
  }

  void _updateFieldValue(String field, String updatedValue) {
    switch (field) {
      case 'Name':
        _name = updatedValue;
        break;
      case 'Weight':
        _weight = double.parse(updatedValue);
        break;
      case 'Weekly Budget':
        _weeklyBudget = double.parse(updatedValue);
        break;
      case 'Goal Weight':
        _goalWeight = double.parse(updatedValue);
        break;
      case 'Age':
        _age = updatedValue;
        break;
    }
  }

  void _navigateToGenderSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Select Gender')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _gender = 'Male';
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Male'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _gender = 'Female';
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Female'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleWeightUnit() {
    setState(() {
      if (_weightUnit == 'kg') {
        _weight = _convertToPounds(_weight);
        _goalWeight = _convertToPounds(_goalWeight);
        _weightUnit = 'lb';
      } else {
        _weight = _convertToKilograms(_weight);
        _goalWeight = _convertToKilograms(_goalWeight);
        _weightUnit = 'kg';
      }
    });
  }

  double _convertToPounds(double weightInKg) {
    return weightInKg * 2.20462;
  }

  double _convertToKilograms(double weightInLb) {
    return weightInLb / 2.20462;
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;

  const ProfileField({
    Key? key,
    required this.label,
    required this.value,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          title: Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(value),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          trailing: Icon(Icons.edit),
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String field;
  final String initialValue;

  const EditProfileScreen({
    Key? key,
    required this.field,
    required this.initialValue,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.field}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter new ${widget.field.toLowerCase()}',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _controller.text);
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
