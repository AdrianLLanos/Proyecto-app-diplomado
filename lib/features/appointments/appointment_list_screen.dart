import 'package:flutter/material.dart';
import '../doctors/doctor.dart';
import '../doctors/doctor_repository.dart';
import '../patients/patient.dart';
import '../patients/patient_repository.dart';
import 'appointment.dart';
import 'appointment_repository.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key, this.patientId, this.doctorId});
  final String? patientId;
  final String? doctorId;
  @override State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}
class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final _repo = AppointmentRepository(); final _patientsRepo = PatientRepository(); final _doctorsRepo = DoctorRepository();
  List<Appointment> _items = []; Map<String, Patient> _patients = {}; Map<String, Doctor> _doctors = {}; bool _loading = true; String? _error;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { setState(() { _loading = true; _error = null; }); try { final items = await _repo.getAll(); final patients = await _patientsRepo.getAll(); final doctors = await _doctorsRepo.getAll(); if (mounted) setState(() { _items = items; _patients = {for (final p in patients) p.id: p}; _doctors = {for (final d in doctors) d.id: d}; }); } catch (_) { if (mounted) setState(() => _error = 'No se pudieron cargar las citas. Verifica Supabase.'); } finally { if (mounted) setState(() => _loading = false); } }
  Future<void> _edit([Appointment? item]) async {
    String? patientId = item?.patientId ?? widget.patientId; String? doctorId = item?.doctorId ?? widget.doctorId; DateTime date = item?.startsAt ?? DateTime.now(); final reason = TextEditingController(text: item?.reason ?? ''); String status = item?.status ?? 'scheduled';
    final saved = await showDialog<bool>(context: context, builder: (context) => StatefulBuilder(builder: (context, update) => AlertDialog(title: Text(item == null ? 'Nueva cita' : 'Editar cita'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [DropdownButtonFormField<String>(value: patientId, hint: const Text('Paciente'), items: _patients.values.map((p) => DropdownMenuItem(value: p.id, child: Text(p.fullName))).toList(), onChanged: (v) => update(() => patientId = v)), const SizedBox(height: 10), DropdownButtonFormField<String>(value: doctorId, hint: const Text('Doctor'), items: _doctors.values.map((d) => DropdownMenuItem(value: d.id, child: Text(d.fullName))).toList(), onChanged: (v) => update(() => doctorId = v)), const SizedBox(height: 10), OutlinedButton(onPressed: () async { final pick = await showDatePicker(context: context, initialDate: date, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime.now().add(const Duration(days: 730))); if (pick != null) update(() => date = DateTime(pick.year, pick.month, pick.day, date.hour, date.minute)); }, child: Text('Fecha: ${_date(date)}')), OutlinedButton(onPressed: () async { final pick = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(date)); if (pick != null) update(() => date = DateTime(date.year, date.month, date.day, pick.hour, pick.minute)); }, child: Text('Hora: ${_time(date)}')), TextFormField(controller: reason, maxLines: 2, decoration: const InputDecoration(labelText: 'Motivo')), DropdownButtonFormField<String>(value: status, items: const [DropdownMenuItem(value: 'scheduled', child: Text('Programada')), DropdownMenuItem(value: 'confirmed', child: Text('Confirmada')), DropdownMenuItem(value: 'completed', child: Text('Atendida')), DropdownMenuItem(value: 'cancelled', child: Text('Cancelada'))], onChanged: (v) => update(() => status = v!))])), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')), FilledButton(onPressed: patientId == null || doctorId == null ? null : () async { final end = date.add(const Duration(minutes: 30)); final clashes = _items.any((x) => x.id != (item?.id ?? '') && x.doctorId == doctorId && x.status != 'cancelled' && x.startsAt.isBefore(end) && x.endsAt.isAfter(date)); if (clashes) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El doctor ya tiene una cita en ese horario.'))); return; } await _repo.save(Appointment(id: item?.id ?? '', patientId: patientId!, doctorId: doctorId!, startsAt: date, endsAt: end, reason: reason.text, status: status)); if (context.mounted) Navigator.pop(context, true); }, child: const Text('Guardar'))])));
    reason.dispose(); if (saved == true) _load();
  }
  Future<void> _delete(Appointment item) async { final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Eliminar cita'), content: const Text('Esta accion no se puede deshacer.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar'))])); if (ok == true) { await _repo.delete(item.id); _load(); } }
  @override
  Widget build(BuildContext context) {
    final list = _items.where((item) {
      return (widget.patientId == null || item.patientId == widget.patientId) &&
          (widget.doctorId == null || item.doctorId == widget.doctorId);
    }).toList();
    final title = widget.patientId != null
        ? 'Citas del paciente'
        : widget.doctorId != null
            ? 'Citas del doctor'
            : 'Citas';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _edit,
        icon: const Icon(Icons.add),
        label: const Text('Nueva cita'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            if (_loading)
              const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
            else if (_error != null)
              Center(child: Text(_error!))
            else if (list.isEmpty)
              const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('No hay citas registradas.')))
            else
              ...list.map((item) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.event_available_outlined),
                      title: Text(_patients[item.patientId]?.fullName ?? 'Paciente'),
                      subtitle: Text('${_doctors[item.doctorId]?.fullName ?? 'Doctor'} - ${_date(item.startsAt)} ${_time(item.startsAt)} - ${_status(item.status)}'),
                      onTap: () => _edit(item),
                      trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _delete(item)),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
  String _date(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}'; String _time(DateTime d) => '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}'; String _status(String x) => const {'scheduled': 'Programada', 'confirmed': 'Confirmada', 'completed': 'Atendida', 'cancelled': 'Cancelada'}[x] ?? x;
}
