import 'package:sqflite/sqflite.dart';
import 'package:gestao_rural/model/diagnostico_gestacao.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/model/inseminacao.dart';
import 'package:gestao_rural/database/database_helper.dart';

class DiagnosticoGestacaoService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> inserir(DiagnosticoGestacao diagnostico) async {
    final db = await _databaseHelper.database;

    final Map<String, dynamic> data = {
      'animalId': diagnostico.animal.id,
      'inseminacaoId': diagnostico.inseminacao.id,
      'prenha': diagnostico.prenha ? 1 : 0,
      'dataDiagnostico': diagnostico.dataDiagnostico,
    };

    return await db.insert('diagnostico_gestacao', data);
  }

  Future<List<DiagnosticoGestacao>> listarTodos() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        dg.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto,
        i.tipoInseminacao, i.dataInseminacao as inseminacaoData
      FROM diagnostico_gestacao dg
      INNER JOIN animal a ON dg.animalId = a.id
      INNER JOIN inseminacao i ON dg.inseminacaoId = i.id
      ORDER BY dg.dataDiagnostico DESC
    ''');

    List<DiagnosticoGestacao> diagnosticos = [];

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
        id: int.parse(map['inseminacaoId']),
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['inseminacaoData'],
      );

      final diagnostico = DiagnosticoGestacao(
        id: map['id'],
        animal: animal,
        inseminacao: inseminacao,
        prenha: map['prenha'] == 1,
        dataDiagnostico: map['dataDiagnostico'],
      );

      diagnosticos.add(diagnostico);
    }

    return diagnosticos;
  }

  Future<DiagnosticoGestacao?> buscarPorId(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        dg.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto,
        i.tipoInseminacao, i.dataInseminacao as inseminacaoData
      FROM diagnostico_gestacao dg
      INNER JOIN animal a ON dg.animalId = a.id
      INNER JOIN inseminacao i ON dg.inseminacaoId = i.id
      WHERE dg.id = ?
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

      final inseminacao = Inseminacao(
        id: map['inseminacaoId'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['inseminacaoData'],
      );

      return DiagnosticoGestacao(
        id: map['id'],
        animal: animal,
        inseminacao: inseminacao,
        prenha: map['prenha'] == 1,
        dataDiagnostico: map['dataDiagnostico'],
      );
    }
    return null;
  }

  Future<List<DiagnosticoGestacao>> buscarPorAnimal(int animalId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        dg.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto,
        i.tipoInseminacao, i.dataInseminacao as inseminacaoData
      FROM diagnostico_gestacao dg
      INNER JOIN animal a ON dg.animalId = a.id
      INNER JOIN inseminacao i ON dg.inseminacaoId = i.id
      WHERE dg.animalId = ?
      ORDER BY dg.dataDiagnostico DESC
    ''',
      [animalId],
    );

    List<DiagnosticoGestacao> diagnosticos = [];

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
        id: map['inseminacaoId'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['inseminacaoData'],
      );

      final diagnostico = DiagnosticoGestacao(
        id: map['id'],
        animal: animal,
        inseminacao: inseminacao,
        prenha: map['prenha'] == 1,
        dataDiagnostico: map['dataDiagnostico'],
      );

      diagnosticos.add(diagnostico);
    }

    return diagnosticos;
  }

  Future<List<DiagnosticoGestacao>> buscarPrenhas() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        dg.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto,
        i.tipoInseminacao, i.dataInseminacao as inseminacaoData
      FROM diagnostico_gestacao dg
      INNER JOIN animal a ON dg.animalId = a.id
      INNER JOIN inseminacao i ON dg.inseminacaoId = i.id
      WHERE dg.prenha = 1
      ORDER BY dg.dataDiagnostico DESC
    ''');

    List<DiagnosticoGestacao> diagnosticos = [];

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
        id: map['inseminacaoId'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['inseminacaoData'],
      );

      final diagnostico = DiagnosticoGestacao(
        id: map['id'],
        animal: animal,
        inseminacao: inseminacao,
        prenha: map['prenha'] == 1,
        dataDiagnostico: map['dataDiagnostico'],
      );

      diagnosticos.add(diagnostico);
    }

    return diagnosticos;
  }

  Future<List<DiagnosticoGestacao>> buscarPorPeriodo(
    String dataInicio,
    String dataFim,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        dg.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto,
        i.tipoInseminacao, i.dataInseminacao as inseminacaoData
      FROM diagnostico_gestacao dg
      INNER JOIN animal a ON dg.animalId = a.id
      INNER JOIN inseminacao i ON dg.inseminacaoId = i.id
      WHERE dg.dataDiagnostico BETWEEN ? AND ?
      ORDER BY dg.dataDiagnostico DESC
    ''',
      [dataInicio, dataFim],
    );

    List<DiagnosticoGestacao> diagnosticos = [];

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
        id: map['inseminacaoId'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['inseminacaoData'],
      );

      final diagnostico = DiagnosticoGestacao(
        id: map['id'],
        animal: animal,
        inseminacao: inseminacao,
        prenha: map['prenha'] == 1,
        dataDiagnostico: map['dataDiagnostico'],
      );

      diagnosticos.add(diagnostico);
    }

    return diagnosticos;
  }

  Future<int> atualizar(DiagnosticoGestacao diagnostico) async {
    final db = await _databaseHelper.database;

    final Map<String, dynamic> data = {
      'animalId': diagnostico.animal.id,
      'inseminacaoId': diagnostico.inseminacao.id,
      'prenha': diagnostico.prenha ? 1 : 0,
      'dataDiagnostico': diagnostico.dataDiagnostico,
    };

    return await db.update(
      'diagnostico_gestacao',
      data,
      where: 'id = ?',
      whereArgs: [diagnostico.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'diagnostico_gestacao',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> contarDiagnosticos() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM diagnostico_gestacao',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> contarPrenhas() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM diagnostico_gestacao WHERE prenha = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, int>> obterEstatisticas() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('''
      SELECT
        COUNT(*) as total,
        SUM(CASE WHEN prenha = 1 THEN 1 ELSE 0 END) as prenhas,
        SUM(CASE WHEN prenha = 0 THEN 1 ELSE 0 END) as nao_prenhas
      FROM diagnostico_gestacao
    ''');

    if (result.isNotEmpty) {
      final map = result.first;
      return {
        'total': map['total'] as int,
        'prenhas': map['prenhas'] as int,
        'nao_prenhas': map['nao_prenhas'] as int,
      };
    } else {
      return <String, int>{};
    }
  }
}
