# Sqflite
Flutter App မှာ Local Data (Offline Data) တွေကို ရေရှည်သိမ်းဆည်းဖို့၊ Complex Queries တွေ ပတ်ဖို့နဲ့ structured data တွေ သိမ်းဆည်းဖို့ အသုံးအများဆုံး Relational Database Package ဖြစ်တဲ့ sqflite အကြောင်း လေ့လာကြည့်ကြရအောင်။

### 1. Dependency ထည့်သွင်းခြင်း
အရင်ဦးစွာ pubspec.yaml ထဲမှာ sqflite နဲ့ Database Path ရှာပေးမယ့် path package ကို ထည့်ပေးရပါမယ်။

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.9.0
```

### 2. Database Helper Class ဆောက်ခြင်း
Database ကို ဖွင့်တာ၊ Table ဆောက်တာနဲ့ ချိတ်ဆက်မှု စီမံတာတွေကို Singleton Pattern သုံးပြီး Class တစ်ခုတည်းမှာ စုစည်းထားတာ ပိုစနစ်ကျပါတယ်။

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Table များ စတင်ဆောက်လုပ်ခြင်း
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE liabilities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lenderName TEXT NOT NULL,
        description TEXT,
        totalAmount REAL NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }
}
```

### 3. CRUD Operations (Create, Read, Update, Delete)
sqflite မှာ Data တွေကို Map<String, dynamic> Format နဲ့ အလုပ်လုပ်ပါတယ်။

#### (A) Create (ဒေတာအသစ်ထည့်ခြင်း)
insert() method ကို သုံးပြီး ဒေတာထည့်ပါတယ်။ ထည့်လိုက်တဲ့ row ရဲ့ id ကို ပြန်ပေးပါတယ်။

```dart
Future<int> insertLiability(Map<String, dynamic> row) async {
  final db = await instance.database;
  return await db.insert('liabilities', row);
}

// သုံးစွဲပုံ:
final id = await DatabaseHelper.instance.insertLiability({
  'lenderName': 'KBZ Bank',
  'description': 'Home Loan',
  'totalAmount': 50000.0,
  'createdAt': DateTime.now().toIso8601String(),
});
```

#### (B) Read (ဒေတာများ ပြန်ထုတ်ယူခြင်း)
query() method သည် List<Map<String, dynamic>> ကို ပြန်ပေးပါတယ်။

```dart
Future<List<Map<String, dynamic>>> getAllLiabilities() async {
  final db = await instance.database;
  return await db.query('liabilities', orderBy: 'id DESC');
}
```

#### (C) Update (ဒေတာ ပြင်ဆင်ခြင်း)
SQL Injection ကာကွယ်ဖို့အတွက် whereArgs ကို အသုံးပြုရပါတယ်။

```dart
Future<int> updateLiability(Map<String, dynamic> row) async {
  final db = await instance.database;
  final id = row['id'];

  return await db.update(
    'liabilities',
    row,
    where: 'id = ?',     // Placeholder သုံးပါ
    whereArgs: [id],     // Value ကို သီးသန့် ပို့ပေးပါ
  );
}
```

#### (D) Delete (ဒေတာ ဖျက်ခြင်း)
```dart
Future<int> deleteLiability(int id) async {
  final db = await instance.database;

  return await db.delete(
    'liabilities',
    where: 'id = ?',
    whereArgs: [id],
  );
}
```


### 4. Model Class နဲ့ sqflite ကို တွဲဖက်သုံးပုံ
Map<String, dynamic> အစား Model Object ကို ရိုက်ထည့်နိုင်ရန် Model Class ထဲတွင် toMap() နှင့် fromMap() တို့ကို ရေးသားထားသင့်ပါတယ်။

```dart
class LiabilityModel {
  final int? id;
  final String lenderName;
  final double totalAmount;

  LiabilityModel({this.id, required this.lenderName, required this.totalAmount});

  // Database ထဲ ထည့်ရန် Map သို့ ပြောင်းခြင်း
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lenderName': lenderName,
      'totalAmount': totalAmount,
    };
  }

  // Database ထဲမှ ပြန်လာသော Map ကို Object သို့ ပြောင်းခြင်း
  factory LiabilityModel.fromMap(Map<String, dynamic> map) {
    return LiabilityModel(
      id: map['id'] as int?,
      lenderName: map['lenderName'] as String,
      totalAmount: (map['totalAmount'] as num).toDouble(),
    );
  }
}
```

