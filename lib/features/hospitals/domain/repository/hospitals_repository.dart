import 'package:fpdart/fpdart.dart';
import 'package:saludxchiapas_frontend/core/errors/failures.dart';
import 'package:saludxchiapas_frontend/features/hospitals/data/models/hospital_model.dart';

abstract class HospitalsRepository {
  Future<Either<Failure, List<HospitalModel>>> getHospitals(String municipio);
}
