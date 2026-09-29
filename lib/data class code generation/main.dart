import 'package:dart_oop/data%20class%20code%20generation/user.dart';

void main() {
  var map = {'firstName': 'Nyi', 'lastName': 'Zeya', 'isActive': true};

  final user = User.fromJson(map);

  print(user);
}
