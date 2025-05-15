import 'package:mobile/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _ip = 'ip';
  static const String _username = 'username';
  Future setIp({required String ip}) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      _pref.setString(_ip, ip);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<String?> getIp() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      _pref.getString(_ip);
    } catch (e) {
      logger.e(e);
    }
  }

  Future setUser(String username) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      await _pref.setString(_username, username);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<String?> getUser() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      return _pref.getString(_username);
    } catch (e) {
      logger.e(e);
    }
  }
}
