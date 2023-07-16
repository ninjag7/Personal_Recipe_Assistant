import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    //
    if (_database != null) return _database!;

    _database = await _initDB('objects.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE objects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        image TEXT,
        percentage DOUBLE,
        date TEXT
      )
    ''');
  }

  Future<void> insertObject(ObjectData object) async {
    final db = await instance.database;
    await db.insert('objects', object.toMap());
  }

  Future<List<ObjectData>> getObjects() async {
    final db = await instance.database;
    final maps = await db.query('objects');
    return List.generate(maps.length, (i) {
      return ObjectData.fromMap(maps[i]);
    });
  }
}

class ObjectData {
  final int? id;
  final String name;
  final String image;
  final double percentage;
  final String date;

  ObjectData({
    this.id,
    required this.name,
    required this.image,
    required this.percentage,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'percentage': percentage,
      'date': date,
    };
  }

  factory ObjectData.fromMap(Map<String, dynamic> map) {
    return ObjectData(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      percentage: map['percentage'],
      date: map['date'],
    );
  }
}
