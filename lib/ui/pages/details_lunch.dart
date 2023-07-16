import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeName;
  final int numberOfCalories;
  final String recipeImage;
  final String ingredients;
  final String description;
  double userRating;
  double rating;
  Map<String, double> userRatingsMap;

  RecipeDetailPage({
    Key? key,
    required this.recipeName,
    required this.numberOfCalories,
    required this.recipeImage,
    required this.ingredients,
    required this.description,
    required this.userRating,
    required this.rating,
    required this.userRatingsMap,
  }) : super(key: key);

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  double _currentRating = 0.0;
  bool _isRated = false;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.userRating;
    _isRated = _currentRating != 0.0;
  }

  void _onRatingChanged(double rating) {
    setState(() {
      widget.userRating = rating;
      widget.userRatingsMap[widget.recipeName] = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffd8d83f),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu),
              const SizedBox(width: 5),
              Text(widget.recipeName),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .5,
              decoration: BoxDecoration(
                color: Colors.white70,
                image: DecorationImage(
                  image: AssetImage(widget.recipeImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .6,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          offset: const Offset(0, -4),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.white,
                          height: 40,
                          width: double.infinity,
                          child: Text(
                            widget.recipeName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffd8d83f),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Calories: ${widget.numberOfCalories}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ingredients:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffe94240),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.ingredients,
                          style: const TextStyle(color: Colors.black38),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Rate it: ${widget.userRating}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (!_isRated)
                          RatingBar.builder(
                            initialRating: widget.userRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: _onRatingChanged,
                          ),
                        if (_isRated)
                          RatingBarIndicator(
                            rating: _currentRating,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                        const SizedBox(height: 16),
                        const Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffd8d83f),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.description,
                          style: const TextStyle(color: Colors.black26),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          color: const Color(0xffe94240),
                          width: double.infinity,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Note : You can add extra ingredients according to your diets ',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
