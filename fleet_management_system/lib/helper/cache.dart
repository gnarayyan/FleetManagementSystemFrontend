import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Cache {
  final _storage = const FlutterSecureStorage();

  Future<void> save(int userId, String fullName, String email, String role,
      String accessToken, String refreshToken) async {
    await _storage.write(key: 'userId', value: userId.toString());
    await _storage.write(key: 'fullName', value: fullName);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'role', value: role);
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
    await _storage.write(
        key: 'isLogined', value: '1'); // '0' for logout and '1' for logined
  }

  Future<void> clear() async {
    await _storage.deleteAll(); // Clear cache
    await _storage.write(key: 'isLogined', value: '0');
  }

  Future<bool> isLogin() async {
    var token = await _storage.read(key: 'isLogined');
    bool loginStatus = (token == '1') ? true : false;

    return loginStatus;
  }

  Future<String?> getAccessToken() async {
    var token = await _storage.read(key: 'accessToken');

    return token;
  }

  Future<String?> getRole() async {
    String? role = await _storage.read(key: 'role');
    return role;
  }

  Future<void> setAccessToken(String accessToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
  }

  Future<void> setProfilePic(String profileUrl) async {
    await _storage.write(key: 'profilePic', value: profileUrl);
  }

  Future<String?> getProfilePic() async {
    return await _storage.read(key: 'profilePics');
  }

  Future<String?> getRefreshToken() async {
    var token = await _storage.read(key: 'refreshToken');

    return token;
  }

  Future<String?> getUserId() async {
    var token = await _storage.read(key: 'userId');

    return token;
  }

  Future<String?> getFullName() async {
    String? token = await _storage.read(key: 'fullName');

    return token;
  }

  Future<String?> getEmail() async {
    String? token = await _storage.read(key: 'email');

    return token;
  }
}
