# Syntactic Sugar

Dart ရဲ့ Syntactic Sugar (ကုဒ်ရေးရတာ ပိုတိုပြီး ဖတ်ရလွယ်အောင် ကူညီပေးတဲ့ Syntax လှလှလေးများ) အကြောင်းကို မြန်မာလို အသေးစိတ် ဆက်လက်လေ့လာကြရအောင်။

### 1. Initializing Formals (this. သုံးပြီး တိုက်ရိုက် တန်ဖိုးထည့်ခြင်း)
Class တစ်ခုရဲ့ Variable (Field) တွေထဲကို တန်ဖိုးထည့်ဖို့ Constructor ထဲမှာ Parameter လက်ခံပြီး မလိုအပ်ဘဲ ပြန် assign လုပ်နေစရာ မလိုပါဘူး။ Parameter မှာတင် this. ကို တွဲသုံးလိုက်တာနဲ့ Dart က အလိုအလျောက် တန်ဖိုးထည့်ပေးသွားပါတယ်။

```dart
class User {
  final String name;
  final int age;

  // ကုဒ် အများကြီး ရေးစရာ မလိုဘဲ တိုတိုရှင်းရှင်း ရေးနိုင်ပါတယ်
  const User(this.name, this.age);
}
```

### 2. Super Parameters (super. သုံးပြီး Parent Class ထံ တန်ဖိုးပို့ခြင်း)
Parent Class (Superclass) ကို extends လုပ်ထားတဲ့အခါ Parent Constructor ဆီ တန်ဖိုးလှမ်းပို့ဖို့ super.fieldName ကို သုံးနိုင်ပါတယ်။

```dart
class Person {
  final String name;
  Person(this.name);
}

class Employee extends Person {
  final double salary;

  // 'name' ကို Parent Class (Person) ထဲ တိုက်ရိုက် ပို့ပေးသွားပါတယ်
  Employee(super.name, this.salary);
}
```

### 3. Cascade Operator (.. သို့မဟုတ် ?..)
Object တစ်ခုတည်းရဲ့ Method သို့မဟုတ် Property တွေကို စာကြောင်းပေါင်းများစွာ ဆက်တိုက် ခေါ်ချင်တဲ့အခါ Variable နာမည်ကို ထပ်ခါထပ်ခါ ရေးစရာမလိုဘဲ .. ကို သုံးနိုင်ပါတယ်။

```dart
class Profile {
  String name = '';
  int age = 0;
  void save() => print('Saved!');
}

void main() {
  // Cascade syntax sugar သုံးထားပုံ
  final profile = Profile()
    ..name = 'Aung Aung'
    ..age = 25
    ..save(); // Variable နာမည် (profile) ကို ထပ်ခေါ်စရာ မလိုပါဘူး
}
```

### 4. Expression-Bodied Syntax (=> Arrow Functions)
Method သို့မဟုတ် Getter ထဲမှာ Statement တစ်ကြောင်းတည်း သို့မဟုတ် တန်ဖိုးတစ်ခုတည်း ပြန်ပေးရုံဆိုရင် { return ...; } အစား => (arrow) ကို သုံးပြီး တိုတိုတုတ်တုတ် ရေးနိုင်ပါတယ်။

```dart
class Rectangle {
  final double width;
  final double height;

  Rectangle(this.width, this.height);

  // Getter ကို တိုတိုလေး ရေးထားပုံ
  double get area => width * height;

  // Method ကို တိုတိုလေး ရေးထားပုံ
  void printArea() => print('Area is $area');
}
```


၅. Extension Methods (Class တွေမှာ Method အသစ် တိုးချဲ့ခြင်း)
Dart ရဲ့ Built-in Class တွေ (ဥပမာ String, double, List) သို့မဟုတ် ကိုယ်ပိုင် Class တွေကို မူရင်း Source Code ကို သွားမပြင်ဘဲ Function/Method အသစ်တွေ ထပ်တိုးပေးလို့ရပါတယ်။

```dart
extension CurrencyFormat on double {
  String toKyats() => '${toStringAsFixed(0)} MMK';
}

void main() {
  double price = 15000.0;
  print(price.toKyats()); // Output: 15000 MMK
}
```

