import 'package:flutter/material.dart';
import 'package:slopesense/pages/Home.dart';
import 'package:slopesense/pages/Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Login(),
    );
  }
}