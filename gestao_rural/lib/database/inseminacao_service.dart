import 'package:sqflite/sqflite.dart';
import 'package:gestao_rural/model/inseminacao.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/database/database_helper.dart';

class InseminacaoService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> inserir(Inseminacao inseminacao) async {
    final db = await _databaseHelper.database;

    final Map<String, dynamic> data = {
      'animalId': inseminacao.animal.id,
      'tipoInseminacao': inseminacao.tipoInseminacao,
      'dataInseminacao': inseminacao.dataInseminacao,
    };

    return await db.insert('inseminacao', data);
  }

  Future<List<Inseminacao>> listarTodos() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT i.*, a.* FROM inseminacao i
      INNER JOIN animal a ON i.animalId = a.id
      ORDER BY i.dataInseminacao DESC
    ''');

    List<Inseminacao> inseminacoes = [];

    for (var map in maps) {
      final animal = Animal.fromMap({
        'id': map['id'],
        'numeroBrinco': map['numeroBrinco'],
        'nome': map['nome'],
        'lote': map['lote'],
        'pesoNascimento': map['pesoNascimento'],
        'dataNascimento': map['dataNascimento'],
        'raca': map['raca'],
        'quantidadeCios': map['quantidadeCios'],
        'quantidadePartos': map['quantidadePartos'],
        'dataInseminacao': map['dataInseminacao'],
        'dataParto': map['dataParto'],
      });

      final inseminacao = Inseminacao(
        id: map['id'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['dataInseminacao'],
      );
      print(map);
      inseminacoes.add(inseminacao);
    }

    return inseminacoes;
  }

  Future<Inseminacao?> buscarPorId(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT i.*, a.* FROM inseminacao i
      INNER JOIN animal a ON i.animalId = a.id
      WHERE i.id = ?
    ''',
      [id],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;

      final animal = Animal.fromMap({
        'id': map['animalId'],
        'numeroBrinco': map['numeroBrinco'],
        'nome': map['nome'],
        'lote': map['lote'],
        'pesoNascimento': map['pesoNascimento'],
        'dataNascimento': map['dataNascimento'],
        'raca': map['raca'],
        'quantidadeCios': map['quantidadeCios'],
        'quantidadePartos': map['quantidadePartos'],
        'dataInseminacao': map['dataInseminacao'],
        'dataParto': map['dataParto'],
      });

      return Inseminacao(
        id: map['id'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['dataInseminacao'],
      );
    }
    return null;
  }

  Future<List<Inseminacao>> buscarPorAnimal(int animalId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT i.*, a.* FROM inseminacao i
      INNER JOIN animal a ON i.animalId = a.id
      WHERE i.animalId = ?
      ORDER BY i.dataInseminacao DESC
    ''',
      [animalId],
    );

    List<Inseminacao> inseminacoes = [];

    for (var map in maps) {
      final animal = Animal.fromMap({
        'id': map['animalId'],
        'numeroBrinco': map['numeroBrinco'],
        'nome': map['nome'],
        'lote': map['lote'],
        'pesoNascimento': map['pesoNascimento'],
        'dataNascimento': map['dataNascimento'],
        'raca': map['raca'],
        'quantidadeCios': map['quantidadeCios'],
        'quantidadePartos': map['quantidadePartos'],
        'dataInseminacao': map['dataInseminacao'],
        'dataParto': map['dataParto'],
      });

      final inseminacao = Inseminacao(
        id: map['id'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['dataInseminacao'],
      );

      inseminacoes.add(inseminacao);
    }

    return inseminacoes;
  }

  Future<List<Inseminacao>> buscarPorPeriodo(
    String dataInicio,
    String dataFim,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT i.*, a.* FROM inseminacao i
      INNER JOIN animal a ON i.animalId = a.id
      WHERE i.dataInseminacao BETWEEN ? AND ?
      ORDER BY i.dataInseminacao DESC
    ''',
      [dataInicio, dataFim],
    );

    List<Inseminacao> inseminacoes = [];

    for (var map in maps) {
      final animal = Animal.fromMap({
        'id': map['animalId'],
        'numeroBrinco': map['numeroBrinco'],
        'nome': map['nome'],
        'lote': map['lote'],
        'pesoNascimento': map['pesoNascimento'],
        'dataNascimento': map['dataNascimento'],
        'raca': map['raca'],
        'quantidadeCios': map['quantidadeCios'],
        'quantidadePartos': map['quantidadePartos'],
        'dataInseminacao': map['dataInseminacao'],
        'dataParto': map['dataParto'],
      });

      final inseminacao = Inseminacao(
        id: map['id'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['dataInseminacao'],
      );

      inseminacoes.add(inseminacao);
    }

    return inseminacoes;
  }

  Future<int> atualizar(Inseminacao inseminacao) async {
    final db = await _databaseHelper.database;

    final Map<String, dynamic> data = {
      'animalId': inseminacao.animal.id,
      'tipoInseminacao': inseminacao.tipoInseminacao,
      'dataInseminacao': inseminacao.dataInseminacao,
    };

    return await db.update(
      'inseminacao',
      data,
      where: 'id = ?',
      whereArgs: [inseminacao.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('inseminacao', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> contarInseminacoes() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM inseminacao',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<String>> listarTiposInseminacao() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'inseminacao',
      columns: ['tipoInseminacao'],
      distinct: true,
      orderBy: 'tipoInseminacao',
    );

    return maps.map((map) => map['tipoInseminacao'] as String).toList();
  }
}
