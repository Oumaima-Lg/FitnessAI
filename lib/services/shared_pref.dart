import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userImageKey = "USERIMAGEKEY";
  static String userAgeKey = "USERAGEKEY";
  static String userPhoneKey = "USERPHONEKEY";
  static String userWeightKey = "USERWEIGHTKEY";
  static String userHeightKey = "USERHEIGHTKEY";
  static String userAddressKey = "USERADDRESSKEY";


  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserImageURL(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUserImage);
  }

  Future<bool> saveUserAge(int age) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(userAgeKey, age);
  }

  Future<bool> saveUserPhone(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPhoneKey, phone);
  }

  Future<bool> saveUserWeight(double weight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(userWeightKey, weight);
  }

  Future<bool> saveUserHeight(double height) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(userHeightKey, height);
  }

  Future<bool> saveUserAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userAddressKey, address);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserImageURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  Future<int?> getUserAge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userAgeKey);
  }

  Future<String?> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPhoneKey);
  }

  Future<double?> getUserWeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(userWeightKey);
  }

  Future<double?> getUserHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(userHeightKey);
  }

  Future<String?> getUserAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userAddressKey);
  }
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNameKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userImageKey);
    await prefs.remove(userAgeKey);
    await prefs.remove(userPhoneKey);
    await prefs.remove(userWeightKey);
    await prefs.remove(userHeightKey);
    await prefs.remove(userAddressKey);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    return saveUserImageURL(getUserImage);
  }

  Future<String?> getUserImage() async {
    return getUserImageURL();
  }
}