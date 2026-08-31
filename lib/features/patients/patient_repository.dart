import 'package:supabase_flutter/supabase_flutter.dart';

import 'patient.dart';

class PatientRepository {
  PatientRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Patient>> getAll() async {
    final data = await _client
        .from('pacientes')
        .select()
        .order('apellidos', ascending: true)
        .order('nombres', ascending: true);
    return (data as List<dynamic>)
        .map((row) => Patient.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(Patient patient) async {
    final values = patient.toMap();
    if (patient.id.isEmpty) {
      await _client.from('pacientes').insert(values);
    } else {
      await _client.from('pacientes').update(values).eq('id', patient.id);
    }
  }

  Future<void> delete(String patientId) async {
    await _client.from('pacientes').delete().eq('id', patientId);
  }
}
