# Stream & Subscription
Dart/Flutter မှာ Stream ဆိုတာ အချိန်တစ်ခုအတွင်း တဆက်တည်း စီးဆင်းလာမယ့် ဒေတာအစဉ်လိုက် (Sequence of Asynchronous Data) ကို ထိန်းချုပ်မောင်းနှင်ပေးတဲ့ စနစ်ဖြစ်ပါတယ်။

Future က တောင်းဆိုလိုက်တဲ့ ဒေတာ တစ်ခုတည်း (Single Value) ကိုပဲ ပြန်ပေးနိုင်ပေမဲ့ Stream ကတော့ စက်ရုံက ကုန်ထုတ် ပိုက်လိုင်းလိုမျိုး ဒေတာတွေကို အကြိမ်ကြိမ်/တောက်လျှောက် (Multiple Values over Time) ပို့ပေးနိုင်ပါတယ်။


### 1. Future နဲ့ Stream နှိုင်းယှဉ်ချက်
| အချက်              | Future                                |  Stream                                  |
| ------------------ | --------------------------------------| ---------------------------------------   |
| တန်ဖိုး ထွက်ရှိမှု       | ဒေတာ ၁ ခုသာ ပြန်ပေးသည်               | ဒေတာ အများအပြား တောက်လျှောက် စီးဆင်းသည် |
| ဥပမာ               | HTTP Request (API Call တစ်ခုခေါ်ခြင်း)   | Live Location Tracking, Chat Messaging   |
| Dart Keyword       | `async` / `await`                      | `async*` / `yield`                       |



### 2. Stream အမျိုးအစား ၂ မျိုး
Dart မှာ Stream ကို အမျိုးအစား ၂ မျိုး ခွဲခြားထားပါတယ် -

**(၁) Single-Subscription Stream (အခြေခံ)**
- Stream ကို Listen တစ်နေရာတည်းကပဲ လုပ်လို့ရပါတယ်။ (ဒုတိယအကြိမ် Listen လုပ်ရင် Error တက်ပါမယ်)

- ဥပမာ - File Read လုပ်ခြင်း၊ Network Download လုပ်ခြင်း။

**(၂) Broadcast Stream (အများသုံး)**
- Stream ကို နေရာအများအပြား (Multiple Listeners) ကနေ တစ်ပြိုင်နက်တည်း ဝင်ရောက် နားထောင်/ကြည့်ရှုလို့ရပါတယ်။

- ဥပမာ - Chat Application (Message အသစ်လာရင် UI ရော၊ Notification ရော၊ Sound ရော တစ်ပြိုင်နက် သိရှိရန်)။


### 3. Stream ဖန်တီးခြင်းနှင့် အသုံးပြုခြင်း (Code Example)
**နည်းလမ်း (၁) - async* နှင့် yield ကို သုံး၍ ဖန်တီးခြင်း**
- yield ဆိုတာ Stream ပိုက်လိုင်းထဲသို့ ဒေတာတစ်ခုချင်းစီ ပစ်ထည့်ပေးလိုက်တဲ့ Keyword ဖြစ်ပါတယ်။

```dart
// ၁။ ၁ စက္ကန့်လျှင် ဂဏန်း ၁ လုံးစီ ထုတ်ပေးမည့် Stream
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // Stream ထဲသို့ Data ပို့ပေးခြင်း
  }
}

void main() async {
  print("Stream စတင်ပါပြီ...");

  // ၂။ Stream ကို listen လုပ်၍ ဒေတာ စောင့်ယူခြင်း
  Stream<int> stream = countStream(5);
  
  stream.listen((data) {
    print("ရရှိသော တန်ဖိုး: $data");
  }, onDone: () {
    print("Stream ပြီးဆုံးသွားပါပြီ။");
  });
}
```

**နည်းလမ်း (၂) - StreamController ကို သုံး၍ ဖန်တီးခြင်း (အသုံးအများဆုံး)**
- လက်တွေ့ App ရေးတဲ့အခါ Event တွေကို ကိုယ်တိုင် ထိန်းချုပ်ချင်ရင် StreamController ကို သုံးပါတယ်။

```dart
import 'dart:async';

void main() {
  // Broadcast StreamController ဖန်တီးခြင်း
  final controller = StreamController<String>.broadcast();

  // Listener 1
  controller.stream.listen((message) {
    print("UI 1 က လက်ခံရရှိသည်: $message");
  });

  // Listener 2
  controller.stream.listen((message) {
    print("UI 2 က လက်ခံရရှိသည်: $message");
  });

  // Stream ထဲသို့ Data အသစ်များ ပစ်ထည့်ခြင်း
  controller.sink.add("မင်္ဂလာပါ။");
  controller.sink.add("Message ဒုတိယတစ်ခု။");

  // အသုံးပြုပြီးပါက Stream ကို ပိတ်ပေးရပါမည် (Memory Leak မဖြစ်စေရန်)
  controller.close();
}
```

### 4. Flutter UI မှာ StreamBuilder နဲ့ သုံးပုံ
Flutter မှာ Stream ကနေ လာတဲ့ ဒေတာတွေကို UI မှာ တိုက်ရိုက် ပြသချင်တဲ့အခါ StreamBuilder Widget ကို သုံးပါတယ်။

```dart
import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  // ၁ စက္ကန့်တိုင်း ဂဏန်းတိုးပေးမည့် Stream
  Stream<int> timerStream() async* {
    int count = 0;
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield count++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<int>(
          stream: timerStream(),
          builder: (context, snapshot) {
            // Data မရောက်သေးမီ Loading ပြရန်
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            // Data ရောက်လာပါက UI ကို အလိုအလျောက် Rebuild လုပ်ပေးမည်
            return Text(
              'Count: ${snapshot.data}',
              style: const TextStyle(fontSize: 30),
            );
          },
        ),
      ),
    );
  }
}
```

**အနှစ်ချုပ် (Key Takeaways)**
1. yield: Stream ထဲသို့ ဒေတာ ထည့်ပေးသည်။

2. listen(): Stream ထဲမှ ဒေတာများကို နားထောင် ရယူသည်။

3. StreamController: Stream ကို Manual ထိန်းချုပ်ရန် သုံးသည် (sink.add() ဖြင့် ဒေတာထည့်၊ close() ဖြင့် ပိတ်)။

4. StreamBuilder: Flutter UI နှင့် Stream ကို အလွယ်တကူ ချိတ်ဆက်ပေးသည်။