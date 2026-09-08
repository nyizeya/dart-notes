// ၁။ ၁ စက္ကန့်လျှင် ဂဏန်း ၁ လုံးစီ ထုတ်ပေးမည့် Stream
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // Stream ထဲသို့ Data ပို့ပေးခြင်း
  } // ← generator finishes here. Dart then automatically sends a done event to the subscription.
}

void main() async {
  print("Stream စတင်ပါပြီ...");

  // ၂။ Stream ကို listen လုပ်၍ ဒေတာ စောင့်ယူခြင်း
  Stream<int> stream = countStream(5);

  stream.listen(
    (data) {
      print("ရရှိသော တန်ဖိုး: $data");
    },
    onDone: () {
      print("Stream ပြီးဆုံးသွားပါပြီ။");
    },
  );
}
