import 'package:shared_preferences/shared_preferences.dart';

class LocalUserData {
  static SharedPreferences? _preferences;

  static const _enrolleeEmail = 'enrolleeEmail';
  static const _enrolleePassword = 'enrolleePassword';
  static const _agentEmail = 'agentEmail';
  static const _agentPassword = 'agentPassword';
  static const _rememberEnrolleePassword = "rememberEnrolleePassword";
  static const _rememberAgentPassword = "rememberAgentPassword";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setEnrolleeEmail(String enrolleeEmail) async =>
      await _preferences!.setString(_enrolleeEmail, enrolleeEmail);

  static String getEnrolleeEmail() => _preferences!.getString(_enrolleeEmail) ?? "";

  static Future setEnrolleePassword(String enrolleePassword) async =>
      await _preferences!.setString(_enrolleePassword, enrolleePassword);

  static String getEnrolleePassword() => _preferences!.getString(_enrolleePassword) ?? "";

  static Future setRememberEnrolleePassword(bool remember) async =>
      await _preferences!.setBool(_rememberEnrolleePassword, remember);

  static bool getEnrolleeRememberMeInfo() => _preferences!.getBool(_rememberEnrolleePassword) ?? false;
}
