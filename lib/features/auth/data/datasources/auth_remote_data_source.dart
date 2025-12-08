import 'package:dio/dio.dart';
import 'package:saludxchiapas_frontend/core/errors/exceptions.dart';
import 'package:saludxchiapas_frontend/features/auth/data/models/auth_response_model.dart'; // Importa tu modelo

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String identifier, String password);

  Future<void> register({
    required String name,
    required int age,
    required double weight,
    required String gender,
    required String username,
    required String password,
    required String email,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login(String identifier, String password) async {
    const url = 'https://isai.wildroid.space/api/auth/login';

    try {
      final response = await dio.post(
        url,
        data: {"identifier": identifier, "password": password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> register({
    required String name,
    required int age,
    required double weight,
    required String gender,
    required String username,
    required String password,
    required String email,
  }) async {
    const url = 'https://isai.wildroid.space/api/auth/register';

    try {
      final response = await dio.post(
        url,
        data: {
          "name": name,
          "age": age,
          "weight": weight,
          "gender": gender,
          "username": username,
          "password": password,
          "email": email,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // El registro fue exitoso.
        // No necesitamos retornar nada específico, si no lanza error, todo bien.
        return;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      // Manejo básico de errores (ej. usuario ya existe)
      throw ServerException(e.message ?? 'Error al registrar usuario');
    } catch (e) {
      throw ServerException();
    }
  }
}
