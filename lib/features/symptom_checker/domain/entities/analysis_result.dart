import 'package:equatable/equatable.dart';

class AnalysisResult extends Equatable {
  final String diagnosticoProbable;
  final double confianza;
  final String nivelUrgencia;
  final String recomendacionPublica;
  final List<String> sintomasReportados;
  final String textoOriginal;

  const AnalysisResult({
    required this.diagnosticoProbable,
    required this.confianza,
    required this.nivelUrgencia,
    required this.recomendacionPublica,
    required this.sintomasReportados,
    required this.textoOriginal,
  });

  @override
  List<Object?> get props => [
    diagnosticoProbable,
    confianza,
    nivelUrgencia,
    recomendacionPublica,
    sintomasReportados,
    textoOriginal,
  ];
}
