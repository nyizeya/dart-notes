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
