import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "patoosh.db";
  static final _databaseVersion = 1;
  static final table = 'cart';

  static final columnId = 'id';
  static final columnFoodName = 'name';
  static final columnFoodPrice = 'price';
  static final columnDeliveryFee = 'deliveryFee';
  static final columnPackageAmount = 'packageAmount';
  static final columnServiceFee = 'serviceFee';
  static final columnFoodDescription = 'description';
  static final columnFoodImageUrl = 'imageUrl';
  static final columnFoodStatus = 'status';
  static final columnFoodCategory = 'category';
  static final columnFoodCreatedAt = 'createdAt';
  static final columnWaitingTime = 'waitingTime';
  static final columnQty = 'quantity';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    _database = await _initDatabase();
    return _database;
    // lazily instantiate the db the first time it is accessed
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId TEXT PRIMARY KEY,
            $columnFoodName TEXT NOT NULL,
            $columnFoodPrice TEXT NOT NULL,
            $columnDeliveryFee TEXT NOT NULL,
            $columnPackageAmount TEXT NOT NULL,
            $columnServiceFee TEXT NOT NULL,
            $columnFoodDescription TEXT NOT NULL,
            $columnFoodImageUrl TEXT NOT NULL,
            $columnFoodStatus TEXT NOT NULL,
            $columnFoodCategory TEXT NOT NULL,
            $columnFoodCreatedAt TEXT NOT NULL,
            $columnWaitingTime TEXT NOT NULL,
            $columnQty INTEGER NOT NULL
          )
         ''');
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    String id = row[columnId];
    return await db!.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}