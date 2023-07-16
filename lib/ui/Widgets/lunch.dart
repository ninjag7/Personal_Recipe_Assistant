import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:personalrecipeassistant1/databases/sqflite/database_helper.dart';
import 'package:personalrecipeassistant1/ui/pages/details_lunch.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import the rating bar package

import '../pages/favorite.dart';

class LunchCard extends StatefulWidget {
  const LunchCard({Key? key}) : super(key: key);

  @override
  State<LunchCard> createState() => _LunchCardState();
}

class _LunchCardState extends State<LunchCard> {
  bool checkIfFavorite(String recipeName) {
    return favoriteRecipes.contains(recipeName);
  }

  double userRating = 0.0;
  Map<String, double> userRatingsMap = {
    'Aalo Palak': 0.0,
    'Barbeque': 0.0,
    'Chicken Tikka': 0.0,
    'Vegetable Biryani': 0.0,
    'Chicken Karahi': 0.0,
    'Daal Chawal': 0.0,
    'Haleem': 0.0,
    'Biryani': 0.0,
  };

  void _onRatingChanged(double rating, String recipeName) {
    setState(() {
      userRating = rating; // Update the userRating field
      userRatingsMap[recipeName] =
          rating; // Update the rating in the userRatingsMap
      Navigator.pop(context, rating);
    });
  }

  addFavourite(
      String recipename, String numberofcalories, String recipeImage) async {
    // get a reference to the database
    Database db = await DatabaseHelper.instance.database;

    await db.rawInsert(
        'INSERT INTO favourite ("recipename", "numberofcalories","recipeImage","userId") VALUES("$recipename", "$numberofcalories","$recipeImage","123")');
  }

  List<String> recipename = [
    'Aalo Palak',
    'Barbeque',
    'Chicken Tikka',
    'Vegetable Biryani',
    'Chicken Karahi',
    'Daal Chawal',
    'Haleem',
    'Biryani',
  ];
  List<int> numberofcalories = [
    200,
    250,
    250,
    300,
    400,
    400,
    450,
    500,
  ];
  List<String> recipeImage = [
    'lunch_images/aalo palak 200.jpg',
    'lunch_images/barbie Que 250.jpg',
    'lunch_images/chicken tikka 250.jpg',
    'lunch_images/vegetable biryani 300.jpg',
    'lunch_images/Chicken Karahi 400.jpg',
    'lunch_images/Daal chawal 400.jpg',
    'lunch_images/Haleem 400.jpg',
    'lunch_images/Biryani 500.jpg'
  ];
  List<String> ingredients = [
    'Potatoes' ", " 'Spinach' ", " 'Spices',
    'Meat' ", " 'Onions' ", " 'Spices',
    'Chicken' ", " 'Yougert' ", " 'Spices',
    'Rice' ", " 'Vegetable' ", " 'Spices',
    'Chicken' ", " 'Tomatoes' ", " 'Spices',
    'Lentils' ", " 'Rice' ", " 'Spices',
    'Lentils' ", " 'Wheat' ", " 'Meat' ", " 'Spices',
    'Rice' ", " 'Chicken' ", " 'Spices',
  ];
  List<String> description = [
    'Aloo Palak is a vegetarian dish made with potatoes and spinach cooked together with a blend of spices. It is a nutritious and delicious option, often served with roti or rice.',
    'Barbeque are flavorful grilled or skewered minced meat rolls, seasoned with various spices and cooked to perfection. They are often enjoyed with mint chutney and paratha',
    'Chicken Tikka is a popular dish made with marinated chicken pieces cooked in a tandoor or oven. The chicken is marinated in a mixture of yogurt and spices, which gives it a tangy and flavorful taste.',
    'Vegetable Biryani is a flavorful rice dish made with fragrant basmati rice and a mix of assorted vegetables. The vegetables are typically sautéed and cooked along with aromatic spices, giving the biryani its distinct taste.',
    'Chicken Karahi is a popular Pakistani dish prepared by cooking chicken with tomatoes, ginger-garlic paste, and a blend of spices. It is usually served with naan bread or rice.',
    'Daal Chawal is a staple Pakistani dish consisting of lentils cooked with aromatic spices and served with steamed rice. It is a comforting and wholesome meal enjoyed by many.',
    'Haleem is a slow-cooked, thick stew-like dish made with a combination of lentils, wheat, and tender meat. It is rich in flavors and enjoyed especially during Ramadan and special occasions.',
    'Biryani is a variation of biryani where tender chicken pieces are cooked with fragrant rice and a blend of spices. It is a popular choice for lunch and special occasions.'
  ];
  List<String> favoriteRecipes = [];
  List<double> rating = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
  ]; // Add the ratings for each recipe

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * 0.8;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: recipename.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          double updatedRating = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailPage(
                                recipeName: recipename[index],
                                numberOfCalories: numberofcalories[index],
                                recipeImage: recipeImage[index],
                                ingredients: ingredients[index],
                                description: description[index],
                                userRating:
                                    userRatingsMap[recipename[index]] ?? 0.0,
                                rating: rating[index],
                                userRatingsMap: userRatingsMap,
                              ),
                            ),
                          );
                          setState(() {
                            userRatingsMap[recipename[index]] =
                                updatedRating; // Update the rating in userRatingsMap
                            rating[index] = updatedRating;
                          });
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image(
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      image: AssetImage(recipeImage[index]),
                                    ),
                                    const SizedBox(
                                        width: 20), // Adjusted spacing
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recipename[index],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(height: 5),
                                          const Text('Calories: ',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          Text(
                                              numberofcalories[index]
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          const SizedBox(
                                              height: 7), // Adjusted spac
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(30, 50),
                                              backgroundColor:
                                                  const Color(0xffd8d83f),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (checkIfFavorite(
                                                    recipename[index])) {
                                                  favoriteRecipes.remove(
                                                      recipename[index]);
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Recipe is already exists in favorites');
                                                } else {
                                                  addFavourite(
                                                      recipename[index],
                                                      numberofcalories[index]
                                                          .toString(),
                                                      recipeImage[index]);
                                                  favoriteRecipes
                                                      .add(recipename[index]);
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Recipe added to favorites');
                                                }
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  favoriteRecipes.contains(
                                                          recipename[index])
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color:
                                                      const Color(0xffe94240),
                                                ),
                                                const SizedBox(width: 15),
                                                const Text('Add to Favourite'),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              const Text('Rating: ',
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              Material(
                                                child: RatingBarIndicator(
                                                  rating: userRatingsMap[
                                                      recipename[index]]!,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 20.0,
                                                  unratedColor: Colors.grey,
                                                  direction: Axis.horizontal,
                                                ),
                                              ),
                                              Text(
                                                  '${userRatingsMap[recipename[index]]}',
                                                  style: const TextStyle(
                                                      color: Colors.grey)),
                                              const SizedBox(width: 10),
                                              Text(
                                                '(${userRatingsMap[recipename[index]]?.toStringAsFixed(1)})',
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Favorite(
                                  favoriteRecipes: favoriteRecipes,
                                  recipename: recipename,
                                  numberofcalories: numberofcalories,
                                  recipeImage: recipeImage)));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xffe94240))),
                    child: Container(
                        height: 50,
                        color: const Color(0xffe94240),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'View Favourites',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )))
              ],
            );
          },
        ),
      ),
    );
  }
}
