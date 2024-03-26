import 'package:flutter/material.dart';
import 'package:slopesense/pages/Home.dart';
import 'package:slopesense/pages/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC0DEE5),
      appBar: AppBar(backgroundColor: Color(0xFFC0DEE5),),
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
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      print('Login successful: ${userCredential.user?.email}');
    } on FirebaseAuthException catch (e) {
      // If login fails, handle the exception.
      print('Login failed: ${e.message}');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Email or password is incorrect'),
            content: const Text('Please try again'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 30.0),
            child: Image.asset(
              '/Users/benlynch/DEV/slopesense/assets/logo/mainLogoClear.png', 
              width: 200,
              height: 100, // Logo Image
            ),
          ),
          const Text(
            'SlopeSense',
            style: TextStyle(
              fontSize: 30, 
              fontWeight: FontWeight.normal,
              color:
                  Colors.black, 
            ),
          ),
          const SizedBox(
              height: 100),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: signIn,
            child: const Text('Login'),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            child: const Text("Don't have an account? Sign up"),
          ),
        ],
      ),
    );
  }
}
