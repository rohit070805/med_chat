import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Table to store distinct chat sessions
    await db.execute('''
    CREATE TABLE sessions (
      id TEXT PRIMARY KEY,
      title TEXT,
      created_at TEXT
    )
    ''');

    // Table to store messages linked to a session
    await db.execute('''
    CREATE TABLE messages (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      session_id TEXT,
      role TEXT, 
      content TEXT,
      created_at TEXT
    )
    ''');
  }

  // --- Session Methods ---

  Future<String> createSession(String title) async {
    final db = await instance.database;
    return title;
  }

  Future<void> insertSession(String id, String title) async {
    final db = await instance.database;
    await db.insert('sessions', {
      'id': id,
      'title': title,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getSessions() async {
    final db = await instance.database;
    return await db.query('sessions', orderBy: 'created_at DESC');
  }

  // --- NEW: Delete Method ---
  Future<void> deleteSession(String id) async {
    final db = await instance.database;
    try {
      // Delete the session entry
      await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
      // Delete all messages associated with this session
      await db.delete('messages', where: 'session_id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting session: $e");
    }
  }

  // --- Message Methods ---

  Future<void> insertMessage(String sessionId, String role, String content) async {
    final db = await instance.database;
    await db.insert('messages', {
      'session_id': sessionId,
      'role': role, // 'user' or 'assistant'
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getMessages(String sessionId) async {
    final db = await instance.database;
    return await db.query(
      'messages',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'created_at ASC',
    );
  }
}