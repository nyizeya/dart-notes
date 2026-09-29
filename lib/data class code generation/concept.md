# Dart Model Class Generation
### freezed build_runner json_serializable freezed_annotation json_annotation
Flutter ecosystem မှာ ဒီ libraries ၅ ခုကို တွဲတွေ့ရတာ အရမ်းများပါတယ်။ အဓိက idea က Dart model class တွေကို boilerplate code မရေးဘဲ code generation နဲ့ အလိုအလျောက် generate လုပ်ပေးခြင်း ပါ။

အရင်ဆုံး relationship ကို ဒီလိုမြင်ရင် လွယ်ပါတယ်—

```
Your Dart Model
     │
     ├── freezed_annotation
     │        ↓
     │      freezed
     │        ↓
     │   generated code
     │
     ├── json_annotation
     │        ↓
     │   json_serializable
     │        ↓
     │   generated JSON code
     │
     └──────────────┐
                    ↓
              build_runner
         (generation ကို run ပေးသူ)
```

### 1. Library တစ်ခုချင်းစီက ဘာလဲ?
```
| Library              | အလုပ်                                                                        |
| -------------------- | ---------------------------------------------------------------------------- |
| `freezed`            | Immutable model, `copyWith`, equality, sealed classes စတဲ့ code တွေ generate |
| `freezed_annotation` | `freezed` သုံးဖို့ လိုတဲ့ annotations                                        |
| `json_serializable`  | Dart object ↔ JSON conversion code generate                                  |
| `json_annotation`    | JSON-related annotations (`@JsonSerializable`, `@JsonKey`)                   |
| `build_runner`       | အပေါ်က code generators တွေကို run ပေးတဲ့ engine                              |

```

အရေးကြီးတာက—

freezed နဲ့ json_serializable က code generator တွေ၊ build_runner က အဲဒီ generator တွေကို run ပေးတဲ့ tool ပါ။

### 2. ဘာကြောင့် ဒီ libraries တွေလိုတာလဲ?

Suppose API က ဒီ JSON ပြန်ပေးတယ်—

```json
{
  "id": 1,
  "name": "Nyi Zeya",
  "email": "nyi@example.com"
}
```

Normal Dart နဲ့ manually model ရေးမယ်ဆိုရင်—

```dart
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object other) {
    // ...
  }

  @override
  int get hashCode {
    // ...
  }
}
```

Model ကြီးလာရင် boilerplate အရမ်းများလာပါတယ်။

Freezed + JSON Serializable သုံးရင်—

```dart
@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
```

ဒါပဲ ရေးရပါတယ်။

ကျန်တဲ့ code တွေကို generator က generate လုပ်ပေးပါတယ်။

### 3. freezed ဆိုတာဘာလဲ?

freezed က Dart model classes တွေအတွက် immutable data class / union/sealed class code generation library ဖြစ်ပါတယ်။

အဓိကအားဖြင့်—

Immutable objects
copyWith()
==
hashCode
toString()
Union / sealed classes
Pattern matching
JSON integration

စတာတွေကို generate လုပ်ပေးပါတယ်။

Without Freezed

```dart
final user = User(
  id: 1,
  name: 'Nyi Zeya',
);
```

user.name ကို တိုက်ရိုက်ပြောင်းလို့မရအောင် immutable model ဖြစ်အောင် manually code အများကြီးရေးရနိုင်ပါတယ်။

Freezed သုံးရင်—

```dart
@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String name,
  }) = _User;
}
```

Generated code က User ကို immutable ဖြစ်အောင် handle လုပ်ပေးပါတယ်။

### 4. freezed_annotation က ဘာလဲ?

ဒါက freezed ရဲ့ annotation package ပါ။

ဥပမာ—

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
```

ပြီးရင်—

```dart
@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String name,
  }) = _User;
}
```

ဒီ @freezed annotation ကို Dart compiler က သူ့အလိုလို သိတာမဟုတ်ပါဘူး။

freezed_annotation က annotation definitions တွေ ပေးထားတာပါ။

Simple analogy

```
freezed_annotation
        ↓
"ဒီ class ကို Freezed နဲ့ generate လုပ်ပါ"
        ↓
       @freezed
```

ပြီးတော့ freezed package က အဲဒီ instruction ကိုဖတ်ပြီး generated code ကို ဖန်တီးပါတယ်။

### 5. json_serializable ဆိုတာဘာလဲ?

ဒီ library ရဲ့အလုပ်က—

```
Dart Object
    ↕
JSON
```

conversion code generate လုပ်ပေးတာပါ။

ဥပမာ API response—

```json
{
  "id": 1,
  "name": "Nyi Zeya"
}
```

Dart object—

```dart
User(
  id: 1,
  name: 'Nyi Zeya',
)
```

JSON → Dart

```dart
User.fromJson(json);
```

Dart → JSON

```dart
user.toJson();
```

ဒီ conversion logic ကို manually မရေးချင်လို့ json_serializable သုံးတာပါ။

### 6. json_annotation က ဘာလဲ?

ဒါက json_serializable အတွက် annotation package ပါ။

ဥပမာ—

```dart
import 'package:json_annotation/json_annotation.dart';
```

ပြီးတော့—

```dart
@JsonSerializable()
class User {
  final int id;
  final String name;

  User({
    required this.id,
    required this.name,
  });
}
```

@JsonSerializable() က—

"ဒီ class အတွက် JSON serialization code generate လုပ်ပါ"

ဆိုတဲ့ instruction ဖြစ်ပါတယ်။


### 7. build_runner က ဘာလုပ်တာလဲ?

ဒီတစ်ခုက အရေးကြီးပါတယ်။

**freezed / json_serializable** တွေက generator တွေရှိပေမယ့် သူတို့ကို တိုက်ရိုက် execute မလုပ်ပါဘူး။

**build_runner** က—

*"Project ထဲမှာ code generator တွေ run လုပ်ပြီး generated Dart files တွေ ဖန်တီးပေးမယ့် tool"*

ဖြစ်ပါတယ်။

ဥပမာ—
```bash
dart run build_runner build
```

သို့မဟုတ် Flutter project မှာ—

```bash
flutter pub run build_runner build
```

အသုံးပြုနိုင်ပါတယ်။

အသစ်သော Dart/Flutter project တွေမှာ ပထမ command ကို အသုံးများပါတယ်။


### 8. အခု ၅ ခုလုံး ဘယ်လိုအလုပ်လုပ်ကြလဲ?

ဒီ model ကိုကြည့်ပါ—

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
```

ဒီနေရာမှာ အရေးကြီးတာတွေက—

```dart
@freezed
```

Freezed ကို—

***"ဒီ class အတွက် generated immutable model code လုပ်ပါ"***

လို့ပြောတာ။

```dart
part 'user.freezed.dart';
```

ဒါက Freezed generate လုပ်မယ့် file ကို ဒီ Dart library ရဲ့ part အဖြစ် ထည့်ထားတာ။

```dart
part 'user.g.dart';
```

ဒါက JSON serialization generated file ကို ထည့်ထားတာ။

```dart
factory User.fromJson(...)
```

ဒါက generated JSON function ကို အသုံးပြုတာ—

### 9. part ဆိုတာဘာလဲ?

```dart
part 'user.freezed.dart';
part 'user.g.dart';
```

ဒါတွေကို Dart part directives လို့ခေါ်ပါတယ်။

ဒါဟာ—

*user.freezed.dart နဲ့ user.g.dart ဟာ user.dart library ရဲ့ source code အစိတ်အပိုင်းတွေဖြစ်တယ်*

ဆိုတဲ့ concept ပါ။

Conceptually—

```
user.dart
   │
   ├── user.freezed.dart
   │
   └── user.g.dart
```

Generator က—

```
user.dart
    ↓
build_runner
    ↓
┌─────────────────────┐
│ freezed generator   │
│ json generator      │
└─────────────────────┘
    ↓
user.freezed.dart
user.g.dart
```

ဖန်တီးပေးပါတယ်။


### 10. Complete Example

Project မှာ dependencies ထည့်မယ်။

```yaml
dependencies:
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.7.0
  freezed: ^3.2.0
  json_serializable: ^6.11.0
```

**user.dart**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
```

ပြီးရင် run—


```bash
dart run build_runner build
```
Generator က—
```dart
user.freezed.dart
user.g.dart
```
ဆိုပြီး files နှစ်ခု generate လုပ်ပေးပါလိမ့်မယ်။

### 11. Generated code က ဘာတွေပါလဲ?

ဥပမာ user.freezed.dart ထဲမှာ conceptually ဒီလို code တွေ generate ဖြစ်ပါတယ်—

```dart
class _User implements User {
  const _User({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  final int id;

  @override
  final String name;

  @override
  final String email;

  @override
  User copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    // generated implementation
  }

  @override
  bool operator ==(Object other) {
    // generated equality
  }

  @override
  int get hashCode {
    // generated hash
  }
}
```