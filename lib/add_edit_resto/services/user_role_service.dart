import 'package:shared_preferences/shared_preferences.dart';

class UserRoleService {
  // fetch user role from SharedPreferences
  static Future<String> fetchUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole') ?? 'User'; 
  }
}
