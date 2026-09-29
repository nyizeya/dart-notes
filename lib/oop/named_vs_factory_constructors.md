# Named Vs Factory Constuctor
Dart ရဲ့ Named Constructor နဲ့ Factory Constructor နှစ်ခုလုံးဟာ Object တွေကို နည်းလမ်းအမျိုးမျိုးနဲ့ ဖန်တီးဖို့ သုံးကြပေမဲ့ အလုပ်လုပ်ပုံနဲ့ ရည်ရွယ်ချက် လုံးဝ မတူကြပါဘူး။

### ၁။ Named Constructor ဆိုတာ ဘာလဲ။
*Class တစ်ခုထဲမှာ Constructor တစ်ခုထက်မက ခေါ်ယူဖန်တီးချင်တဲ့အခါ နာမည်သီးသန့် တပ်ပေးထားသော Constructor ဖြစ်ပါတယ်။*

**အဓိက အချက်**: ခေါ်လိုက်တိုင်း မူရင်း Class ရဲ့ Instance အသစ် (New Instance) ကိုပဲ အမြဲတမ်း မဖြစ်မနေ ထုတ်ပေးပါတယ်။

**ကန့်သတ်ချက်**: return statement ရေးခွင့်မရှိပါဘူး။ Subclass (Child Class) ရဲ့ Object ကိုလည်း ပြန်ပေးလို့ မရပါဘူး။

```dart
class User {
  final String name;
  final String role;

  // 1. Default Constructor
  User(this.name, this.role);

  // 2. Named Constructor (အမည်တပ်ထားသော Constructor)
  User.admin(this.name) : role = 'Admin';

  // 3. နောက်ထပ် Named Constructor တစ်ခု
  User.guest()
      : name = 'Guest User',
        role = 'Visitor';
}

void main() {
  final user1 = User('Aung Aung', 'Developer');
  final admin = User.admin('Kyaw Kyaw'); // Named constructor သုံးထားပုံ
  final guest = User.guest();           // Named constructor သုံးထားပုံ
}
```

### ၂။ Factory Constructor ဆိုတာ ဘာလဲ။ (factory keyword)
Constructor တစ်ခုကို ခေါ်လိုက်တဲ့အခါ Instance အသစ် အမြဲ မဆောက်ဘဲ အဟောင်း (Cache) ကို ပြန်ပေးချင်တာ သို့မဟုတ် Subclass ရဲ့ Instance ကို ပြန်ပေးချင်တာ မျိုးမှာ factory keyword ကို သုံးပါတယ်။

**အဓိက အချက်**: return statement ကို စိတ်ကြိုက် သုံးနိုင်ပါတယ်။

**လုပ်ဆောင်နိုင်စွမ်း**:
```
ရှိပြီးသား Object ကိုပဲ ပြန်ပေးနိုင်တယ် (Caching / Singleton)။

အခြေအနေပေါ် မူတည်ပြီး Subclass (Child Class) တစ်ခုခုရဲ့ Object ကို ပြန်ပေးနိုင်ပါတယ်။
```

```dart
class Database {
  final String name;
  
  // Singleton အတွက် သီးသန့် Cache သိမ်းရန် variable
  static Database? _instance;

  // Private Named Constructor (အပြင်က တိုက်ရိုက် ခေါ်လို့မရအောင် လုပ်ထားခြင်း)
  Database._internal(this.name);

  // Factory Constructor
  factory Database() {
    // Instance ရှိပြီးသားဆိုရင် အဟောင်းကိုပဲ ပြန်ပေးမည်
    // မရှိသေးရင်မှ အသစ်ဆောက်မည်
    _instance ??= Database._internal('MainDB');
    return _instance!;
  }
}

void main() {
  final db1 = Database();
  final db2 = Database();

  print(identical(db1, db2)); // true (Instance တစ်ခုတည်းကိုပဲ ပြန်ပေးထားခြင်းဖြစ်သည်)
}
```