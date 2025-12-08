import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saludxchiapas_frontend/features/auth/data/models/auth_response_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthData(AuthResponseModel authData);
  Future<String?> getToken();
  Future<UserModel?> getUser();
}

const CACHED_AUTH_DATA = 'CACHED_AUTH_DATA';
const CACHED_TOKEN = 'CACHED_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheAuthData(AuthResponseModel authData) async {
    await sharedPreferences.setString(CACHED_TOKEN, authData.token);

    final userJson = json.encode({
      'token': authData.token,
      'user': {
        'id': authData.user.id,
        'name': authData.user.name,
        'username': authData.user.username,
        'email': authData.user.email,
      },
    });

    await sharedPreferences.setString(CACHED_AUTH_DATA, userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final jsonString = sharedPreferences.getString(CACHED_AUTH_DATA);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        // Accedemos a la clave 'user' dentro del JSON guardado
        return UserModel.fromJson(jsonMap['user']);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(CACHED_TOKEN);
  }
}
