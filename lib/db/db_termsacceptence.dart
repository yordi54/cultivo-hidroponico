import 'package:cultivo_hidroponico/models/termsacceptance_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbTermsAcceptence {
  
  static Database? _database;
  static const String _dbName = 'terms_database.db';
  static const String _tableName = 'terms_acceptance';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        '''
        CREATE TABLE $_tableName (
          id INTEGER PRIMARY KEY,
          accepted INTEGER
        )
        ''',
      );
    });
  }

  Future<void> insertTermsAcceptance(TermsAcceptance acceptance) async {
    final db = await database;
    await db.insert(_tableName, acceptance.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<TermsAcceptance?> getTermsAcceptance() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    if (maps.isEmpty) {
      return null;
    }
    return TermsAcceptance.fromMap(maps.first);
  }
}
