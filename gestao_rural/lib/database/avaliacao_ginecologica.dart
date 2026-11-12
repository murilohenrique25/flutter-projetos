import 'package:sqflite/sqflite.dart';
import 'package:gestao_rural/model/avaliacao_ginecologica.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/database/database_helper.dart';

class AvaliacaoGinecologicaService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> inserir(AvaliacaoGinecologica avaliacao) async {
    final db = await _databaseHelper.database;

    final Map<String, dynamic> data = {
      'animalId': avaliacao.animal.id,
      'descricao': avaliacao.descricao,
      'dataOcorrencia': avaliacao.dataOcorrencia,
    };

    return await db.insert('avaliacao_ginecologica', data);
  }

  Future<List<AvaliacaoGinecologica>> listarTodos() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        ag.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM avaliacao_ginecologica ag
      INNER JOIN animal a ON ag.animalId = a.id
      ORDER BY ag.dataOcorrencia DESC
    ''');

    return _mapToAvaliacaoList(maps);
  }

  Future<AvaliacaoGinecologica?> buscarPorId(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        ag.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM avaliacao_ginecologica ag
      INNER JOIN animal a ON ag.animalId = a.id
      WHERE ag.id = ?
    ''',
      [id],
    );

    if (maps.isNotEmpty) {
      return _mapToAvaliacao(maps.first);
    }
    return null;
  }

  Future<List<AvaliacaoGinecologica>> buscarPorAnimal(int animalId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        ag.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM avaliacao_ginecologica ag
      INNER JOIN animal a ON ag.animalId = a.id
      WHERE ag.animalId = ?
      ORDER BY ag.dataOcorrencia DESC
    ''',
      [animalId],
    );

    return _mapToAvaliacaoList(maps);
  }

  Future<List<AvaliacaoGinecologica>> buscarPorPeriodo(
    String dataInicio,
    String dataFim,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        ag.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM avaliacao_ginecologica ag
      INNER JOIN animal a ON ag.animalId = a.id
      WHERE ag.dataOcorrencia BETWEEN ? AND ?
      ORDER BY ag.dataOcorrencia DESC
    ''',
      [dataInicio, dataFim],
    );

    return _mapToAvaliacaoList(maps);
  }

  Future<List<AvaliacaoGinecologica>> buscarPorDescricao(
    String descricao,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        ag.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM avaliacao_ginecologica ag
      INNER JOIN animal a ON ag.animalId = a.id
      WHERE ag.descricao LIKE ?
      ORDER BY ag.dataOcorrencia DESC
    ''',
      ['%$descricao%'],
    );

    return _mapToAvaliacaoList(maps);
  }

  Future<int> atualizar(AvaliacaoGinecologica avaliacao) async {
    final db = await _databaseHelper.database;

    final Map<String, dynamic> data = {
      'animalId': avaliacao.animal.id,
      'descricao': avaliacao.descricao,
      'dataOcorrencia': avaliacao.dataOcorrencia,
    };

    return await db.update(
      'avaliacao_ginecologica',
      data,
      where: 'id = ?',
      whereArgs: [avaliacao.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'avaliacao_ginecologica',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> contarAvaliacoes() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM avaliacao_ginecologica',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> contarAvaliacoesPorAnimal(int animalId) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM avaliacao_ginecologica WHERE animalId = ?',
      [animalId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<AvaliacaoGinecologica>> listarPorPagina(
    int pagina,
    int itensPorPagina,
  ) async {
    final db = await _databaseHelper.database;
    final offset = (pagina - 1) * itensPorPagina;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        ag.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM avaliacao_ginecologica ag
      INNER JOIN animal a ON ag.animalId = a.id
      ORDER BY ag.dataOcorrencia DESC
      LIMIT ? OFFSET ?
    ''',
      [itensPorPagina, offset],
    );

    return _mapToAvaliacaoList(maps);
  }

  Future<AvaliacaoGinecologica?> buscarUltimaPorAnimal(int animalId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        ag.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto
      FROM avaliacao_ginecologica ag
      INNER JOIN animal a ON ag.animalId = a.id
      WHERE ag.animalId = ?
      ORDER BY ag.dataOcorrencia DESC
      LIMIT 1
    ''',
      [animalId],
    );

    if (maps.isNotEmpty) {
      return _mapToAvaliacao(maps.first);
    }
    return null;
  }

  // Métodos auxiliares para evitar repetição de código
  List<AvaliacaoGinecologica> _mapToAvaliacaoList(
    List<Map<String, dynamic>> maps,
  ) {
    List<AvaliacaoGinecologica> avaliacoes = [];

    for (var map in maps) {
      avaliacoes.add(_mapToAvaliacao(map));
    }

    return avaliacoes;
  }

  AvaliacaoGinecologica _mapToAvaliacao(Map<String, dynamic> map) {
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

    return AvaliacaoGinecologica(
      id: map['id'],
      animal: animal,
      descricao: map['descricao'],
      dataOcorrencia: map['dataOcorrencia'],
    );
  }
}
