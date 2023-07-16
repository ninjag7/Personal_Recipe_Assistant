import 'package:flutter/material.dart';
import 'package:personalrecipeassistant1/Card/Dietrayitem.dart';
import 'package:personalrecipeassistant1/Card/Nutritionitem.dart';
import 'package:personalrecipeassistant1/Card/dietry%20card.dart';
import 'package:personalrecipeassistant1/Card/protienitem.dart';
import 'package:personalrecipeassistant1/ui/Widgets/breakfast.dart';
import 'package:personalrecipeassistant1/ui/Widgets/dinner.dart';

import 'package:personalrecipeassistant1/ui/Widgets/lunch.dart';
import 'package:personalrecipeassistant1/ui/auth/login.dart';
import 'package:personalrecipeassistant1/ui/pages/favorite.dart';
import 'package:personalrecipeassistant1/Card/homepagecard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  final List<String>? favoriteRecipes;
  final String? username;
  final String? email;
  late String? prefName;
  final bool? manualLogin;

  HomePage({
    Key? key,
    this.favoriteRecipes,
    this.username,
    this.email,
    this.prefName,
    this.manualLogin = false,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String searchText = '';
  List<String> filteredRecipes = [];
  List<String> allRecipes = [
    'Aalo Palak',
    'Recipe 2',
    'Recipe 3',
    // Add more recipe names here
  ];

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    loadModel();
    getPrefsUsername();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  Future<void> runTextRecognitionOnImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
    );

    // Process the recognitions here (e.g., display the recognized text)
  }

  Future<void> getPrefsUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.prefName = prefs.getString("username");
    print("username${widget.prefName}");
  }

  Future<void> _selectAndProcessImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final selectedImage = File(pickedImage.path);
      setState(() {
        _selectedImage = selectedImage;
      });

      await runTextRecognitionOnImage(selectedImage);
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  void search(String query) {
    setState(() {
      searchText = query;
      filteredRecipes = allRecipes
          .where((recipe) => recipe.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSelectedImage() {
      if (_selectedImage != null) {
        return Image.file(_selectedImage!);
      } else {
        return const Text('No image selected');
      }
    }

    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 50),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xffe94240),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  AppBar(
                    backgroundColor: const Color(0xffe94240),
                    elevation: 0,
                    leading: Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: const EdgeInsets.only(left: 18.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: const Icon(
                              Icons.person,
                              color: Color(0xffe94240),
                            ),
                          ),
                        );
                      },
                    ),
                    title: Container(
                      margin: const EdgeInsets.only(
                          left: 2.0, right: 10.0, top: 8.0, bottom: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextField(
                                onChanged: (value) {
                                  search(value);
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Search for recipes',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              search(searchText);
                              print('button is clicked');
                            },
                            icon: Icon(
                              Icons.search,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xffe94240),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xffe94240),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.manualLogin == true
                            ? widget.prefName.toString()
                            : widget.username.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Center(
                      child: Text(
                        'Logout',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 7),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Other foods',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'lato',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DietaryDetails(),
                            ),
                          );
                        },
                        child: const Dietary(
                          thumbimage: 'images/dietry.jpg',
                          description:
                              'Dietary food is specifically chosen or prepared to meet certain dietary requirements.',
                          title: 'Dietary food',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NutritionDetails(),
                            ),
                          );
                        },
                        child: const Dietary(
                          thumbimage: 'images/nutrition.jpg',
                          description:
                              'Nutrition food refers to consuming food that is designed to promote health and well-being.',
                          title: 'Nutrition food',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProteinDetails(),
                            ),
                          );
                        },
                        child: const Dietary(
                          thumbimage: 'images/protien.jpeg',
                          description:
                              'Protein food refers to any type of food that is a significant source of dietary protein.',
                          title: 'Protein food',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'lato',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BreakfastCard(),
                        ),
                      );
                    },
                    child: const RecipeCard1(
                      cookTime: "12",
                      rating: "4.0",
                      thumbnail: 'images/breakfast dishes.jpg',
                      title: 'Breakfast',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LunchCard(),
                        ),
                      );
                    },
                    child: const RecipeCard1(
                      cookTime: "30",
                      rating: "4.0",
                      thumbnail: 'images/lunch dishes.jpg',
                      title: 'Lunch',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DinnerCard(),
                        ),
                      );
                    },
                    child: const RecipeCard1(
                      cookTime: '20',
                      rating: '5.0',
                      thumbnail: 'images/dinner dishes.jpg',
                      title: 'Dinner',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Display the selected image
                buildSelectedImage(),
              ],
            ),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xfffafafa),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xffe94240),
              unselectedItemColor: Colors.black54,
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() => _selectedIndex = index);
                if (index == 2) {
                  _selectAndProcessImage();
                } else if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Favorite(
                        favoriteRecipes: widget.favoriteRecipes ?? [],
                        recipename: const [], // Add your recipename list here
                        numberofcalories: const [], // Add your numberofcalories list here
                        recipeImage: const [], // Add your recipeImage list here
                      ),
                    ),
                  );
                }
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: GestureDetector(
                      onTap: () {
                        print('Home button pressed');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.home),
                          const SizedBox(height: 2),
                          Container(
                            child: const Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: SizedBox
                      .shrink(), // Empty space to align home button to the left
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(
                          0xffe94240), // Customize the circular background color as needed
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.image),
                      color: Colors.white,
                      iconSize: 30,
                      onPressed: _selectAndProcessImage,
                    ),
                  ),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: SizedBox
                      .shrink(), // Empty space to align favorite button to the right
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Favorite(
                              favoriteRecipes: widget.favoriteRecipes ?? [],
                              recipename: const [], // Add your recipename list here
                              numberofcalories: const [], // Add your numberofcalories list here
                              recipeImage: const [], // Add your recipeImage list here
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite),
                          const SizedBox(height: 2),
                          Container(
                            child: const Text(
                              'Favorites',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  label: '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
