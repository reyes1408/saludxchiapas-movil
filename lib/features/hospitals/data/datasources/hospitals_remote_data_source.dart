import 'package:dio/dio.dart';
import 'package:saludxchiapas_frontend/core/errors/exceptions.dart';
import 'package:saludxchiapas_frontend/features/hospitals/data/models/hospital_model.dart';

abstract class HospitalsRemoteDataSource {
  Future<List<HospitalModel>> getHospitals(String municipio);
}

class HospitalsRemoteDataSourceImpl implements HospitalsRemoteDataSource {
  final Dio dio;

  HospitalsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<HospitalModel>> getHospitals(String municipio) async {
    final municipioEncoded = Uri.encodeComponent(municipio);
    final url =
        'https://hospital-microservicios.onrender.com/api/hospitales/$municipioEncoded';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> list = response.data['hospitales'];
        return list.map((e) => HospitalModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } on DioException catch (_) {
      throw ServerException();
    } catch (_) {
      throw ServerException();
    }
  }
}
