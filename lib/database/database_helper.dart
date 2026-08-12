import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/activity.dart';
import '../models/water_log.dart';
import '../models/user_goal.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "fitness.db");

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE activities(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  exercise TEXT,
  duration INTEGER,
  calories INTEGER,
  steps INTEGER,
  date TEXT
)
''');

    await db.execute('''
CREATE TABLE water_logs(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  amount INTEGER,
  date TEXT,
  timestamp TEXT
)
''');

    await db.execute('''
CREATE TABLE user_goals(
  id INTEGER PRIMARY KEY,
  calorieGoal INTEGER,
  stepGoal INTEGER,
  workoutGoal INTEGER,
  waterGoal INTEGER
)
''');

    // Insert default goals
    await db.insert('user_goals', {
      'id': 1,
      'calorieGoal': 2000,
      'stepGoal': 10000,
      'workoutGoal': 60,
      'waterGoal': 2500,
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
CREATE TABLE IF NOT EXISTS water_logs(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  amount INTEGER,
  date TEXT,
  timestamp TEXT
)
''');

      await db.execute('''
CREATE TABLE IF NOT EXISTS user_goals(
  id INTEGER PRIMARY KEY,
  calorieGoal INTEGER,
  stepGoal INTEGER,
  workoutGoal INTEGER,
  waterGoal INTEGER
)
''');

      await db.insert(
        'user_goals',
        {
          'id': 1,
          'calorieGoal': 2000,
          'stepGoal': 10000,
          'workoutGoal': 60,
          'waterGoal': 2500,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // --- Activities CRUD ---

  Future<int> insert(Activity activity) async {
    final db = await database;
    return db.insert("activities", activity.toMap());
  }

  Future<List<Activity>> getActivities() async {
    final db = await database;
    final result = await db.query(
      "activities",
      orderBy: "date DESC, id DESC",
    );
    return result.map((e) => Activity.fromMap(e)).toList();
  }

  Future<int> update(Activity activity) async {
    final db = await database;
    return db.update(
      "activities",
      activity.toMap(),
      where: "id=?",
      whereArgs: [activity.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(
      "activities",
      where: "id=?",
      whereArgs: [id],
    );
  }

  // --- Water Logs CRUD ---

  Future<int> insertWaterLog(WaterLog log) async {
    final db = await database;
    return db.insert("water_logs", log.toMap());
  }

  Future<List<WaterLog>> getWaterLogsByDate(String date) async {
    final db = await database;
    final result = await db.query(
      "water_logs",
      where: "date=?",
      whereArgs: [date],
      orderBy: "id DESC",
    );
    return result.map((e) => WaterLog.fromMap(e)).toList();
  }

  Future<List<WaterLog>> getAllWaterLogs() async {
    final db = await database;
    final result = await db.query("water_logs", orderBy: "date DESC");
    return result.map((e) => WaterLog.fromMap(e)).toList();
  }

  Future<int> deleteWaterLog(int id) async {
    final db = await database;
    return db.delete(
      "water_logs",
      where: "id=?",
      whereArgs: [id],
    );
  }

  // --- User Goals CRUD ---

  Future<UserGoal> getUserGoal() async {
    final db = await database;
    final result = await db.query("user_goals", where: "id=1");
    if (result.isNotEmpty) {
      return UserGoal.fromMap(result.first);
    }
    final defaultGoal = UserGoal(
      id: 1,
      calorieGoal: 2000,
      stepGoal: 10000,
      workoutGoal: 60,
      waterGoal: 2500,
    );
    await db.insert("user_goals", defaultGoal.toMap());
    return defaultGoal;
  }

  Future<int> saveUserGoal(UserGoal goal) async {
    final db = await database;
    return db.insert(
      "user_goals",
      goal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}