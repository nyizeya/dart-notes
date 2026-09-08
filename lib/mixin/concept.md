# Mixin
> Dart မှာ Mixin ဆိုတာ Class တစ်ခုထဲကို Code (Functions/Variables) တွေကို Class Hierarchy (Parent-Child Inheritance) မပြောင်းလဲဘဲ ပြန်လည်အသုံးပြုနိုင်အောင် (Code Reuse) ကပ်ပြီးထည့်ပေးတဲ့ နည်းလမ်းဖြစ်ပါတယ်။

### 1. What (Mixin ဆိုတာဘာလဲ)
Dart မှာ class တစ်ခုဟာ extends ကိုသုံးပြီး Parent Class တစ်ခုတည်း ဆီကပဲ Inherit လုပ်လို့ရပါတယ် (Single Inheritance)။ Parent Class မတူတဲ့ Class တွေကြားထဲမှာ Code တူတာတွေကို ပြန်သုံးချင်တဲ့အခါ Mixin ကို အသုံးပြုပါတယ်။ Mixin ကို Class မဟုတ်ဘဲ mixin ဆိုတဲ့ Keyword နဲ့ ရေးသားပါတယ်။  

### 2. Why (ဘာကြောင့် သုံးရတာလဲ)
Multiple Inheritance မရတာကို ဖြေရှင်းရန်: Dart မှာ Class တစ်ခုက Parent Class နှစ်ခုထံမှ တစ်ပြိုင်နက် Inheritance ယူလို့မရပါ (Multiple Inheritance Banned)။  Code Duplicate နည်းစေရန်: Class Dynamic Layout မတူပေမဲ့ စွမ်းရည် (Behavior) တူနေတဲ့ Class တွေမှာ Code အထပ်ထပ် မရေးရအောင် ကာကွယ်ပေးပါတယ်။  Boilerplate Code သက်သာရန်: Interface လိုမျိုး implements လုပ်ပြီး Code တွေကို လိုက် Override ပြန်ရေးစရာမလိုဘဲ တိုက်ရိုက်ယူသုံးနိုင်ပါတယ်။ 

### 3. How (ဘယ်လို ရေးသား/အသုံးပြုမလဲ)
Mixin ကို mixin Keyword နဲ့ ကြေညာပြီး Class မှာ ပြန်သုံးချင်ရင် with Keyword ကို သုံးရပါတယ်။  Example Code:

```dart
// ၁။ Mixin ကို ကြေညာခြင်း
mixin Swimmable {
  void swim() {
    print("ရေကူးနေပါတယ်...");
  }
}

mixin Flyable {
  void fly() {
    print("ပျံသန်းနေပါတယ်...");
  }
}

// Parent Class
class Animal {}

// ၂။ Class မှာ with သုံးပြီး Mixin များကို ယူသုံးခြင်း
class Duck extends Animal with Swimmable, Flyable {
  // ဘဲသည် ရေလည်းကူးနိုင်၊ ပျံလည်းပျံနိုင်သည်
}

class Fish extends Animal with Swimmable {
  // ငါးသည် ရေပဲကူးနိုင်သည်
}

void main() {
  var duck = Duck();
  duck.swim(); // Output: ရေကူးနေပါတယ်...
  duck.fly();  // Output: ပျံသန်းနေပါတယ်...

  var fish = Fish();
  fish.swim(); // Output: ရေကူးနေပါတယ်...
}
```
**မှတ်ချက်: Mixin တစ်ခုတွင် Constructor (ClassName()) ရေးလို့ မရပါ။**

### 4. Where (ဘယ်လိုနေရာတွေမှာ သုံးတာများလဲ)
Flutter Framework ထဲမှာ:Animation တွေရေးတဲ့အခါ SingleTickerProviderStateMixin ကို with နဲ့ တွဲသုံးလေ့ရှိပါတယ်။  Common Logic များကို ခွဲထုတ်ချင်သည့်အခါ:ဥပမာ - Log ထုတ်ပေးတဲ့ Function (Logger), Network Connection စစ်ပေးတဲ့ Logic, Validation စတာတွေကို App ရဲ့ နေရာတော်တော်များများမှာ ပြန်သုံးချင်သည့်အခါ။  on Clause ဖြင့် ကန့်သတ်သုံးစွဲချင်သည့်အခါ:Mixin ကို သီးသန့် Class အချို့မှာပဲ သုံးခွင့်ပေးချင်ရင် on ကို သုံးနိုင်ပါတယ်။  

```dart
// Animal Class သို့မဟုတ် Animal ရဲ့ Child Class တွေမှာပဲ အသုံးပြုခွင့်ပေးမည်
mixin Walker on Animal {
  void walk() => print("လမ်းလျှောက်နေသည်");
}
```