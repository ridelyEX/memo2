import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "memorama.db";
  static final _databaseVersion = 1;

  static final tableStats = "stats";
  static final columnId = "id";
  static final columnWins = "wins";
  static final columnLosses = "losses";

  static final tableHistory = "history";
  static final columnDate = "date";

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableStats (
        $columnId INTEGER PRIMARY KEY,
        $columnWins INTEGER NOT NULL DEFAULT 0,
        $columnLosses INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableHistory (
        $columnDate TEXT PRIMARY KEY,
        $columnWins INTEGER NOT NULL
      )
    ''');

    await db.insert(tableStats, {'wins': 0, 'losses': 0});
  }

  Future<void> updateStats(bool won) async {
    final db = await database;
    await db.rawUpdate(
        'UPDATE $tableStats SET ${won ? columnWins : columnLosses} = ${won ? columnWins : columnLosses} + 1'
    );
  }

  Future<Map<String, dynamic>> getStats() async {
    final db = await database;
    return (await db.query(tableStats)).first;
  }

  Future<void> saveGame(String date, int wins) async {
    final db = await database;
    await db.insert(
      tableHistory,
      {columnDate: date, columnWins: wins},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map>> getHistory() async {
    final db = await database;
    return await db.rawQuery('SELECT * FROM $tableHistory ORDER BY $columnDate DESC');
  }
}