import 'package:flutter/material.dart';
import 'package:slopesense/pages/Home.dart';
import 'package:slopesense/pages/SignUp.dart'; 

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
            icon: Icon(Icons.person),
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
          onPressed: () {
            // Perform login or save data logic here
             print('Email: $email');
             print('Password: $password');

            
            // Check if username and password are valid, then navigate to the HomePage
            if (isValidLogin(email, password)) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()), // Replace SecondPage with the desired page
              );
            } else {
              // Handle invalid login
              print('Invalid login');
            }
          },
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
    // Example function to check if login is valid (replace with your logic)
  bool isValidLogin(String username, String password) {
    // Add your login validation logic here
    // For demonstration purposes, accept any non-empty username and password
    return username.isNotEmpty && password.isNotEmpty;
  }
}