import 'package:flutter/material.dart';
import 'package:slopesense/models/global_favourites.dart';

class Favourites extends StatelessWidget {
  final Function(String) onLocationSelected;

  const Favourites({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> locationNames = GlobalFavouites().locationNames;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: locationNames.isEmpty
          ? Center(child: Text('No favourites added.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: locationNames.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white, // Card background color
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(locationNames[index], style: TextStyle(color: Colors.black)),
                    onTap: () => onLocationSelected(locationNames[index]), // Use the callback
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
