import 'package:sqflite/sqflite.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/database/database_helper.dart';

class AnimalService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> inserir(Animal animal) async {
    final db = await _databaseHelper.database;
    return await db.insert('animal', animal.toMap());
  }

  Future<List<Animal>> listarTodos() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('animal');

    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Animal.fromMap(map);
    });
  }

  Future<Animal?> buscarPorId(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'animal',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return Animal.fromMap({...map, 'id': map['id']});
    }
    return null;
  }

  Future<List<Animal>> buscarPorNome(String nome) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'animal',
      where: 'nome LIKE ?',
      whereArgs: ['%$nome%'],
    );

    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Animal.fromMap({...map, 'id': map['id']});
    });
  }

  Future<List<Animal>> buscarPorLote(String lote) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'animal',
      where: 'lote = ?',
      whereArgs: [lote],
    );

    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Animal.fromMap({...map, 'id': map['id']});
    });
  }

  Future<int> atualizar(Animal animal) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'animal',
      animal.toMap(),
      where: 'id = ?',
      whereArgs: [animal.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('animal', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<String>> listarLotes() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'animal',
      columns: ['lote'],
      distinct: true,
      orderBy: 'lote',
    );

    return maps.map((map) => map['lote'] as String).toList();
  }

  Future<List<String>> listarRacas() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'animal',
      columns: ['raca'],
      distinct: true,
      orderBy: 'raca',
    );

    return maps.map((map) => map['raca'] as String).toList();
  }

  Future<int> contarAnimais() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM animal');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Animal>> listarPorPagina(int pagina, int itensPorPagina) async {
    final db = await _databaseHelper.database;
    final offset = (pagina - 1) * itensPorPagina;

    final List<Map<String, dynamic>> maps = await db.query(
      'animal',
      limit: itensPorPagina,
      offset: offset,
      orderBy: 'nome',
    );

    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Animal.fromMap({...map, 'id': map['id']});
    });
  }
}
