import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';

class PlaceRemoteDatasources {
  final String url =
      'https://travel-project-7c3ef-default-rtdb.firebaseio.com/places.json';

  Future<List<PlaceModel>> fetchPlaces() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data.values.map((place) => PlaceModel.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }
}
