import 'package:flutter/material.dart';
import 'package:personalrecipeassistant1/databases/sqflite/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class Favorite extends StatefulWidget {
  final List<String> favoriteRecipes;
  final List<String> recipename;
  final List<int> numberofcalories;
  final List<String> recipeImage;

  const Favorite({
    Key? key,
    required this.favoriteRecipes,
    required this.recipename,
    required this.numberofcalories,
    required this.recipeImage,
  }) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  Future<void> getFavorites() async {
    // get a reference to the database
    Database db = await DatabaseHelper.instance.database;

    // raw query
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM favourite WHERE userId=?', ['123']);

    setState(() {
      data.addAll(result);
    });
  }

  Future<void> removeFromFavorites(int index) async {
    // get a reference to the database
    Database db = await DatabaseHelper.instance.database;

    // delete the recipe from the database
    await db.delete('favourite',
        where: 'recipename = ? AND userId = ?',
        whereArgs: [data[index]['recipename'], '123']);

    setState(() {
      data.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE94240),
        title: const Text('Favorite Recipes'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final recipeName = data[index]["recipename"];
          final recipeCalories = data[index]["numberofcalories"];
          final recipeImage = data[index]["recipeImage"];
          return GestureDetector(
            onTap: () {},
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image(
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      image: AssetImage(data[index]["recipeImage"]),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index]["recipename"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text('Calories: ',
                                  style: TextStyle(color: Colors.grey)),
                              Text(
                                data[index]["numberofcalories"],
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeFromFavorites(index),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
