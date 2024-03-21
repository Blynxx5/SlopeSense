class GlobalFavouites {
  static final GlobalFavouites _instance = GlobalFavouites._internal();

  // Change to a list of strings to hold multiple location names
  List<String> locationNames = [];

  factory GlobalFavouites() {
    return _instance;
  }

  GlobalFavouites._internal();
}
