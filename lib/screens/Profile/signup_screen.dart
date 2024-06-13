import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatery/main.dart';  // Ensure the appropriate navigation paths and theme setup are here.
import 'package:eatery/theme.dart'; // Ensure this contains your darkTheme or any theme data.

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String errorMessage = '';

Future<void> _registerUser() async {
  if (passwordController.text != confirmPasswordController.text) {
    setState(() {
      errorMessage = "Passwords do not match";
    });
    return;
  }

  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Initial structure for a menulist with all fields set up, including an empty array for meals
    Map<String, dynamic> initialMenulist = {
      'name': '',
      'description': '',
      'meals': [
        {
          'calories': null,
          'dateTracked': null,
          'item name': '',
          'price': null,
          'protein': null,
          'restaurant': ''
        }
      ]
    };

    // Add user data to Firestore including the initial menulist structure
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'email': emailController.text.trim(),
      'allTimeProtein': 0,
      'gender': '',
      'dateOfBirth': null,
      'height': null,
      'currentWeight': null,
      'goalWeight': null,
      'activityLevel': '',
      'fitnessGoal': '',
      'budgetPerMeal': null,
      'budgetPerMonth': null,
      'totalSpent': null,
      'trackedMeals': [],
      'menulists': [initialMenulist] // Include the initial menulist structure
    });

    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login after signup
  } catch (e) {
    setState(() {
      errorMessage = "Failed to create user: $e";
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Sign Up", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text("Create your account", style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(hintText: "First Name", prefixIcon: Icon(Icons.person)),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(hintText: "Last Name", prefixIcon: Icon(Icons.person)),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "Email", prefixIcon: Icon(Icons.email)),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Password", prefixIcon: Icon(Icons.lock)),
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Confirm Password", prefixIcon: Icon(Icons.lock)),
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(errorMessage, style: TextStyle(color: Colors.red)),
                  ),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: Text("Sign Up", style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.purple, // Directly use your color here
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  child: Text("Sign In with Google", style: TextStyle(fontSize: 16)),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: Text("Login", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
