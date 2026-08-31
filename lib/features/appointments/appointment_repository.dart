import 'package:supabase_flutter/supabase_flutter.dart';
import 'appointment.dart';

class AppointmentRepository {
  AppointmentRepository() : _client = Supabase.instance.client;
  final SupabaseClient _client;
  Future<List<Appointment>> getAll() async {
    final data = await _client.from('citas').select().order('inicia_en', ascending: false);
    return (data as List<dynamic>).map((e) => Appointment.fromMap(e as Map<String, dynamic>)).toList();
  }
  Future<void> save(Appointment item) async {
    if (item.id.isEmpty) { await _client.from('citas').insert(item.toMap()); }
    else { await _client.from('citas').update(item.toMap()).eq('id', item.id); }
  }
  Future<void> delete(String id) => _client.from('citas').delete().eq('id', id);
}
