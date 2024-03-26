import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favourites extends StatelessWidget {
  final Function(String) onLocationSelected;

  const Favourites({Key? key, required this.onLocationSelected})
      : super(key: key);

  Future<List<String>> fetchFavouriteLocations() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Must be logged in to view favourites');
    }
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Favourites')
        .doc(currentUser.uid)
        .get();

    if (userDoc.exists && userDoc.data() is Map) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      List<String> locations = List.from(data['Location'] ?? []);
      return locations;
    } else {
      return []; // Return an empty list if there are no favourites
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC0DEE5),
      appBar: AppBar(
        backgroundColor: Color(0xFFC0DEE5),
        title: Text('Favourites'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchFavouriteLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching favourites.'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(child: Text('No favourites added.'));
          } else if (snapshot.hasData) {
            List<String> locationNames = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: locationNames.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(locationNames[index],
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      onLocationSelected(locationNames[index]);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            );
          } else {
            // In case none of the above conditions are met
            return Center(child: Text('Unexpected error.'));
          }
        },
      ),
    );
  }
}
