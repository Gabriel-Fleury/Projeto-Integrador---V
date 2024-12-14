import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Contato {
  final int? id;
  final String nome;
  final String telefone;
  final String? email;

  Contato({this.id, required this.nome, required this.telefone, this.email});

  // Converte um Contato para um Map (para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
    };
  }

  // Converte um Map para um Contato (quando carregado do banco)
  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
    );
  }
}

class DB {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agenda_contatos.db');
    return await openDatabase(path, version: 2, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE contatos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        telefone TEXT,
        email TEXT  -- Adicionando o campo email
      )
    ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        // Caso a versão anterior seja menor que 2, alteramos a tabela
        await db.execute('''
        ALTER TABLE contatos ADD COLUMN email TEXT;
      ''');
      }
    });
  }


  Future<int> insertContato(Contato contato) async {
    final db = await database;
    return await db.insert(
      'contatos',
      contato.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Contato>> getContatos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contatos');
    return List.generate(maps.length, (i) {
      return Contato.fromMap(maps[i]);
    });
  }

  Future<int> updateContato(Contato contato) async {
    final db = await database;
    return await db.update(
      'contatos',
      contato.toMap(),
      where: 'id = ?',
      whereArgs: [contato.id],
    );
  }

  Future<int> deleteContato(int id) async {
    final db = await database;
    return await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
