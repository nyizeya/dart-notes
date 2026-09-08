# Constructors

Dart မှာ Constructor ဆိုတာ Class ရဲ့ Object (Instance) ကို စတင်တည်ဆောက်ပေးတဲ့ အထူး Method ဖြစ်ပါတယ်။ Dart မှာ သုံးလေ့ရှိတဲ့ အဓိက Constructor အမျိုးအစား ၄ မျိုး ရှိပါတယ် -

### 1. Generative Constructor (အခြေခံ Constructor)
Class တစ်ခုရဲ့ Object ကို အသစ်တည်ဆောက်ပေးတဲ့ အခြေခံအကျဆုံး Constructor ဖြစ်ပါတယ်။ Class နာမည်နဲ့ တူအောင် ရေးသားရပါတယ်။

```dart
class Person {
  String name;
  int age;

  // Generative Constructor (Short-form syntax)
  Person(this.name, this.age);
}

void main() {
  var p = Person("Aung Aung", 25);
  print("${p.name} - ${p.age}"); // Output: Aung Aung - 25
}
```

### 2. Named Constructor (နာမည်တပ် Constructor)
Class တစ်ခုထဲမှာ Constructor တစ်ခုထက်ပိုပြီး သီးသန့် ရည်ရွယ်ချက်အလိုက် ခွဲခြားတည်ဆောက်ချင်တဲ့အခါ သုံးပါတယ်။ ClassName.constructorName ဆိုတဲ့ Syntax ကို သုံးပါတယ်။

```dart
class User {
  String name;
  String role;

  // Standard Constructor
  User(this.name, this.role);

  // Named Constructor (Admin အတွက် သီးသန့်ဆောက်ခြင်း)
  User.admin(this.name) : role = "Admin";

  // Named Constructor (Guest အတွက် သီးသန့်ဆောက်ခြင်း)
  User.guest()
      : name = "Guest User",
        role = "Visitor";
}

void main() {
  var admin = User.admin("Kyaw Kyaw");
  var guest = User.guest();

  print("${admin.name}: ${admin.role}"); // Output: Kyaw Kyaw: Admin
  print("${guest.name}: ${guest.role}"); // Output: Guest User: Visitor
}
```


### 3. Const Constructor (ကိန်းသေ Constructor)
Object ရဲ့ Data တွေကို ပြောင်းလဲလို့မရအောင် (Immutable) လုပ်ချင်တဲ့အခါ သုံးပါတယ်။

- Class ရဲ့ Variable အားလုံးဟာ final ဖြစ်ရပါမယ်။

- App run နေချိန် Memory တူညီတဲ့ Object တွေကို Re-use ပြန်လုပ်ပေးတဲ့အတွက် Flutter UI performance ကို ပိုမိုကောင်းမွန်စေပါတယ်။

```dart
class Point {
  final double x;
  final double y;

  // Const Constructor
  const Point(this.x, this.y);
}

void main() {
  // const သုံးထားသောကြောင့် Memory address တစ်ခုတည်းကို ရညွန်းပါသည်
  var p1 = const Point(10, 20);
  var p2 = const Point(10, 20);

  print(identical(p1, p2)); // Output: true (Object နှစ်ခု တူညီသည်)
}
```

### 4. Factory Constructor (ဆန်းသစ်သော Constructor)
အမြဲတမ်း Object အသစ်တစ်ခု မဖန်တီးဘဲ ယခင်ရှိပြီးသား Object ကို ပြန်ပေးချင်တဲ့အခါ (Cache) သို့မဟုတ် Child Class ရဲ့ Object ကို ပြန်ပေးချင်တဲ့အခါ သုံးပါတယ်။ factory Keyword ကို သုံးပြီး return ပြန်ပေးရပါတယ်။

```dart
class Logger {
  final String name;
  static final Map<String, Logger> _cache = {};

  // Internal Constructor
  Logger._internal(this.name);

  // Factory Constructor
  factory Logger(String name) {
    // Cache ထဲမှာ ရှိပြီးသားဆိုရင် အဟောင်းကိုပဲ ပြန်ပေးမည်
    if (_cache.containsKey(name)) {
      return _cache[name]!;
    } else {
      // မရှိသေးရင် အသစ်ဆောက်ပြီး Cache ထဲထည့်မည်
      final logger = Logger._internal(name);
      _cache[name] = logger;
      return logger;
    }
  }
}

void main() {
  var logger1 = Logger("UI");
  var logger2 = Logger("UI");

  print(identical(logger1, logger2)); // Output: true (Cache ထဲမှ Object အဟောင်းကို ပြန်ရသည်)
}
```

