import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:saludxchiapas_frontend/features/symptom_checker/domain/entities/analysis_result.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/domain/repository/symptom_repository.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/data/datasources/symptom_remote_data_source.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/data/repository/symptom_repository_impl.dart';

class SymptomState {
  final bool isLoading;
  final AnalysisResult? result;
  final String? errorMessage;

  SymptomState({this.isLoading = false, this.result, this.errorMessage});

  SymptomState copyWith({
    bool? isLoading,
    AnalysisResult? result,
    String? errorMessage,
  }) {
    return SymptomState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SymptomNotifier extends StateNotifier<SymptomState> {
  final SymptomRepository _repository;

  SymptomNotifier(this._repository) : super(SymptomState());

  Future<void> analyzeSymptoms(String texto) async {
    state = state.copyWith(isLoading: true, errorMessage: null, result: null);

    final result = await _repository.analyzeSymptoms(texto);

    result.fold(
      (failure) {
        // En caso de error
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (analysisResult) {
        // En caso de éxito
        state = state.copyWith(isLoading: false, result: analysisResult);
      },
    );
  }
}

final symptomProvider = StateNotifierProvider<SymptomNotifier, SymptomState>((
  ref,
) {
  final repository = ref.watch(symptomRepositoryProvider);
  return SymptomNotifier(repository);
});

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
