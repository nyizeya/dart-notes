# OOP
Dart မှာ Object-Oriented Programming (OOP) ရဲ့ အဓိက တိုင်ကြီး ၄ တိုင် (4 Pillars) ဖြစ်တဲ့ Encapsulation, Inheritance, Polymorphism, နဲ့ Abstraction တို့ကို အသေးစိတ် လေ့လာကြည့်ကြပါစို့။

1. Class & Object (အခြေခံ အယူအဆ)
- Class: Object တစ်ခု တည်ဆောက်ဖို့အတွက် ရေးဆွဲထားတဲ့ Blueprint (ပုံစံခွက်) ဖြစ်ပါတယ်။

- Object: Class ကို အခြေခံပြီး တကယ်တည်ဆောက်လိုက်တဲ့ ဒေတာ/အရာဝတ္ထု (Instance) ဖြစ်ပါတယ်။

```dart
class Car {
  String brand;
  int year;

  // Constructor
  Car(this.brand, this.year);

  void drive() {
    print("$brand က မောင်းနှင်နေပါပြီ။");
  }
}

void main() {
  // Object ဖန်တီးခြင်း
  var myCar = Car("Toyota", 2022);
  myCar.drive(); // Output: Toyota က မောင်းနှင်နေပါပြီ။
}
```

2. Encapsulation (ဒေတာများကို ကာကွယ်ခြင်း)
Class ထဲက Variable တွေကို ပြင်ပကနေ တိုက်ရိုက် မပြင်နိုင်အောင် Private Variable (_) အဖြစ် သတ်မှတ်ပြီး Getter/Setter ထည့်သွင်းပေးတာ ဖြစ်ပါတယ်။

> မှတ်ချက်: Dart မှာ Private ဖြစ်ဖို့ Variable နာမည်ရှေ့မှာ _ (Underscore) ခံပေးရပါတယ်။

```dart
class BankAccount {
  double _balance = 0; // Private Variable

  // Getter (ဒေတာ ရယူရန်)
  double get balance => _balance;

  // Setter (ဒေတာ ထည့်သွင်းရန် စစ်ဆေးချက်ဖြင့်)
  set deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
    }
  }
}

void main() {
  var account = BankAccount();
  account.deposit = 100; // Setter ခေါ်သုံးခြင်း
  print("ငွေလက်ကျန်: ${account.balance}"); // Output: ငွေလက်ကျန်: 100.0
}
```

3. Inheritance (အမွေဆက်ခံခြင်း)
Parent Class ရဲ့ Properties/Methods တွေကို Child Class က extends Keyword သုံးပြီး ပြန်လည်ရယူသုံးစွဲတာ ဖြစ်ပါတယ်။

```dart
class Animal {
  void eat() => print("အစာစားနေပါတယ်");
}

// Animal ထံမှ အမွေဆက်ခံခြင်း
class Dog extends Animal {
  void bark() => print("ဟောင်နေပါတယ်");
}

void main() {
  var dog = Dog();
  dog.eat();  // Parent ဆီက ရလာသော Method (Output: အစာစားနေပါတယ်)
  dog.bark(); // မိမိကိုယ်ပိုင် Method (Output: ဟောင်နေပါတယ်)
}
```

4. Polymorphism (ပုံသဏ္ဌာန် အမျိုးမျိုး ပြောင်းလဲခြင်း)
Parent Class မှာ ပါတဲ့ Method ကို Child Class က @override လုပ်ပြီး မိမိလိုသလို ပြန်လည်ရေးသားတာ ဖြစ်ပါတယ်။

```dart
class Shape {
  void draw() => print("ပုံသဏ္ဌာန် ဆွဲနေသည်");
}

class Circle extends Shape {
  @override
  void draw() => print("စက်ဝိုင်း ဆွဲနေသည်");
}

class Square extends Shape {
  @override
  void draw() => print("လေးထောင့် ပုံဆွဲနေသည်");
}

void main() {
  List<Shape> shapes = [Circle(), Square()];
  for (var shape in shapes) {
    shape.draw(); // Output: စက်ဝိုင်း ဆွဲနေသည် -> လေးထောင့် ပုံဆွဲနေသည်
  }
}
```

5. Abstraction (အရေးကြီးသည်များကိုသာ ဖော်ပြခြင်း)
Class ရဲ့ အသေးစိတ် အလုပ်လုပ်ပုံကို ဝှက်ထားပြီး abstract class နဲ့ implements တို့ကို သုံးပြီး Blueprint သက်သက် ရေးဆွဲတာ ဖြစ်ပါတယ်။

abstract class ကို direct new လုပ်ပြီး Object ဆောက်လို့မရပါ။

Dart မှာ သီးသန့် interface keyword မရှိဘဲ Class တိုင်းဟာ Interface အနေနဲ့ implements လုပ်လို့ရပါတယ်။

```dart
abstract class RemoteControl {
  void turnOn();  // Abstract Method (Body မပါပါ)
  void turnOff();
}

class TVRemote implements RemoteControl {
  @override
  void turnOn() => print("TV ဖွင့်လိုက်ပြီ");

  @override
  void turnOff() => print("TV ပိတ်လိုက်ပြီ");
}
```