import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatery/meal_model.dart'; // Confirm the path is correct

class CreateMenulistPage extends StatefulWidget {
  final Meal mealToInclude; // Required parameter for including meal details

  const CreateMenulistPage({Key? key, required this.mealToInclude}) : super(key: key);

  @override
  _CreateMenulistPageState createState() => _CreateMenulistPageState();
}

class _CreateMenulistPageState extends State<CreateMenulistPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';

  Future<void> _createMenulist() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

        // Generate a unique ID for the menulist
        String menulistId = FirebaseFirestore.instance.collection('dummy').doc().id;

        Map<String, dynamic> mealData = {
          'calories': widget.mealToInclude.calories,
          'dateTracked': widget.mealToInclude.dateTracked,
          'item name': widget.mealToInclude.name,
          'price': widget.mealToInclude.price,
          'protein': widget.mealToInclude.protein,
          'restaurant': widget.mealToInclude.restaurant,
        };

        Map<String, dynamic> menulistData = {
          'id': menulistId,
          'name': _name,
          'description': _description,
          'meals': [mealData],
        };

        await userDocRef.update({
          'menulists': FieldValue.arrayUnion([menulistData]),
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Menulist created successfully!')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Menulist'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createMenulist,
                child: Text('Create Menulist'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
