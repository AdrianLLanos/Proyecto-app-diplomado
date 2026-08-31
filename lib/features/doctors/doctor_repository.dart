import 'package:supabase_flutter/supabase_flutter.dart';

import 'doctor.dart';

class DoctorRepository {
  DoctorRepository({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Doctor>> getAll() async {
    final data = await _client.from('doctores').select().order('nombre_completo');
    return (data as List<dynamic>)
        .map((row) => Doctor.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(Doctor doctor) async {
    if (doctor.id.isEmpty) {
      await _client.from('doctores').insert(doctor.toMap());
    } else {
      await _client.from('doctores').update(doctor.toMap()).eq('id', doctor.id);
    }
  }

  Future<void> delete(String doctorId) async {
    await _client.from('doctores').delete().eq('id', doctorId);
  }
}
