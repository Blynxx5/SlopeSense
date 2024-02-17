import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top:30, left:20, right: 20),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200], // Background color
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey), // Hint text color
                prefixIcon: Icon(Icons.search, color: Colors.grey), // Search icon
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
               contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)
              ),
            ),
          )
        ],)
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text('Home Page'),
      leading: GestureDetector(
        onTap: () {
          // Add your action here
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: SvgPicture.asset(
            'assets/icons/chevron-left-svgrepo-com.svg',
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Add your action here
          },
          child: Container(
            margin: EdgeInsets.all(10),
            child: SvgPicture.asset(
              'assets/icons/list-svgrepo-com.svg',
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
