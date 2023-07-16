import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:personalrecipeassistant1/databases/sqflite/database_helper.dart';
import 'package:personalrecipeassistant1/ui/pages/details_breakfast.dart';

import 'package:sqflite/sqflite.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import the rating bar package

import '../pages/favorite.dart';

class DinnerCard extends StatefulWidget {
  const DinnerCard({Key? key}) : super(key: key);

  @override
  State<DinnerCard> createState() => _DinnerCardState();
}

class _DinnerCardState extends State<DinnerCard> {
  bool checkIfFavorite(String recipeName) {
    return favoriteRecipes.contains(recipeName);
  }

  double userRating = 0.0;
  Map<String, double> userRatingsMap = {
    'Daal Fry': 0.0,
    'Palak Paneer': 0.0,
    'Paneer Bhurji': 0.0,
    'Tandoori Fish': 0.0,
    'Chapli Kabab': 0.0,
    'Aaloo gosht': 0.0,
    'Beef Biryani': 0.0,
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
    'Daal Fry',
    'Palak Paneer',
    'Paneer Bhurji',
    'Tandoori Fish',
    'Chapli Kabab',
    'Aaloo gosht',
    'Beef Biryani'
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
    'dinner_images/Daal Fry 250.jpg',
    'dinner_images/palak paneer 300.jpg',
    'dinner_images/paneer bhurji 300.jpg',
    'dinner_images/tandoori fish 300.jpg',
    'dinner_images/Chapli Kabab 300.jpg',
    'dinner_images/aaloo gosht 350.jpg',
    'dinner_images/beef biryani 400.jpg',
  ];
  List<String> ingredients = [
    'Lentils' ", " 'Onions' ", " 'Spices',
    'Spinach' ", " 'Panner' ", " 'Onions' ", " 'Spices',
    'Paneer' ", " 'Onions' ", " 'Tomatoes',
    'Fish fillets' ", " 'tandoori masala' ", " 'yogurt',
    'Ground meat' ", " 'Onions' ", " 'Tomatoes' ", " 'Spices',
    'Meat' ", " 'Potatoes' ", " 'Onions' ", " 'Spices',
    'Meat' ", " 'Rice' ", " 'Onions' ", " 'Spices'
  ];
  List<String> description = [
    'Daal Fry is a comforting and nutritious Pakistani lentil dish. Boil lentils until tender and set aside. In a separate pan, sauté finely chopped onions until golden brown. Add spices such as cumin, turmeric, and red chili powder. Mix in the boiled lentils and simmer for a few minutes to let the flavors meld together. Serve with rice or naan bread for a wholesome and satisfying dinner.',
    'Palak Paneer is a popular vegetarian dish in Pakistan, made with fresh spinach and soft paneer cheese. It is a nutritious and flavorful curry that pairs well with roti or rice.',
    'Paneer Bhurji is a popular vegetarian dish in Pakistan. Crumble paneer and set aside. Sauté finely chopped onions until golden brown. Add chopped tomatoes and cook until they soften. Mix in the crumbled paneer and season with spices like cumin, turmeric, and red chili powder. Cook for a few more minutes until well combined. Serve hot with roti or paratha for a delicious and protein-packed dinner.',
    'Tandoori Fish is a delicious Pakistani seafood dish. Marinate fish fillets with tandoori masala and yogurt for a few hours to enhance the flavors. Grill, bake, or pan-fry the fish until it is cooked and has a slightly smoky and charred exterior. Serve with mint chutney and a side of salad for a tasty and protein-rich dinner.',
    'Chapli Kebab is a famous Pakistani kebab made from spiced ground meat, shaped into patties, and pan-fried until crispy. It is known for its distinctive flavors and is often served with naan bread and raita.',
    'Aloo Gosht is a classic Pakistani meat curry made with tender lamb or goat meat cooked with potatoes in a rich and aromatic gravy. It is commonly enjoyed with rice or naan bread.',
    'Beef Biryani is a flavorful and aromatic Pakistani rice dish. Cook beef with biryani spice mix until tender and set aside. Parboil basmati rice and layer it with the cooked beef in a pot. Seal the pot with a tight-fitting lid and cook on low heat until the rice is fully cooked and infused with the flavors of the beef and spices. Serve the Beef Biryani hot with raita or a side salad for a satisfying and complete meal.'
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
    return Scaffold(
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
                        //
                        double? updatedRating = await Navigator.push(
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
                              updatedRating!; // Update the rating in userRatingsMap
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
                                  const SizedBox(width: 20), // Adjusted spacing
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
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        Text(numberofcalories[index].toString(),
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
                                                favoriteRecipes
                                                    .remove(recipename[index]);
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
                                                color: const Color(0xffe94240),
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
                                                itemBuilder: (context, index) =>
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
    );
  }
}
