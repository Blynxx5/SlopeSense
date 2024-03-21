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
              itemCount: locationNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(locationNames[index]),
                  onTap: () => onLocationSelected(locationNames[index]), // Use the callback
                );
              },
            ),
    );
  }
}

