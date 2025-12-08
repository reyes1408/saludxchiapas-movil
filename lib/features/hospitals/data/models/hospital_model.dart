class HospitalModel {
  final String id;
  final String nombre;
  final String direccion;
  final String telefono;
  final List<String> especialidades;
  final int camasDisponibles;
  final HospitalLocation ubicacion;
  final List<String> servicios;
  final String horarioAtencion;

  HospitalModel({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.especialidades,
    required this.camasDisponibles,
    required this.ubicacion,
    required this.servicios,
    required this.horarioAtencion,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? 'Sin nombre',
      direccion: json['direccion'] ?? 'Sin dirección',
      telefono: json['telefono'] ?? 'Sin teléfono',
      especialidades: List<String>.from(json['especialidades'] ?? []),
      camasDisponibles: json['camasDisponibles'] ?? 0,
      ubicacion: HospitalLocation.fromJson(json['ubicacion'] ?? {}),
      servicios: List<String>.from(json['servicios'] ?? []),
      horarioAtencion: json['horarioAtencion'] ?? 'Desconocido',
    );
  }
}

class HospitalLocation {
  final double latitud;
  final double longitud;

  HospitalLocation({required this.latitud, required this.longitud});

  factory HospitalLocation.fromJson(Map<String, dynamic> json) {
    return HospitalLocation(
      latitud: (json['latitud'] as num?)?.toDouble() ?? 0.0,
      longitud: (json['longitud'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
