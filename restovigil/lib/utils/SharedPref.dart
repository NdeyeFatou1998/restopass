import 'package:restovigil/models/Resto.dart';
import 'package:restovigil/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static final String USER_EMAIL = "user_email";
  static final String USER_MATRICULE = "user_matricule";
  static final String USER_NAME = "user_name";
  static final String USER_IMAGE_PATH = "image_path";
  static final String USER_ID = "user_id";
  static final String RESTO_ID = "resto_id";
  static final String RESTO_NAME = "resto_name";
  static final String RESTO_CAP = "resto_cap";

  static saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_EMAIL, user.email);
    prefs.setString(USER_NAME, user.name);
    prefs.setString(USER_MATRICULE, user.matricule);
    prefs.setInt(USER_ID, user.id);
  }

  static Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(USER_MATRICULE) == null) {
      return null;
    }
    User user = new User(
      email: prefs.getString(USER_EMAIL) ?? '',
      matricule: prefs.getString(USER_MATRICULE) ?? '',
      id: prefs.getInt(USER_ID) ?? -1,
      name: prefs.getString(USER_NAME) ?? '',
    );
    return user;
  }

  static saveResto(Resto resto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(RESTO_NAME, resto.name);
    prefs.setInt(RESTO_ID, resto.id);
  }

  static Future removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(USER_MATRICULE);
    prefs.remove(USER_EMAIL);
    prefs.remove(USER_NAME);
    prefs.remove(USER_ID);
    prefs.remove(RESTO_ID);
    prefs.remove(RESTO_NAME);
  }
}
