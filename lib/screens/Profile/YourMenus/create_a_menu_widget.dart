import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateMenulistPage extends StatefulWidget {
  @override
  _CreateMenulistPageState createState() => _CreateMenulistPageState();
}

class _CreateMenulistPageState extends State<CreateMenulistPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';

  // Function to create a new menulist
  Future<void> _createMenulist() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).collection('menulists').add({
          'name': _name,
          'description': _description,
          'meals': [],
        });
        Navigator.pop(context); // Optionally close the screen after saving
      }
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
                onSaved: (value) => _name = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
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
