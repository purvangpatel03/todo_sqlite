import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteHelper {

  Future<Database> openMyDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'myToDoDatabase.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todoList(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, status  INTEGER)',
        );
      },
    );
  }

  Future<void> insertTask(String title, bool status) async{
    final db = await openMyDatabase();
    db.insert('todoList', {
      'title': title,
      'status': status ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTask(int id) async{
    final db = await openMyDatabase();
    db.delete('todoList', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTask(int id, bool status) async{
    final db = await openMyDatabase();
    db.update('todoList', {
      'status': status ? 1 : 0,
    }, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getTasks() async{
    final db = await openMyDatabase();
    return await db.query('todoList');

  }
}