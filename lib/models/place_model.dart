class PlaceModel {
  final int id;
  final String title;
  final String location;
  final double price;
  final double rating;
  bool isFavourite;
  final List<String> images;

  PlaceModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.isFavourite,
    required this.images,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    final List<String> parsedImages =
        (json['images'] as String)
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',')
            .map((e) => e.trim())
            .toList();

    return PlaceModel(
      id: json['id'],  
      title: json['title'],
      location: json['location'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      isFavourite: json['isFavourite'],
      images: parsedImages,
    );
  }
}
