import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserWorkoutDetails(
      Map<String, dynamic> userPlanningMap, String userId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("workoutPlanning")
        .add(userPlanningMap);
  }

// Future getUserByUserName(String userName) async {
//     return await FirebaseFirestore.instance
//         .collection("users")
//         .where("name", isEqualTo: userName)
//         .get();
//   }
  // Future getUserByUserName(String userName) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("name", isEqualTo: userName)
  //       .get();
  // }

  // Future getUserByUserEmail(String userEmail) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("email", isEqualTo: userEmail)
  //       .get();
  // }

  // Future getUserById(String id) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(id)
  //       .get();
  // }
}
