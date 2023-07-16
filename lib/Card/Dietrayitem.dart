import 'package:flutter/material.dart';
import 'package:personalrecipeassistant1/test.dart';

class DietaryDetails extends StatelessWidget {
  const DietaryDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xffd8d83f),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu),
                SizedBox(width: 5),
                Text('Dietary Food'),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Otherfood(
                    foodImage: 'card_images/yogurt.jpg',
                    foodTitle: 'Yogurt',
                    fooddetail:
                        'Yogurt is a popular dairy product in Pakistan and is rich in probiotics, calcium, and protein. It aids in digestion, promotes a healthy gut, and can be enjoyed as a refreshing snack or used as a base for savory dishes like Raita.'),
                Otherfood(
                    foodImage: 'card_images/Lentils.jpg',
                    foodTitle: 'Lentils',
                    fooddetail:
                        'Lentils are a staple in Pakistani cuisine and are packed with protein, fiber, and essential minerals. They are a versatile ingredient that can be used in various dishes, providing a nutritious and satisfying addition to your meals.'),
                Otherfood(
                    foodImage: 'card_images/spinash.jpg',
                    foodTitle: 'Spinach',
                    fooddetail:
                        'Spinach is a leafy green vegetable rich in iron, vitamins A, C, and K. It is widely used in Pakistani cooking, and incorporating spinach into your diet can help support healthy digestion, strengthen the immune system, and promote overall well-being.'),
                Otherfood(
                    foodImage: 'card_images/chipeas.jpg',
                    foodTitle: 'Chickpeas',
                    fooddetail:
                        'Chickpeas are a good source of plant-based protein, fiber, and folate. They are commonly used in Pakistani recipes such as Chana Masala and are beneficial for maintaining blood sugar levels and supporting digestive health.'),
                Otherfood(
                    foodImage: 'card_images/whole wheat bread.jpg',
                    foodTitle: 'Whole wheat Bread',
                    fooddetail:
                        'Whole wheat Bread is a traditional flatbread made from whole grain flour. It is a healthier alternative to refined wheat bread and provides complex carbohydrates, fiber, and essential nutrients, making it an integral part of a balanced Pakistani diet.'),
                Otherfood(
                    foodImage: 'card_images/mung beans.jpg',
                    foodTitle: 'Mung Beans',
                    fooddetail:
                        ' Mung beans are a type of legume commonly used in Pakistani cuisine. They are a great source of plant-based protein, dietary fiber, and antioxidants. Including mung beans in your diet can help improve digestion, regulate blood sugar levels, and support weight management'),
              ],
            ),
          )),
    );
  }
}
