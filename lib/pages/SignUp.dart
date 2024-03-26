import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC0DEE5),
      appBar: AppBar(
        backgroundColor: Color(0xFFC0DEE5),
      ),
      body: SignUpBody(),
    );
  }
}

class SignUpBody extends StatefulWidget {
  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

  // Creating a document for the user with the UID as the document ID
      await FirebaseFirestore.instance
          .collection('Favourites')
          .doc(userCredential.user?.uid)
          .set({
        // Initialize any data you want to have upon signup, for example:
        'Location': [],
        'Email': emailController.text, // Storing email if necessary
        // 'Name': nameController.text // Storing name if provided
      });
      
      print("Sign up successful: ${userCredential.user?.email}");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sign Up Successful!'),
            content: const Text('You have successfully signed up.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // If signup fails, handle the exception.
      String msg = e.message.toString();
      print("Sign up failed: ${e.message}");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign Up Failed: $msg"),
            content: Text('Please try again'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.start, // Align items to the start of the column
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 30.0), // Add padding at the top for the logo
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
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical:
                    20.0), // Adjust padding for the text fields and space below the text
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    icon: Icon(Icons.person),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: signUp,
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
