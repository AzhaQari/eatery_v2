import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddToMenuWidget extends StatefulWidget {
  @override
  _AddToMenuWidgetState createState() => _AddToMenuWidgetState();
}

class _AddToMenuWidgetState extends State<AddToMenuWidget> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  List<String> menulists = []; // This will hold the names of the menulists

  @override
  void initState() {
    super.initState();
    fetchMenulists();
  }

  void fetchMenulists() async {
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('menulists')
          .get();
      final List<String> loadedMenulists = [];
      for (var doc in snapshot.docs) {
        var data = doc.data();
        // Ensure that the data contains 'name' and it is a String
        if (data.containsKey('name') && data['name'] is String) {
          loadedMenulists.add(data['name']);
        }
      }
      setState(() {
        menulists = loadedMenulists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Menulist'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to create a new menulist
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Find playlist',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: menulists.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(menulists[index]),
                      trailing: Icon(Icons.radio_button_unchecked),
                      onTap: () {
                        // Logic to add meal to selected menulist
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
