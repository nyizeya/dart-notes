# Isolates
> Flutter/Dart မှာ Isolates ဆိုတာ Multi-threading အတွက် အသုံးပြုတဲ့ သီးသန့် Memory Space တွေဖြစ်ပါတယ်။

Dart ဟာ အခြေခံအားဖြင့် Single-threaded (Single-Isolate) ဘာသာစကား ဖြစ်တာကြောင့် Event Loop ကိုသုံးပြီး Code တွေကို အစီအစဉ်အတိုင်း တန်းစီလုပ်ဆောင်ပါတယ်။ ဒါပေမဲ့ တွက်ချက်မှု အလွန်များတဲ့ Task တွေ လုပ်တဲ့အခါ UI Lag မဖြစ်အောင် Isolates တွေကို အသုံးပြုရပါတယ်။


### 1. What (Isolate ဆိုတာဘာလဲ)
OS ရဲ့ ရိုးရိုး Thread တွေနဲ့ မတူတဲ့ အချက်မှာ Dart Isolates တွေဟာ Memory မမျှဝေကြပါ (No Shared Memory)။

Isolate တစ်ခုချင်းစီမှာ မိမိပိုင် Memory Heap နဲ့ Event Loop သီးသန့်စီ ရှိပါတယ်။

Isolate နှစ်ခုကြားမှာ ဒေတာ လဲလှယ်ချင်ရင် Message Passing (Port များ) မှတစ်ဆင့်သာ ပေးပို့နိုင်ပါတယ်။


### 2. Why (ဘာကြောင့် သုံးရတာလဲ)
Dart ရဲ့ Main Thread (UI Thread) ပေါ်မှာ တွက်ချက်မှု ကြာမြင့်တဲ့ Task ကြီးတွေ (Heavy Calculations) run လိုက်ရင် UI Freeze/Lag ဖြစ်သွားပါမယ်။

Isolate သုံးရန် လိုအပ်သည့် နေရာများ:

ကြီးမားသော JSON Data များကို Parse လုပ်ခြင်း (Large JSON Parsing)

Images, Videos များကို Encrypt / Decrypt / Compress လုပ်ခြင်း

Database ထဲသို့ Data အများအပြား သိမ်းဆည်း/ရှာဖွေခြင်း

Complex Mathematical Calculations များ တွက်ချက်ခြင်း


### 3. How (ဘယ်လို အသုံးပြုမလဲ)
Dart မှာ Isolates ကို အဓိက နည်းလမ်း ၂ ခုနဲ့ ရေးသားနိုင်ပါတယ် -

**နည်းလမ်း (၁)** - Isolate.run() (အလွယ်ဆုံး နည်းလမ်း)
Task တစ်ခုတည်းကို Background မှာ ခဏသွားတွက်ပြီး ရလဒ်ပြန်ယူချင်တဲ့အခါ Dart 2.15+ ကစပြီး ပါလာတဲ့ Isolate.run() ကို သုံးနိုင်ပါတယ်။

```dart
import 'dart:isolate';

// Background မှာ သွားတွက်မည့် Heavy Function
int heavyCalculation(int count) {
  int sum = 0;
  for (int i = 0; i < count; i++) {
    sum += i;
  }
  return sum;
}

void main() async {
  print("Main Thread: UI အလုပ်လုပ်နေသည်...");

  // Background Isolate သို့ ပို့၍ တွက်ခိုင်းခြင်း
  int result = await Isolate.run(() => heavyCalculation(1000000000));

  print("ရလဒ်: $result");
  print("Main Thread: UI ဆက်လက် အလုပ်လုပ်နေသည်...");
}
```

**နည်းလမ်း (၂)** - ReceivePort & SendPort (အပြန်အလှန် ဒေတာ ပေးပို့ခြင်း)
Isolate နှစ်ခုကြား တိုက်ရိုက် Message ပေးပို့ ချိတ်ဆက်ချင်တဲ့အခါ Port များကို သုံးရပါတယ်။

```dart
import 'dart:isolate';

void backgroundTask(SendPort sendPort) {
  // Main Isolate သို့ Message ပြန်ပို့ခြင်း
  sendPort.send("Background Isolate ကနေ နှုတ်ဆက်ပါတယ်!");
}

void main() async {
  // ၁။ Main Thread ဘက်မှ Message လက်ခံမည့် Port ထောင်ခြင်း
  ReceivePort receivePort = ReceivePort();

  // ၂။ Isolate အသစ် စတင်ပြီး SendPort ထည့်ပေးလိုက်ခြင်း
  await Isolate.spawn(backgroundTask, receivePort.sendPort);

  // ၃။ Background ထံမှ ဒေတာ စောင့်ယူခြင်း
  receivePort.listen((message) {
    print("လက်ခံရရှိသော စာ: $message");
    receivePort.close(); // Port ပြန်ပိတ်ခြင်း
  });
}
```

### 4. Flutter ရဲ့ compute() Function
Flutter မှာ Isolate.run() နဲ့ ဆင်တူတဲ့ Top-level Helper Function တစ်ခုဖြစ်တဲ့ compute() ပါဝင်ပါတယ်။

```dart
import 'package:flutter/foundation.dart';

// Top-level သို့မဟုတ် Static Function ဖြစ်ရပါမည်
List<int> parseJsonData(String jsonString) {
  // Heavy Parsing Logic
  return [1, 2, 3, 4, 5];
}

void loadData() async {
  // compute ခေါ်လိုက်သည်နှင့် Flutter က Background Isolate ဆောက်ပြီး သွားတွက်ပေးပါမည်
  List<int> data = await compute(parseJsonData, "raw_json_string");
  print(data);
}
```

Summary (အနှစ်ချုပ်)
- Main Isolate: UI ရေးဆွဲခြင်းနှင့် User Input များကို လက်ခံခြင်းများ လုပ်ဆောင်သည်။

- Background Isolate: UI မထိခိုက်စေရန် Heavy Computation များကို နောက်ကွယ်မှ သီးသန့် တွက်ချက်ပေးသည်။

- Communication: SendPort နှင့် ReceivePort တို့ကို သုံး၍ သာ အချက်အလက် ကူးပြောင်းနိုင်၏။