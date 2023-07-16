import 'package:flutter/material.dart';
import 'package:personalrecipeassistant1/test.dart';
class ProteinDetails extends StatelessWidget {
  const ProteinDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffd8d83f),
            title:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Icon(Icons.restaurant_menu),
    SizedBox(width: 5),
    Text('Protein Food'),
    ],
    ),),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Otherfood(foodImage: 'card_images/cottage cheese.jpeg', foodTitle: 'Cottage Cheese', fooddetail: 'Cottage cheese, or paneer, is a popular protein-rich food in Pakistan. It is low in fat and high in protein, calcium, and phosphorus, making it an excellent choice for vegetarians and lacto-vegetarians.'),
                Otherfood(foodImage: 'card_images/fish.jpg', foodTitle: 'Fish', fooddetail: 'Pakistan has a coastline and is abundant in various fish species. Fish like trout, pomfret, and catfish are excellent sources of protein and omega-3 fatty acids, promoting heart health and overall well-being.'),
                Otherfood(foodImage: 'card_images/egg.jpg', foodTitle: 'Egg', fooddetail: 'Eggs are a versatile and affordable protein option. They are packed with essential amino acids and other nutrients like vitamin B12 and selenium, supporting muscle growth, brain function, and immune health.'),
                Otherfood(foodImage: 'card_images/chicken.jpg', foodTitle: 'Chicken', fooddetail: 'Chicken is a popular source of lean protein in Pakistan. It is versatile and can be prepared in various ways, providing essential amino acids for muscle growth and repair.'),
                Otherfood(foodImage: 'card_images/beef.jpg', foodTitle: 'Beef', fooddetail: 'Beef is a widely consumed protein source in Pakistan. It is rich in essential amino acids, iron, and other minerals, making it beneficial for muscle development and overall health.'),
              ],
            ),
          )
      ),
    );
  }
}
