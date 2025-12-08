import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:saludxchiapas_frontend/features/hospitals/data/models/hospital_model.dart';
import 'package:saludxchiapas_frontend/features/hospitals/domain/repository/hospitals_repository.dart';
import 'package:saludxchiapas_frontend/features/hospitals/data/datasources/hospitals_remote_data_source.dart';
import 'package:saludxchiapas_frontend/features/hospitals/data/repository/hospitals_repository_impl.dart';

// Estado
class HospitalsState {
  final bool isLoading;
  final List<HospitalModel> hospitals;
  final String? errorMessage;

  HospitalsState({
    this.isLoading = false,
    this.hospitals = const [],
    this.errorMessage,
  });

  HospitalsState copyWith({
    bool? isLoading,
    List<HospitalModel>? hospitals,
    String? errorMessage,
  }) {
    return HospitalsState(
      isLoading: isLoading ?? this.isLoading,
      hospitals: hospitals ?? this.hospitals,
      errorMessage: errorMessage, // Si es nulo, limpia el error
    );
  }
}

// Notifier
class HospitalsNotifier extends StateNotifier<HospitalsState> {
  final HospitalsRepository _repository;

  HospitalsNotifier(this._repository) : super(HospitalsState());

  Future<void> searchHospitals(String municipio) async {
    state = state.copyWith(isLoading: true, errorMessage: null, hospitals: []);

    final result = await _repository.getHospitals(municipio);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (hospitalsList) {
        state = state.copyWith(isLoading: false, hospitals: hospitalsList);
      },
    );
  }
}

// --- DEPENDENCIAS ---

final dioHospitalProvider = Provider<Dio>((ref) => Dio());

final hospitalsRemoteDataSourceProvider = Provider<HospitalsRemoteDataSource>((
  ref,
) {
  return HospitalsRemoteDataSourceImpl(dio: ref.watch(dioHospitalProvider));
});

final hospitalsRepositoryProvider = Provider<HospitalsRepository>((ref) {
  return HospitalsRepositoryImpl(
    remoteDataSource: ref.watch(hospitalsRemoteDataSourceProvider),
  );
});

final hospitalsProvider =
    StateNotifierProvider<HospitalsNotifier, HospitalsState>((ref) {
      final repo = ref.watch(hospitalsRepositoryProvider);
      return HospitalsNotifier(repo);
    });
