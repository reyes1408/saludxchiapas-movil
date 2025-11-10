// lib/features/symptom_checker/domain/repository/symptom_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:saludxchiapas_frontend/core/errors/failures.dart'; // Crearemos esto
import 'package:saludxchiapas_frontend/features/symptom_checker/domain/entities/analysis_result.dart';

abstract class SymptomRepository {
  Future<Either<Failure, AnalysisResult>> analyzeSymptoms(String texto);
}
