import 'package:flutter/material.dart';
import 'package:slopesense/pages/Home.dart';
import 'package:slopesense/pages/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  String email = '';
  String password = '';

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If login is successful, navigate to the HomePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      print('Login successful: ${userCredential.user?.email}');
    } on FirebaseAuthException catch (e) {
      // If login fails, handle the exception.
      print('Login failed: ${e.message}');

            showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email or password is incorrect'),
            content: Text('Please try again'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Email',
            icon: Icon(Icons.email),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            icon: Icon(Icons.lock),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: signIn,
          child: Text('Login'),
        ),

        SizedBox(height: 20),
        TextButton(
          onPressed: () {
            // Navigate to the sign-up page
            // Replace SignUpPage() with your actual sign-up page class
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
          child: Text("Don't have an account? Sign up"),
        ),
      ],
    );
  }
}
