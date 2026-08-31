import 'package:supabase_flutter/supabase_flutter.dart';

import 'doctor_schedule.dart';

class DoctorScheduleRepository {
  DoctorScheduleRepository({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<DoctorSchedule>> getByDoctor(String doctorId) async {
    final data = await _client
        .from('horarios_doctores')
        .select()
        .eq('doctor_id', doctorId)
        .order('dia_semana')
        .order('hora_inicio');
    return (data as List<dynamic>)
        .map((row) => DoctorSchedule.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(DoctorSchedule schedule) async {
    if (schedule.id.isEmpty) {
      await _client.from('horarios_doctores').insert(schedule.toMap());
    } else {
      await _client.from('horarios_doctores').update(schedule.toMap()).eq('id', schedule.id);
    }
  }

  Future<void> delete(String scheduleId) async {
    await _client.from('horarios_doctores').delete().eq('id', scheduleId);
  }
}
