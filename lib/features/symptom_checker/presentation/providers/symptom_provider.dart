// lib/features/symptom_checker/presentation/providers/symptom_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

// Importaciones de tu proyecto
import 'package:saludxchiapas_frontend/features/symptom_checker/domain/entities/analysis_result.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/domain/repository/symptom_repository.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/data/datasources/symptom_remote_data_source.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/data/repository/symptom_repository_impl.dart';

// Importaciones de Auth (para obtener los datos del usuario)
import 'package:saludxchiapas_frontend/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saludxchiapas_frontend/features/auth/presentation/providers/auth_provider.dart'; // Para obtener authLocalDataSourceProvider

// 1. Estado
class SymptomState {
  final bool isLoading;
  final AnalysisResult? result;
  final String? errorMessage;
  final String? lastMunicipio;

  SymptomState({
    this.isLoading = false,
    this.result,
    this.errorMessage,
    this.lastMunicipio,
  });

  SymptomState copyWith({
    bool? isLoading,
    AnalysisResult? result,
    String? errorMessage,
    String? lastMunicipio,
  }) {
    return SymptomState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      lastMunicipio: lastMunicipio ?? this.lastMunicipio,
    );
  }
}

// 2. Notifier
class SymptomNotifier extends StateNotifier<SymptomState> {
  final SymptomRepository _repository;
  final AuthLocalDataSource _authLocalDataSource;

  SymptomNotifier(this._repository, this._authLocalDataSource)
    : super(SymptomState());

  Future<void> analyzeSymptoms(String texto, String municipio) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      result: null,
      lastMunicipio: municipio,
    );

    try {
      final user = await _authLocalDataSource.getUser();

      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              "No se encontró sesión activa. Por favor reinicia sesión.",
        );
        return;
      }

      // 2. Mapeo de género para la API
      String generoApi = 'M';
      if (user.gender.toLowerCase().contains('fem')) {
        generoApi = 'F';
      }

      final result = await _repository.diagnose(
        texto: texto,
        municipio: municipio,
        genero: generoApi,
        edad: user.age,
        peso: user.weight,
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (analysisResult) {
          state = state.copyWith(isLoading: false, result: analysisResult);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Error inesperado: $e",
      );
    }
  }
}

// --- INYECCIÓN DE DEPENDENCIAS ---

final dioProvider = Provider<Dio>((ref) => Dio());

final symptomRemoteDataSourceProvider = Provider<SymptomRemoteDataSource>((
  ref,
) {
  return SymptomRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final symptomRepositoryProvider = Provider<SymptomRepository>((ref) {
  return SymptomRepositoryImpl(
    remoteDataSource: ref.watch(symptomRemoteDataSourceProvider),
  );
});

// 3. Provider Principal
final symptomProvider = StateNotifierProvider<SymptomNotifier, SymptomState>((
  ref,
) {
  final repository = ref.watch(symptomRepositoryProvider);

  // Obtenemos el AuthLocalDataSource del otro provider (auth_provider.dart)
  // Asegúrate de que authLocalDataSourceProvider sea público en auth_provider.dart
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);

  return SymptomNotifier(repository, authLocalDataSource);
});
