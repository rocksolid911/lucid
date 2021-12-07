import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class FormDatabase{
  static final FormDatabase instance = FormDatabase._init();
  static Database? _database;

   FormDatabase._init();

   Future<Database> get database async{
     if(_database != null) return _database!;
     _database = await _initDB('forms.db');
     return _database!;
   }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  Future _createDB(Database db,int version)async{
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $lucidForm ( 
  ${FormField.id} $idType, 
  ${FormField.name} $textType,
  ${FormField.mark} $integerType,
  ${FormField.gender} $textType,
  ${FormField.img} $textType,
  ${FormField.dob} $textType,
   ${FormField.nation} $textType,
  )
''');
  }
  Future<LucidForm> create(LucidForm lform) async {
    final db = await instance.database;



    final id = await db.insert(lucidForm, lform.toJson());
    return lform.copy(id: id);
  }

  Future<LucidForm> readForm(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      lucidForm,
      columns: FormField.values,
      where: '${FormField.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return LucidForm.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }
  Future<List<LucidForm>> readAllForm() async {
    final db = await instance.database;

    final orderBy = '${FormField.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(lucidForm, orderBy: orderBy);

    return result.map((json) => LucidForm.fromJson(json)).toList();
  }
  Future<int> update(LucidForm lform) async {
    final db = await instance.database;

    return db.update(
      lucidForm,
      lform.toJson(),
      where: '${FormField.id} = ?',
      whereArgs: [lform.id],
    );
  }
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      lucidForm,
      where: '${FormField.id} = ?',
      whereArgs: [id],
    );
  }
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}