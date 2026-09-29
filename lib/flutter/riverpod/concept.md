# Riverpod
Riverpod ဆိုတာ Flutter/Dart ရဲ့ ခေတ်မီပြီး အားကိုးရဆုံး State Management & Dependency Injection Framework တစ်ခု ဖြစ်ပါတယ်။

မူလ Provider package ကို တီထွင်ခဲ့သူ Rémi Rousselet ကပဲ Provider ရဲ့ အားနည်းချက်တွေကို အကုန် အဆင့်မြှင့်တင်ပြီး Re-architect လုပ်ကာ ထုတ်လုပ်ထားတာ ဖြစ်ပါတယ်။ (Riverpod ဆိုတဲ့ နာမည်က Provider ဆိုတဲ့ စာလုံးကို ပြန်စီထားတာ ဖြစ်ပါတယ်)။

### ၁။ Riverpod ဆိုတာ ဘာလဲ (What is it?)
Riverpod ဆိုတာ Flutter App ရဲ့ Data (State) တွေကို စီမံပေးပြီး၊ UI နဲ့ Business Logic တွေကို သီးသန့် ခွဲထုတ်ပေးတဲ့ Framework ဖြစ်ပါတယ်။

အဓိက ထူးခြားချက်ကတော့ Flutter ရဲ့ Widget Tree သို့မဟုတ် BuildContext ပေါ်မှာ မမှီခိုဘဲ သီးသန့် ကင်းလွတ်စွာ အလုပ်လုပ်နိုင်တာဖြစ်လို့ Compile-time Safety (ကုဒ်ရေးနေစဉ်မှာတင် Error ကို သိနိုင်ခြင်း) အပြည့်အဝ ရရှိပါတယ်။

### ၂။ ဘာအတွက် အသုံးပြုတာလဲ (What is it used for?)
State Management: UI ပေါ်မှာ ပြသနေတဲ့ ဒေတာတွေ (ဥပမာ - User Profile, Liabilities List, Counter) ပြောင်းလဲတိုင်း UI ကို အလိုအလျောက် Update လိုက်လုပ်ပေးရန်။

Dependency Injection (DI): Database Helpers, API Clients (Dio/Http), Repositories တွေကို App ရဲ့ ဘယ်နေရာကမဆို လွယ်လွယ်ကူကူ လှမ်းခေါ်သုံးနိုင်ရန်။

Async Data Fetching & Caching: API သို့မဟုတ် Local DB ကနေ ဒေတာ ဆွဲယူတဲ့အခါ (Loading, Error, Data) စတဲ့ အခြေအနေ ၃ ခုကို စနစ်တကျ တိုတိုရှင်းရှင်း ထိန်းချုပ်ပေးရန်။

### ၃။ ဘယ်အချိန်မှာ သုံးသင့်တာလဲ (When to use it?)
Medium to Large Scale Apps: Project အကြီးတွေ၊ Team နဲ့ ရေးရတဲ့ အခါမျိုးမှာ ကုဒ်တွေ ရှုပ်ထွေးမသွားအောင် သုံးသင့်ပါတယ်။

Unit/Integration Testing ရေးလိုသည့်အခါ: BuildContext မလိုတဲ့အတွက် State တွေကို Unit Test ရေးရတာ အလွန်လွယ်ကူသွားပါတယ်။

Async Data အများကြီး ထိန်းချုပ်ရသည့်အခါ: API Call တွေကို Auto-caching လုပ်ချင်တာ သို့မဟုတ် ပိတ်လိုက်တဲ့ စာမျက်နှာရဲ့ Data Memory ကို အလိုအလျောက် ရှင်းထုတ်ချင်တဲ့အခါ (autoDispose)။

### ၄။ Riverpod Demo Project
ဒီ Demo လေးမှာ Liabilities စာရင်းကို ထည့်တာ/ဖျက်တာကို Riverpod 2.0 ရဲ့ NotifierProvider သုံးပြီး ရေးပြထားပါတယ်။

#### အဆင့် ၁: Dependency ထည့်ပါ (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
```

#### အဆင့် ၂: App ကို ProviderScope ဖြင့် ပတ်ပါ (main.dart)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // App တစ်ခုလုံးမှာ Riverpod သုံးနိုင်အောင် ProviderScope ဖြင့် ပတ်ပေးရပါမယ်
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LiabilityScreen(),
    );
  }
}
```

#### အဆင့် ၃: Notifier နှင့် Provider ဆောက်ပါ
```dart
// 1. Business Logic နှင့် State စီမံမည့် Notifier Class
class LiabilitiesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    // Initial State
    return ['KBZ Bank Loan', 'Credit Card Bill'];
  }

  void addLiability(String title) {
    state = [...state, title]; // Immutable update
  }

  void removeLiability(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i]
    ];
  }
}

// 2. Global Provider ကြေညာခြင်း
final liabilitiesProvider =
    NotifierProvider<LiabilitiesNotifier, List<String>>(LiabilitiesNotifier.new);
```

#### အဆင့် ၄: UI တွင် ConsumerWidget သုံးပြီး စာမျက်နှာ ဆွဲပါ
```dart
class LiabilityScreen extends ConsumerWidget {
  const LiabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch ကို သုံးပြီး State ပြောင်းတိုင်း UI ကို အလိုအလျောက် ရေးဆွဲစေပါသည်
    final liabilities = ref.watch(liabilitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Liabilities Count: ${liabilities.length}'),
      ),
      body: ListView.builder(
        itemCount: liabilities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(liabilities[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // ref.read ကို သုံးပြီး Method များကို လှမ်းခေါ်ပါသည်
                ref.read(liabilitiesProvider.notifier).removeLiability(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref
              .read(liabilitiesProvider.notifier)
              .addLiability('New Loan ${liabilities.length + 1}');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

