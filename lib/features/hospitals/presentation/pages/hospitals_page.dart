import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:saludxchiapas_frontend/features/hospitals/presentation/providers/hospitals_provider.dart';
import 'package:saludxchiapas_frontend/features/hospitals/data/models/hospital_model.dart';
import 'package:saludxchiapas_frontend/core/constants/municipios_chiapas.dart';

class HospitalsPage extends ConsumerStatefulWidget {
  const HospitalsPage({super.key});

  @override
  ConsumerState<HospitalsPage> createState() => _HospitalsPageState();
}

class _HospitalsPageState extends ConsumerState<HospitalsPage> {
  String? _selectedMunicipio;

  Future<void> _openMap(double lat, double lng) async {
    final googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo abrir la aplicación de mapas'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hospitalsState = ref.watch(hospitalsProvider);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: const Text('Hospitales Públicos')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Encuentra atención cercana',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedMunicipio,
                  hint: const Text('Selecciona un municipio'),
                  isExpanded: true,
                  items: municipiosChiapas.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMunicipio = newValue;
                    });
                    if (newValue != null) {
                      ref
                          .read(hospitalsProvider.notifier)
                          .searchHospitals(newValue);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Municipio',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: hospitalsState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : hospitalsState.errorMessage != null
                ? Center(child: Text(hospitalsState.errorMessage!))
                : _buildHospitalList(hospitalsState.hospitals, primaryColor),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildHospitalList(List<HospitalModel> hospitals, Color primaryColor) {
    if (hospitals.isEmpty && _selectedMunicipio != null) {
      return const Center(
        child: Text('No se encontraron hospitales en este municipio.'),
      );
    } else if (hospitals.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Selecciona un municipio para comenzar',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hospitals.length,
      itemBuilder: (context, index) {
        final hospital = hospitals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              _openMap(hospital.ubicacion.latitud, hospital.ubicacion.longitud);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: primaryColor.withOpacity(0.1),
                        child: Icon(Icons.map, color: primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hospital.nombre,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Toca para ver en el mapa',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.location_on_outlined, hospital.direccion),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.phone_outlined, hospital.telefono),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.access_time,
                    "Horario: ${hospital.horarioAtencion}",
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: hospital.especialidades
                        .take(3)
                        .map(
                          (e) => Chip(
                            label: Text(
                              e,
                              style: const TextStyle(fontSize: 10),
                            ),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
                  ),
                  if (hospital.especialidades.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '+${hospital.especialidades.length - 3} más...',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}
