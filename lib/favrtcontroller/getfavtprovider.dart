import 'package:flutter/cupertino.dart';
import 'package:personalrecipeassistant1/databases/sqflite/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class fvrtProvider with ChangeNotifier {
  Future<List<Map<String, dynamic>>> getFavouritiese() async {
    // get a reference to the database
    Database db = await DatabaseHelper.instance.database;

// db.insert("table", {
//   "id":"awais"
// });
    // raw query
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM favourite WHERE userId=?', ['123']);

    // await db.rawInsert('INSERT INTO favourite ("recipename", "numberofcalories","recipeImage","userId") VALUES("$recipename", "$numberofcalories","$recipeImage","123")');
    // print the results

    // data.addAll(result);
    // for(int i=0;i<data.length;i++){
    //   print(jsonEncode(data[i]));
    //
    // }
    // print(jsonEncode(data[i]));
    // print(data.length);

    // print(data[3]["recipename"]);
    // result.forEach((row) => data.addAll(row));
    // // {_id: 2, name: Mary, age: 32}
    // print(data[""]);
    notifyListeners();
    return result;
  }
}
