class Appointment {
  const Appointment({required this.id, required this.patientId, required this.doctorId, required this.startsAt, required this.endsAt, required this.reason, required this.status});
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime startsAt;
  final DateTime endsAt;
  final String reason;
  final String status;

  factory Appointment.fromMap(Map<String, dynamic> data) => Appointment(
    id: data['id'] as String,
    patientId: data['paciente_id'] as String,
    doctorId: data['doctor_id'] as String,
    startsAt: DateTime.parse(data['inicia_en'] as String).toLocal(),
    endsAt: data['finaliza_en'] == null ? DateTime.parse(data['inicia_en'] as String).toLocal().add(const Duration(minutes: 30)) : DateTime.parse(data['finaliza_en'] as String).toLocal(),
    reason: data['motivo'] as String? ?? '',
    status: data['estado'] as String,
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'paciente_id': patientId, 'doctor_id': doctorId,
    'inicia_en': startsAt.toUtc().toIso8601String(), 'finaliza_en': endsAt.toUtc().toIso8601String(),
    'motivo': reason.trim().isEmpty ? null : reason.trim(), 'estado': status,
  };
}
