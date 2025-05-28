import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exam_project/viewmodels/place_viewmodel.dart';
import 'package:exam_project/views/screens/details_screen.dart';

class FavouritePlacesScreen extends StatelessWidget {
  const FavouritePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PlaceViewmodel>(context);
    final favourites = viewModel.favouritePlaces;

    return Scaffold(
      appBar: AppBar(title: const Text("Favourite Places")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10,
            crossAxisSpacing: 14,
            crossAxisCount: 2,
            childAspectRatio: 0.68,
          ),
          itemCount: favourites.length,
          itemBuilder: (context, index) {
            final place = favourites[index];
            return GestureDetector(
              onTap: () {
                viewModel.setSelectedPlace(place);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DetailsScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            place.images.first,
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(Icons.favorite, color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                    Text(place.title),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        Text(place.location, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        Text("${place.rating}"),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "\$${place.price}/",
                            style: const TextStyle(color: Color(0xFF0D6EFD)),
                          ),
                          const TextSpan(
                            text: "Person",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
