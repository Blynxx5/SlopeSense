import 'package:flutter/material.dart';

class Favourites extends StatelessWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: Center(
        child: Text('This is a simple page view.'),
      ),
    );
  }
}