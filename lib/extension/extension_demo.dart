void main() {
  const name = "25";
  print(name);

  print(name.toCapitalized());
  print(name.toInt());
}

extension StringExtension on String {
  String toCapitalized() {
    if (isEmpty) {
      return this;
    }

    return '${this[0].toUpperCase()}${substring(1)}';
  }

  int toInt() {
    try {
      return int.parse(this);
    } on FormatException {
      print("Error: Cannot convert '$this' to an integer.");
      return -1;
    }
  }
}
