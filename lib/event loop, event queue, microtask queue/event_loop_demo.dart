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
