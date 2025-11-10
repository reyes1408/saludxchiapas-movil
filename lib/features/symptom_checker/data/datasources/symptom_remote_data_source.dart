import 'package:dio/dio.dart';
import 'package:saludxchiapas_frontend/core/errors/exceptions.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/data/models/analysis_result_model.dart';

const String _BASE_URL =
    'https://untransfigured-tabetha-mockingly.ngrok-free.dev';

abstract class SymptomRemoteDataSource {
  Future<AnalysisResultModel> analyzeSymptoms(String texto);
}

class SymptomRemoteDataSourceImpl implements SymptomRemoteDataSource {
  final Dio dio;

  SymptomRemoteDataSourceImpl({required this.dio});

  @override
  Future<AnalysisResultModel> analyzeSymptoms(String texto) async {
    final body = {'texto': texto};

    try {
      final response = await dio.post('$_BASE_URL/analizar', data: body);

      if (response.statusCode == 200) {
        return AnalysisResultModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      print(e);
      throw ServerException();
    }
  }
}
