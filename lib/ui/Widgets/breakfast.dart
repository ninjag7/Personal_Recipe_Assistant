import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:personalrecipeassistant1/databases/sqflite/database_helper.dart';

import 'package:sqflite/sqflite.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import the rating bar package

import '../pages/favorite.dart';
import '../pages/details_breakfast.dart';

class BreakfastCard extends StatefulWidget {
  const BreakfastCard({Key? key}) : super(key: key);

  @override
  State<BreakfastCard> createState() => _BreakfastCardState();
}

class _BreakfastCardState extends State<BreakfastCard> {
  bool checkIfFavorite(String recipeName) {
    return favoriteRecipes.contains(recipeName);
  }

  double userRating = 0.0;
  Map<String, double> userRatingsMap = {
    'Lassi': 0.0,
    'Anda Bhurji': 0.0,
    'Shakshuka': 0.0,
    'Aalo Pratha': 0.0,
    'Anda Pratha': 0.0,
    'Channa Puri': 0.0,
    'Nehari': 0.0,
    'Halwapuri': 0.0,
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
    'Lassi',
    'Anda Bhurji',
    'Shakshuka',
    'Aalo Pratha',
    'Anda Pratha',
    'Channa Puri',
    'Nehari',
    'Halwapuri'
  ];
  List<int> numberofcalories = [200, 250, 300, 300, 350, 450, 500, 550];
  List<String> recipeImage = [
    'breakfast_images/Lassi.jpg',
    'breakfast_images/anda bhurji.jpg',
    'breakfast_images/shakshuka.jpg',
    'breakfast_images/aalo pratha.jpg',
    'breakfast_images/egg pratha.jpg',
    'breakfast_images/chana pratha.jpg',
    'breakfast_images/nehari.jpg',
    'breakfast_images/halwa puri.jpg'
  ];
  List<String> ingredients = [
    'Yougert' "," 'Sugar' "," 'Ice',
    'Egg' "," 'Onions' "," 'Tomatoes' "," 'Spices',
    'Egg' "," 'Tomatoes' "," 'Onions',
    'Potatoes' "," 'Onions' "," 'Flour' "," 'Spices',
    'Egg' "," 'Flour' "," 'Spices',
    'Chickpeas' "," 'Flour' "," 'Spices',
    'Bone Marrow' "," 'Meat' "," 'Spices',
    'Semolina' "," 'Flour' "," 'sugar',
  ];
  List<String> description = [
    'Lassi is a refreshing and popular beverage in Pakistan. It is made by blending yogurt with sugar, a hint of cardamom, and ice, resulting in a cool and creamy drink that complements breakfast perfectly.',
    'Anda Bhurji is a quick and easy breakfast option. It involves scrambling eggs with finely chopped onions, tomatoes, green chilies, and spices, resulting in a flavorful and protein-rich dish.',
    'Shakshuka is a Middle Eastern breakfast dish that has gained popularity in Pakistan. It consists of poached eggs cooked in a rich tomato-based sauce, infused with onions, bell peppers, and aromatic spices, creating a flavorful and satisfying meal.',
    'Aloo Paratha is a delightful breakfast choice. It features a crisp, golden-brown flatbread filled with a spiced mashed potato mixture, complemented by flavors of onions and green chilies.',
    'Anda Paratha is a popular breakfast item in Pakistan. It consists of a flaky, pan-fried flatbread stuffed with a spicy mixture of beaten eggs, onions, green chilies, and fresh coriander.',
    'Chana Poori is a popular breakfast combo in Pakistan. It consists of deep-fried bread (poori) served with spicy and tangy chickpea curry (chana), garnished with chopped tomatoes and onions.',
    'Nihari is a hearty breakfast dish originating from the Mughlai cuisine. It consists of tender, slow-cooked meat stewed with rich spices, creating a flavorful and aromatic gravy. It is often served with naan or roti.',
    'Halwa Puri is a traditional Pakistani breakfast. It features a sweet and aromatic semolina pudding (halwa) accompanied by deep-fried bread (puri) and served with savory chickpeas, creating a delightful balance of flavors.'
  ];

  List<String> favoriteRecipes = [];
  /* Map<String, double> userRatingsMap = {
        'Lassi': 0.0,
        'Anda Bhurji': 0.0,
        'Shakshuka': 0.0,
        'Aalo Pratha': 0.0,
        'Anda Pratha': 0.0,
        'Channa Puri': 0.0,
        'Nehari': 0.0,
        'Halwapuri': 0.0,
      };*/ // List to store favorite recipes
  //List<double> userRating = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
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
                              builder: (context) => BreakfastDetailPage(
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
