import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'gestao_rural.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela Animal
    await db.execute('''
      CREATE TABLE animal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numeroBrinco TEXT NOT NULL,
        nome TEXT NOT NULL,
        lote TEXT NOT NULL,
        pesoNascimento REAL NOT NULL,
        dataNascimento TEXT NOT NULL,
        raca TEXT NOT NULL,
        quantidadeCios INTEGER DEFAULT 0,
        quantidadePartos INTEGER DEFAULT 0,
        dataInseminacao TEXT DEFAULT '',
        dataParto TEXT DEFAULT ''
      )
    ''');

    // Tabela Inseminacao
    await db.execute('''
      CREATE TABLE inseminacao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        animalId INTEGER NOT NULL,
        tipoInseminacao TEXT NOT NULL,
        dataInseminacao TEXT NOT NULL,
        FOREIGN KEY (animalId) REFERENCES animal (id)
      )
    ''');

    // Tabela DiagnosticoGestacao
    await db.execute('''
      CREATE TABLE diagnostico_gestacao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        animalId INTEGER NOT NULL,
        inseminacaoId TEXT NOT NULL,
        prenha INTEGER NOT NULL,
        dataDiagnostico TEXT NOT NULL,
        FOREIGN KEY (animalId) REFERENCES animal (id),
        FOREIGN KEY (inseminacaoId) REFERENCES inseminacao (id)
      )
    ''');

    // Tabela Parto
    await db.execute('''
      CREATE TABLE parto (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
        animalId INTEGER NOT NULL,
        diagnosticoGestacaoId INTEGER NOT NULL,
        dataPrevisaoParto TEXT NOT NULL,
        pariu INTEGER DEFAULT 0,
        dataPartoRealizada TEXT,
        FOREIGN KEY (animalId) REFERENCES animal (id),
        FOREIGN KEY (diagnosticoGestacaoId) REFERENCES diagnostico_gestacao (id)
      )
    ''');

    // Tabela AvaliacaoGinecologica
    await db.execute('''
      CREATE TABLE avaliacao_ginecologica (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        animalId INTEGER NOT NULL,
        descricao TEXT NOT NULL,
        dataOcorrencia TEXT NOT NULL,
        FOREIGN KEY (animalId) REFERENCES animal (id)
      )
    ''');

    // Tabela Sanitario
    await db.execute('''
      CREATE TABLE sanitario (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
        animalId INTEGER NOT NULL,
        enfermidade TEXT NOT NULL,
        vacina TEXT NOT NULL,
        dataOcorrencia TEXT NOT NULL,
        observacao TEXT DEFAULT '',
        FOREIGN KEY (animalId) REFERENCES animal (id)
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
