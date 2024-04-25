import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

// criação da tabela com as informações como id,titulo,descrição//
class SqlDb {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE tutorial(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  // Abre o banco de dados e cria as tabelas
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbteste.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },

    );
  }

  //Insert, serve para inserir dados, onde ele vai adicionar no banco de dados
  static Future<int> insert(String title, String? descrption) async{
    final db = await SqlDb.db();

    final data = {'title': title, 'descrption': descrption};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //Mostrar todos items e ordena por id
  static Future<List<Map<String, dynamic>>> buscarTodos() async{
    final db = await SqlDb.db();
    return db.query('items',orderBy:"id");
  }

  //Busca por item pelo id
  static Future<List<Map<String, dynamic>>> BuscaPorItem(int id) async{
    final db = await SqlDb.db();
    return db.query('items', where: "id = ?", whereArgs:[id], limit: 1);
  }

  //Update
  static Future<int> atualizaItem(
      int id, String title, String? descrption) async {
    final db = await SqlDb.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAT': DateTime.now().toString()
    };

    final result =
    await db.update('items',data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  //Delete
  static Future<void> deleteItem(int id) async{
    final db = await SqlDb.db();
    try{
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Algo deu errado na exclusão do item: $err");
    }
  }
}

