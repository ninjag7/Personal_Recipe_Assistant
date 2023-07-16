import 'package:flutter/material.dart';

class RecipeWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String calories;
  final String ingredients;
  final bool isFavorite;
  final Function(bool) onFavoriteChanged;

  const RecipeWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.calories,
    required this.ingredients,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500, // Adjust the height according to your needs
      child: Stack(
        children: [
          // Image at the top
          SizedBox(
            height: 350,
            width: double.infinity,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
          // Container overlapping the image
          Positioned(
            top: 330,
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // AppBar with large text
                  AppBar(
                    title: Text(
                      title,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  // Stars (given by the user)
                  // Replace this with your own star rating widget
                  const Text('Stars: [Stars Widget]'),
                  // Calories details
                  Text('Calories: $calories'),
                  // Ingredients details
                  Text('Ingredients: $ingredients'),
                  // Description
                  Text(description),
                  // Heart icon button for favorite
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      // Toggle the favorite status
                      onFavoriteChanged(!isFavorite);
                    },
                  ),
                  // Save recipe button (wider than the favorite button)
                  ElevatedButton(
                    onPressed: () {
                      // Save recipe functionality
                    },
                    child: const Text('Save Recipe'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
