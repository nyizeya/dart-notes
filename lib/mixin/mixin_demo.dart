abstract class Animal {
  void printInfo();
}

abstract class Bird extends Animal {
  @override
  void printInfo() {
    print("I am a bird.");
  }
}

mixin CanFly on Bird {
  void fly() {
    print("I can fly...");
  }
}

class Eagle extends Bird with CanFly {
  @override
  void printInfo() {
    super.printInfo();
    print("I am an eagle.");
  }
}

void main() {
  Eagle eagle = Eagle();
  eagle.printInfo();
  eagle.fly();
}
