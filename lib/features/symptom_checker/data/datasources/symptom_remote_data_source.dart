import 'package:dio/dio.dart';
import 'package:saludxchiapas_frontend/core/errors/exceptions.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/data/models/analysis_result_model.dart';

const String _BASE_URL = 'https://api-mineria-chiapas.onrender.com/api/v1';

abstract class SymptomRemoteDataSource {
  Future<AnalysisResultModel> diagnose({
    required String texto,
    required String municipio,
    required String genero,
    required int edad,
    required double peso,
  });
}

class SymptomRemoteDataSourceImpl implements SymptomRemoteDataSource {
  final Dio dio;

  SymptomRemoteDataSourceImpl({required this.dio});

  @override
  Future<AnalysisResultModel> diagnose({
    required String texto,
    required String municipio,
    required String genero,
    required int edad,
    required double peso,
  }) async {
    const url =
        'https://api-mineria-chiapas.onrender.com/api/v1/analisis/diagnosticar';

    try {
      final response = await dio.post(
        url,
        data: {
          "texto_sintomas": texto,
          "municipio": municipio,
          "genero": genero,
          "edad": edad,
          "peso": peso,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AnalysisResultModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException();
    }
  }
}
