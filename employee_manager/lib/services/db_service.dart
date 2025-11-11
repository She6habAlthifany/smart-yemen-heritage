import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/employee.dart';
import '../models/department.dart';
import '../models/salary.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'company.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE departments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        departmentId INTEGER NOT NULL,
        salary REAL NOT NULL,
        FOREIGN KEY(departmentId) REFERENCES departments(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE salaries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employeeId INTEGER NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY(employeeId) REFERENCES employees(id)
      )
    ''');
  }

  Future<int> insertDepartment(Department d) async {
    final database = await db;
    return await database.insert('departments', d.toMap());
  }

  Future<int> insertEmployee(Employee e) async {
    final database = await db;
    return await database.insert('employees', e.toMap());
  }

  Future<int> insertSalary(SalaryRecord s) async {
    final database = await db;
    return await database.insert('salaries', s.toMap());
  }

  Future<List<Map<String, dynamic>>> getEmployeesMap() async {
    final database = await db;
    return await database.query('employees');
  }
}
