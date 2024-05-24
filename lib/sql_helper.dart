import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        category TEXT,
        value TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP
      )
    """);

    await database.execute("""
      CREATE TRIGGER update_updatedAt
      AFTER UPDATE ON items
      FOR EACH ROW
      BEGIN
        UPDATE items SET updatedAt = CURRENT_TIMESTAMP WHERE id = OLD.id;
      END;
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'produtos.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
      String title, String? category, String? value) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'category': category, 'value': value};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    
    final item = await getItem(id);
    debugPrint('Item criado: $item');
    
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id, String title, String? category, String? value) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'category': category,
      'value': value
    };

    final result = await db.update('items', data, where: "id = ?", whereArgs: [id]);

    final item = await getItem(id);
    debugPrint('Item atualizado: $item');
    
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<List<Map<String, dynamic>>> getItemsByCategory(
      String category) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "category = ?", whereArgs: [category]);
  }
}
 