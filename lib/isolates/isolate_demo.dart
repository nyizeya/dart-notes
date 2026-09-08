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
