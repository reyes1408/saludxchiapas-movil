import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saludxchiapas_frontend/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:saludxchiapas_frontend/features/auth/data/repository/auth_repository_impl.dart';
import 'package:saludxchiapas_frontend/features/auth/domain/repository/auth_repository.dart';
import 'package:saludxchiapas_frontend/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState());

  Future<void> login(String identifier, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repository.login(identifier, password);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          errorMessage: failure.message,
        );
      },
      (successData) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    state = AuthState(isAuthenticated: false);
  }

  Future<bool> register({
    required String name,
    required String age,
    required String weight,
    required String gender,
    required String username,
    required String password,
    required String email,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final userData = {
        "name": name,
        "age": age,
        "weight": weight,
        "gender": gender,
        "username": username,
        "password": password,
        "email": email,
      };

      final result = await _repository.register(userData);

      return result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
          return false; // Falló
        },
        (success) {
          state = state.copyWith(isLoading: false, errorMessage: null);
          return true; // Éxito
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Error de formato en los datos",
      );
      return false;
    }
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Se sobreescribirá en el main.dart
});

final dioAuthProvider = Provider<Dio>((ref) => Dio());

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dio: ref.watch(dioAuthProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider), // <--- Nuevo
  );
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
