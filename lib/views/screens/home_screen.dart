import 'package:exam_project/viewmodels/place_viewmodel.dart';
import 'package:exam_project/views/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PlaceViewmodel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Popular Places')),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 14,
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: viewModel.places.length,
                  itemBuilder: (context, index) {
                    final place = viewModel.places[index];
                    return GestureDetector(
                      onTap: () {
                        viewModel.setSelectedPlace(place);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: place.id,
                              child: Stack(
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
                                    child: GestureDetector(
                                      onTap: () {
                                        viewModel.toggleFavourite(place);
                                      },
                                      child: Icon(
                                        place.isFavourite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            place.isFavourite
                                                ? Colors.red
                                                : Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(place.title),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined),
                                Text(
                                  place.location,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                Text("${place.rating}"),
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "\$${place.price}/",
                                    style: TextStyle(color: Color(0xFF0D6EFD)),
                                  ),
                                  TextSpan(
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
