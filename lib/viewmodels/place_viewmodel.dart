import 'package:exam_project/datasources/place_remote_datasources.dart';
import 'package:flutter/material.dart';
import '../models/place_model.dart';

class PlaceViewmodel with ChangeNotifier {
  final PlaceRemoteDatasources _service = PlaceRemoteDatasources();
  List<PlaceModel> _places = [];
  bool _isLoading = false;

  List<PlaceModel> get places => _places;
  bool get isLoading => _isLoading;

  PlaceModel? _selectedPlace;
  PlaceModel? get selectedPlace => _selectedPlace;

  void setSelectedPlace(PlaceModel place) {
    _selectedPlace = place;
    notifyListeners();
  }

  Future<void> loadPlaces() async {
    _isLoading = true;
    notifyListeners();

    try {
      _places = await _service.fetchPlaces();
    } catch (e) {
      print('Error loading places: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleFavourite(PlaceModel place) {
    place.isFavourite = !place.isFavourite;
    notifyListeners();
  }

  List<PlaceModel> get favouritePlaces =>
      _places.where((p) => p.isFavourite).toList();
}
