import 'package:flutter/material.dart';
import 'package:personalrecipeassistant1/test.dart';

class NutritionDetails extends StatelessWidget {
  const NutritionDetails({Key? key}) : super(key: key);

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
                Text('Nutrition Food'),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Otherfood(
                    foodImage: 'card_images/barely.jpg',
                    foodTitle: 'Barely',
                    fooddetail:
                        'Barley is a versatile grain rich in fiber, vitamins, and minerals. It is known to promote healthy digestion, lower cholesterol levels, and regulate blood sugar levels, making it a nutritious choice for a balanced diet.'),
                Otherfood(
                    foodImage: 'card_images/pomegrante.jpg',
                    foodTitle: 'Pomegrante',
                    fooddetail:
                        'Pomegranate is a vibrant fruit packed with antioxidants, vitamins, and minerals. It is known to have anti-inflammatory properties, support heart health, and boost the immune system, making it a beneficial addition to your diet.'),
                Otherfood(
                    foodImage: 'card_images/Fenugreek Leaves.jpg',
                    foodTitle: 'Fenugreek Leaves',
                    fooddetail:
                        ' Fenugreek leaves are commonly used in Pakistani cuisine and are a good source of fiber, iron, and vitamins A and C. They are believed to have medicinal properties, such as improving digestion, reducing inflammation, and regulating blood sugar levels.'),
                Otherfood(
                    foodImage: 'card_images/amaranth.jpg',
                    foodTitle: 'Amaranth',
                    fooddetail:
                        'Amaranth leaves are highly nutritious, containing vitamins A, C, and K, as well as calcium and iron. They are known for their antioxidant properties, support for bone health, and potential to reduce cholesterol levels.'),
                Otherfood(
                    foodImage: 'card_images/gava.jpg',
                    foodTitle: 'Gava',
                    fooddetail:
                        'Guava is a tropical fruit abundant in Pakistan, rich in vitamin C, fiber, and antioxidants. It aids digestion, strengthens the immune system, and promotes healthy skin, making it a refreshing and nutritious choice.'),
                Otherfood(
                    foodImage: 'card_images/sesame seeds.jpg',
                    foodTitle: 'Sesame Seeds',
                    fooddetail:
                        'Sesame seeds are a nutrient-dense food containing healthy fats, fiber, and essential minerals like calcium, iron, and magnesium. They are known for their potential to support heart health, improve bone strength, and provide a good source of plant-based protein.'),
              ],
            ),
          )),
    );
  }
}
