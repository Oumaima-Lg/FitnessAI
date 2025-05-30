import 'package:fitness/services/shared_pref.dart';

class UserService {
  String? name, id, email;

  gettheshredpref() async {
    name = await SharedpreferenceHelper().getUserName();
    id = await SharedpreferenceHelper().getUserId();
    email = await SharedpreferenceHelper().getUserEmail();
  }

  String? getUserName() {
    return name;
  }

  String? getUserId() {
    return id;
  }

  String? getUserEmail() {
    return email;
  }
}
