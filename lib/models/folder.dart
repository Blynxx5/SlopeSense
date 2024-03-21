class Folder {
  String name;
  List<String> locationNames;

  Folder({required this.name, required this.locationNames});
}

class GlobalFavourites {
  List<Folder> folders = [];
  List<String> locationNames = [];

  static final GlobalFavourites _instance = GlobalFavourites._internal();

  factory GlobalFavourites() {
    return _instance;
  }

  GlobalFavourites._internal();
}
