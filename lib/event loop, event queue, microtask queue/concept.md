# Event Loop၊ Event Queue နဲ့ Microtask Queue
Dart ရဲ့ Asynchronous Programming (Future, async/await, Stream) တွေ အလုပ်လုပ်ပုံကို နားလည်ဖို့ Event Loop၊ Event Queue နဲ့ Microtask Queue တို့ရဲ့ သဘောတရားကို သိရှိထားဖို့ လိုအပ်ပါတယ်။

### 1. အဓိက အစိတ်အပိုင်းများ (Core Components)
Dart ထဲမှာ Task တွေကို အောက်ပါ အစိတ်အပိုင်း ၃ ခုနဲ့ စီမံခန့်ခွဲပါတယ် -

Event Loop: Queue ထဲမှာ တန်းစီနေတဲ့ Task တွေကို တစ်ခုပြီးတစ်ခု အမြဲမပြတ် စစ်ဆေးပြီး Execute လုပ်ပေးနေတဲ့ ခေါင်းဆောင် (Infinite Loop) ဖြစ်ပါတယ်။

Microtask Queue: အရေးကြီးပြီး အမြန်ဆုံး/ပထမဆုံး အလုပ်လုပ်ရမယ့် သေးငယ်တဲ့ Internal Task တွေ တန်းစီတဲ့ နေရာဖြစ်ပါတယ်။

Event Queue: ပြင်ပကလာတဲ့ Task တွေဖြစ်တဲ့ User I/O (Screen Tap, Gesture)၊ Timer (Future.delayed)၊ File Read/Write၊ Network API Call Response စတာတွေ တန်းစီတဲ့ နေရာဖြစ်ပါတယ်။

### 2. Event Loop အလုပ်လုပ်ပုံ Diagram
Event Loop ဟာ Microtask Queue လွတ်သွားမှသာ Event Queue ထဲက Task တွေကို စတင် အလုပ်လုပ်ပေးပါတယ်။

                       ┌─────────────────────────┐
                       │     Main Execution      │
                       │   (Synchronous Code)    │
                       └────────────┬────────────┘
                                    │
                                    ▼
                       ┌─────────────────────────┐
                       │  Microtask Queue မှာ     │
                       │   Task ကျန်သေးလား?     │
                       └────┬───────────────┬────┘
                            │               │
                      (Yes) │               │ (No)
                            ▼               ▼
              ┌──────────────────┐    ┌──────────────────┐
              │ Execute Microtask│    │   Event Queue မှာ │
              └─────────┬────────┘    │ Task ကျန်သေးလား?│
                        │             └─────┬────────┬───┘
                        │                   │        │
                        └───────────────────┘ (Yes)  │ (No)
                                  ▲                  │
                                  │   Execute Event  │
                                  └──────────────────┘
#### ဦးစားပေးအဆင့် (Priority Order):

1. Synchronous Code (ရိုးရိုး Code များကို မူလအတိုင်း အရင် run မည်)

2. Microtask Queue (သီးသန့် မပြီးမချင်း အကုန် run မည်)

3. Event Queue (Microtask Queue လွတ်မှသာ ၁ ခုချင်းစီ run မည်)


### 3. လက်တွေ့ Code နမူနာနှင့် အစဉ်လိုက် ထွက်ရှိပုံ
အောက်ပါ Code ကို run ကြည့်ပါက Event Loop ရဲ့ ဦးစားပေး စနစ်ကို ရှင်းလင်းစွာ မြင်တွေ့နိုင်ပါတယ် -

```dart
import 'dart:async';

void main() {
  print('1. Synchronous Code (Start)');

  // Event Queue ထဲသို့ ရောက်သွားမည်
  Future(() {
    print('2. Event Queue (Future)');
  });

  // Microtask Queue ထဲသို့ ရောက်သွားမည်
  scheduleMicrotask(() {
    print('3. Microtask Queue (Microtask)');
  });

  // Event Queue ထဲသို့ ရောက်သွားမည် (Timer)
  Future.delayed(Duration.zero, () {
    print('4. Event Queue (Future Delayed)');
  });

  // Microtask Queue ထဲသို့ ရောက်သွားမည်
  Future.microtask(() {
    print('5. Microtask Queue (Future.microtask)');
  });

  print('6. Synchronous Code (End)');
}
```

#### Output ထွက်ရှိလာမည့် အစဉ်လိုက် (Execution Order):
```bash
1. Synchronous Code (Start)
6. Synchronous Code (End)
3. Microtask Queue (Microtask)
5. Microtask Queue (Future.microtask)
2. Event Queue (Future)
4. Event Queue (Future Delayed)
```

### 4. ဘာကြောင့် ဒီလို ထွက်လာတာလဲ (Explanation)
1 နှင့် 6: ရိုးရိုး Synchronous Code များဖြစ်သောကြောင့် Call Stack ပေါ်တွင် အရင်ဆုံး တိုက်ရိုက် run သွားသည်။

3 နှင့် 5: Microtask Queue ထဲသို့ ရောက်ရှိသွားသောကြောင့် Synchronous Code ပြီးသည်နှင့် Event Queue ထက် ဦးစားပေး အဆင့်ဖြင့် အရင် ရန်းသွားသည်။

2 နှင့် 4: Microtask Queue ထဲမှ Task များ အားလုံး ရှင်းလင်းသွားမှသာ Event Loop က Event Queue ထဲမှ Future များကို အစဉ်လိုက် ရန်းပေးသွားသည်။

**အနှစ်ချုပ်**
Dart ရဲ့ Single Thread စနစ်သည် Event Loop ပေါ်တွင် အခြေခံထားသည်။

UI လှုပ်ရှားမှုများ၊ Future များနှင့် Timer များသည် Event Queue သို့ ရောက်ရှိသည်။

အလွန် အရေးကြီး၍ UI မတုံ့ပြန်မီ အမြန် ရှင်းလင်းလိုသော Internal Logic များကို Microtask Queue သို့ ပို့နိုင်သည်။