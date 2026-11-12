import 'package:sqflite/sqflite.dart';
import 'package:gestao_rural/model/parto.dart';
import 'package:gestao_rural/model/animal.dart';
import 'package:gestao_rural/model/diagnostico_gestacao.dart';
import 'package:gestao_rural/model/inseminacao.dart';
import 'package:gestao_rural/database/database_helper.dart';

class PartoService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> inserir(Parto parto) async {
    final db = await _databaseHelper.database;

    final Map<String, dynamic> data = {
      'animalId': parto.animal.id,
      'diagnosticoGestacaoId': parto.diagnosticoGestacao.id,
      'dataPrevisaoParto': parto.dataPrevisaoParto,
      'pariu': parto.pariu ? 1 : 0,
      'dataPartoRealizada': parto.dataPartoRealizada,
    };

    return await db.insert('parto', data);
  }

  Future<List<Parto>> listarTodos() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        p.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto,
        dg.prenha, dg.dataDiagnostico,
        i.tipoInseminacao, i.dataInseminacao as inseminacaoData
      FROM parto p
      INNER JOIN animal a ON p.animalId = a.id
      INNER JOIN diagnostico_gestacao dg ON p.diagnosticoGestacaoId = dg.id
      INNER JOIN inseminacao i ON dg.inseminacaoId = i.id
      ORDER BY p.dataPrevisaoParto ASC
    ''');

    List<Parto> partos = [];

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
        id: map['diagnosticoGestacaoId'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['inseminacaoData'],
      );

      final diagnostico = DiagnosticoGestacao(
        id: map['diagnosticoGestacaoId'],
        animal: animal,
        inseminacao: inseminacao,
        prenha: map['prenha'] == 1,
        dataDiagnostico: map['dataDiagnostico'],
      );

      final parto = Parto(
        id: map['id'],
        animal: animal,
        diagnosticoGestacao: diagnostico,
        dataPrevisaoParto: map['dataPrevisaoParto'],
        pariu: map['pariu'] == 1,
        dataPartoRealizada: map['dataPartoRealizada'],
      );

      partos.add(parto);
    }

    return partos;
  }

  Future<Parto?> buscarPorId(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        p.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto,
        dg.prenha, dg.dataDiagnostico,
        i.tipoInseminacao, i.dataInseminacao as inseminacaoData
      FROM parto p
      INNER JOIN animal a ON p.animalId = a.id
      INNER JOIN diagnostico_gestacao dg ON p.diagnosticoGestacaoId = dg.id
      INNER JOIN inseminacao i ON dg.inseminacaoId = i.id
      WHERE p.id = ?
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
        id: map['diagnosticoGestacaoId'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['inseminacaoData'],
      );

      final diagnostico = DiagnosticoGestacao(
        id: map['diagnosticoGestacaoId'],
        animal: animal,
        inseminacao: inseminacao,
        prenha: map['prenha'] == 1,
        dataDiagnostico: map['dataDiagnostico'],
      );

      return Parto(
        id: map['id'],
        animal: animal,
        diagnosticoGestacao: diagnostico,
        dataPrevisaoParto: map['dataPrevisaoParto'],
        pariu: map['pariu'] == 1,
        dataPartoRealizada: map['dataPartoRealizada'],
      );
    }
    return null;
  }

  Future<List<Parto>> buscarPorAnimal(int animalId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT
        p.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto,
        dg.prenha, dg.dataDiagnostico,
        i.tipoInseminacao, i.dataInseminacao as inseminacaoData
      FROM parto p
      INNER JOIN animal a ON p.animalId = a.id
      INNER JOIN diagnostico_gestacao dg ON p.diagnosticoGestacaoId = dg.id
      INNER JOIN inseminacao i ON dg.inseminacaoId = i.id
      WHERE p.animalId = ?
      ORDER BY p.dataPrevisaoParto DESC
    ''',
      [animalId],
    );

    List<Parto> partos = [];

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
        id: map['diagnosticoGestacaoId'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['inseminacaoData'],
      );

      final diagnostico = DiagnosticoGestacao(
        id: map['diagnosticoGestacaoId'],
        animal: animal,
        inseminacao: inseminacao,
        prenha: map['prenha'] == 1,
        dataDiagnostico: map['dataDiagnostico'],
      );

      final parto = Parto(
        id: map['id'],
        animal: animal,
        diagnosticoGestacao: diagnostico,
        dataPrevisaoParto: map['dataPrevisaoParto'],
        pariu: map['pariu'] == 1,
        dataPartoRealizada: map['dataPartoRealizada'],
      );

      partos.add(parto);
    }

    return partos;
  }

  Future<List<Parto>> buscarPartosRealizados() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        p.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto,
        dg.prenha, dg.dataDiagnostico,
        i.tipoInseminacao, i.dataInseminacao as inseminacaoData
      FROM parto p
      INNER JOIN animal a ON p.animalId = a.id
      INNER JOIN diagnostico_gestacao dg ON p.diagnosticoGestacaoId = dg.id
      INNER JOIN inseminacao i ON dg.inseminacaoId = i.id
      WHERE p.pariu = 1
      ORDER BY p.dataPartoRealizada DESC
    ''');

    List<Parto> partos = [];

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
        id: map['diagnosticoGestacaoId'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['inseminacaoData'],
      );

      final diagnostico = DiagnosticoGestacao(
        id: map['diagnosticoGestacaoId'],
        animal: animal,
        inseminacao: inseminacao,
        prenha: map['prenha'] == 1,
        dataDiagnostico: map['dataDiagnostico'],
      );

      final parto = Parto(
        id: map['id'],
        animal: animal,
        diagnosticoGestacao: diagnostico,
        dataPrevisaoParto: map['dataPrevisaoParto'],
        pariu: map['pariu'] == 1,
        dataPartoRealizada: map['dataPartoRealizada'],
      );

      partos.add(parto);
    }

    return partos;
  }

  Future<List<Parto>> buscarPartosPendentes() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        p.*,
        a.numeroBrinco, a.nome, a.lote, a.pesoNascimento, a.dataNascimento,
        a.raca, a.quantidadeCios, a.quantidadePartos, a.dataInseminacao, a.dataParto,
        dg.prenha, dg.dataDiagnostico,
        i.tipoInseminacao, i.dataInseminacao as inseminacaoData
      FROM parto p
      INNER JOIN animal a ON p.animalId = a.id
      INNER JOIN diagnostico_gestacao dg ON p.diagnosticoGestacaoId = dg.id
      INNER JOIN inseminacao i ON dg.inseminacaoId = i.id
      WHERE p.pariu = 0
      ORDER BY p.dataPrevisaoParto ASC
    ''');

    List<Parto> partos = [];

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
        id: map['diagnosticoGestacaoId'],
        animal: animal,
        tipoInseminacao: map['tipoInseminacao'],
        dataInseminacao: map['inseminacaoData'],
      );

      final diagnostico = DiagnosticoGestacao(
        id: map['diagnosticoGestacaoId'],
        animal: animal,
        inseminacao: inseminacao,
        prenha: map['prenha'] == 1,
        dataDiagnostico: map['dataDiagnostico'],
      );

      final parto = Parto(
        id: map['id'],
        animal: animal,
        diagnosticoGestacao: diagnostico,
        dataPrevisaoParto: map['dataPrevisaoParto'],
        pariu: map['pariu'] == 1,
        dataPartoRealizada: map['dataPartoRealizada'],
      );

      partos.add(parto);
    }

    return partos;
  }

  Future<int> confirmarParto(String id, String dataPartoRealizada) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'parto',
      {'pariu': 1, 'dataPartoRealizada': dataPartoRealizada},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> atualizar(Parto parto) async {
    final db = await _databaseHelper.database;

    final Map<String, dynamic> data = {
      'animalId': parto.animal.id,
      'diagnosticoGestacaoId': parto.diagnosticoGestacao.id,
      'dataPrevisaoParto': parto.dataPrevisaoParto,
      'pariu': parto.pariu ? 1 : 0,
      'dataPartoRealizada': parto.dataPartoRealizada,
    };

    return await db.update(
      'parto',
      data,
      where: 'id = ?',
      whereArgs: [parto.id],
    );
  }

  Future<int> deletar(String id) async {
    final db = await _databaseHelper.database;
    return await db.delete('parto', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> contarPartos() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM parto');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> contarPartosRealizados() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM parto WHERE pariu = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> contarPartosPendentes() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM parto WHERE pariu = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, int>> obterEstatisticas() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('''
      SELECT
        COUNT(*) as total,
        SUM(CASE WHEN pariu = 1 THEN 1 ELSE 0 END) as realizados,
        SUM(CASE WHEN pariu = 0 THEN 1 ELSE 0 END) as pendentes
      FROM parto
    ''');

    if (result.isNotEmpty) {
      final map = result.first;
      return {
        'total': map['total'] as int,
        'realizados': map['realizados'] as int,
        'pendentes': map['pendentes'] as int,
      };
    }

    return {'total': 0, 'realizados': 0, 'pendentes': 0};
  }
}
