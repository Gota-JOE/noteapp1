import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/note_model.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._();

  factory DatabaseProvider() => _instance;

  static Database? _database;

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    // this function create database
    final databasePath =
        await getDatabasesPath(); // getDatabasePath => create database and save the path or location, we can print (databasePath) to see the path
    final path = join(databasePath,
        'notes.db'); // join => بتعمل دمج بين المسار واسم الفايل العملناهو , see how save folder or add folder example joe/noteapp , / => the way to save
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT
      )
    ''');
  }

  Future<int> createNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
/***import 'package:sqflite/sqflite.dart';
    import 'package:path/path.dart';

    import '../model/note_model.dart';

    class NoteDatabase {
    NoteDatabase._();

    static final NoteDatabase db = NoteDatabase._();
    static Database? _database;

    Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
    }

    Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
    }

    Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    content TEXT,
    creation_date DATE,
    )
    ''');
    }

    insertNote(Note note) async {
    final db = await database;
    db.insert('notes', note.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<dynamic> getNotes() async {
    final db = await database;
    var res = await db.query('notes');
    if (res.length == 0) {
    return Null;
    } else {
    var resultMap = res.toList();
    return resultMap.isNotEmpty ? resultMap : Null;
    }
    }
    }***/
