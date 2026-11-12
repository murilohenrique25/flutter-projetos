import 'package:sqflite/sqflite.dart';
import 'package:gestao_rural/model/sanitario.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/database/database_helper.dart';

class SanitarioService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> inserir(Sanitario sanitario) async {
    final db = await _databaseHelper.database;

    final Map<String, dynamic> data = {
      'animalId': sanitario.animal.id,
      'enfermidade': sanitario.enfermidade,
      'vacina': sanitario.vacina,
      'dataOcorrencia': sanitario.dataOcorrencia,
      'observacao': sanitario.observacao,
    };

    return await db.insert('sanitario', data);
  }

  Future<List<Sanitario>> listarTodos() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        s.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM sanitario s
      INNER JOIN animal a ON s.animalId = a.id
      ORDER BY s.dataOcorrencia DESC
    ''');
    return _mapToSanitarioList(maps);
  }

  Future<Sanitario?> buscarPorId(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        s.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM sanitario s
      INNER JOIN animal a ON s.animalId = a.id
      WHERE s.id = ?
    ''',
      [id],
    );

    if (maps.isNotEmpty) {
      return _mapToSanitario(maps.first);
    }
    return null;
  }

  Future<List<Sanitario>> buscarPorAnimal(int animalId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        s.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM sanitario s
      INNER JOIN animal a ON s.animalId = a.id
      WHERE s.animalId = ?
      ORDER BY s.dataOcorrencia DESC
    ''',
      [animalId],
    );

    return _mapToSanitarioList(maps);
  }

  Future<List<Sanitario>> buscarPorEnfermidade(String enfermidade) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        s.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM sanitario s
      INNER JOIN animal a ON s.animalId = a.id
      WHERE s.enfermidade LIKE ?
      ORDER BY s.dataOcorrencia DESC
    ''',
      ['%$enfermidade%'],
    );

    return _mapToSanitarioList(maps);
  }

  Future<List<Sanitario>> buscarPorVacina(String vacina) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        s.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM sanitario s
      INNER JOIN animal a ON s.animalId = a.id
      WHERE s.vacina LIKE ?
      ORDER BY s.dataOcorrencia DESC
    ''',
      ['%$vacina%'],
    );

    return _mapToSanitarioList(maps);
  }

  Future<List<Sanitario>> buscarPorPeriodo(
    String dataInicio,
    String dataFim,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        s.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM sanitario s
      INNER JOIN animal a ON s.animalId = a.id
      WHERE s.dataOcorrencia BETWEEN ? AND ?
      ORDER BY s.dataOcorrencia DESC
    ''',
      [dataInicio, dataFim],
    );

    return _mapToSanitarioList(maps);
  }

  Future<int> atualizar(Sanitario sanitario) async {
    final db = await _databaseHelper.database;

    final Map<String, dynamic> data = {
      'animalId': sanitario.animal.id,
      'enfermidade': sanitario.enfermidade,
      'vacina': sanitario.vacina,
      'dataOcorrencia': sanitario.dataOcorrencia,
      'observacao': sanitario.observacao,
    };

    return await db.update(
      'sanitario',
      data,
      where: 'id = ?',
      whereArgs: [sanitario.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('sanitario', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> contarRegistros() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM sanitario');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> contarRegistrosPorAnimal(int animalId) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sanitario WHERE animalId = ?',
      [animalId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Sanitario>> listarPorPagina(
    int pagina,
    int itensPorPagina,
  ) async {
    final db = await _databaseHelper.database;
    final offset = (pagina - 1) * itensPorPagina;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        s.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM sanitario s
      INNER JOIN animal a ON s.animalId = a.id
      ORDER BY s.dataOcorrencia DESC
      LIMIT ? OFFSET ?
    ''',
      [itensPorPagina, offset],
    );

    return _mapToSanitarioList(maps);
  }

  Future<Sanitario?> buscarUltimoPorAnimal(int animalId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        s.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM sanitario s
      INNER JOIN animal a ON s.animalId = a.id
      WHERE s.animalId = ?
      ORDER BY s.dataOcorrencia DESC
      LIMIT 1
    ''',
      [animalId],
    );

    if (maps.isNotEmpty) {
      return _mapToSanitario(maps.first);
    }
    return null;
  }

  Future<List<String>> listarEnfermidades() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sanitario',
      columns: ['enfermidade'],
      distinct: true,
      orderBy: 'enfermidade',
    );

    return maps.map((map) => map['enfermidade'] as String).toList();
  }

  Future<List<String>> listarVacinas() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sanitario',
      columns: ['vacina'],
      distinct: true,
      orderBy: 'vacina',
    );

    return maps.map((map) => map['vacina'] as String).toList();
  }

  Future<List<Sanitario>> buscarPorLote(String lote) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        s.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM sanitario s
      INNER JOIN animal a ON s.animalId = a.id
      WHERE a.lote = ?
      ORDER BY s.dataOcorrencia DESC
    ''',
      [lote],
    );

    return _mapToSanitarioList(maps);
  }

  Future<Map<String, int>> contarPorEnfermidade() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT enfermidade, COUNT(*) as count
      FROM sanitario
      GROUP BY enfermidade
      ORDER BY count DESC
    ''');

    Map<String, int> resultado = {};
    for (var map in maps) {
      resultado[map['enfermidade']] = map['count'];
    }
    return resultado;
  }

  Future<Map<String, int>> contarPorVacina() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT vacina, COUNT(*) as count
      FROM sanitario
      GROUP BY vacina
      ORDER BY count DESC
    ''');

    Map<String, int> resultado = {};
    for (var map in maps) {
      resultado[map['vacina']] = map['count'];
    }
    return resultado;
  }

  // Métodos auxiliares para evitar repetição de código
  List<Sanitario> _mapToSanitarioList(List<Map<String, dynamic>> maps) {
    List<Sanitario> sanitarios = [];

    for (var map in maps) {
      sanitarios.add(_mapToSanitario(map));
    }

    return sanitarios;
  }

  Sanitario _mapToSanitario(Map<String, dynamic> map) {
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

    return Sanitario(
      id: map['id'],
      animal: animal,
      enfermidade: map['enfermidade'],
      vacina: map['vacina'],
      dataOcorrencia: map['dataOcorrencia'],
      observacao: map['observacao'] ?? '',
    );
  }
}
