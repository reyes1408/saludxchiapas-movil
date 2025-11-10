import 'package:/saludxchiapas_frontend/features/symptom_checker/domain/entities/analysis_result.dart';

class AnalysisResultModel extends AnalysisResult {
  const AnalysisResultModel({
    required super.diagnosticoProbable,
    required super.confianza,
    required super.nivelUrgencia,
    required super.recomendacionPublica,
    required super.sintomasReportados,
    required super.textoOriginal,
  });

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResultModel(
      diagnosticoProbable: json['diagnostico_probable'] ?? 'Error',
      confianza: (json['confianza'] as num?)?.toDouble() ?? 0.0,
      nivelUrgencia: json['nivel_urgencia'] ?? 'Bajo',
      recomendacionPublica: json['recomendacion_publica'] ?? 'Error',
      sintomasReportados: List<String>.from(json['sintomas_reportados'] ?? []),
      textoOriginal: json['texto_original'] ?? '',
    );
  }
}
