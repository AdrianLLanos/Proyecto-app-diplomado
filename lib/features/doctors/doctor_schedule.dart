class DoctorSchedule {
  const DoctorSchedule({
    required this.id,
    required this.doctorId,
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.appointmentDuration,
    required this.slotType,
    required this.active,
  });

  final String id;
  final String doctorId;
  final String weekday;
  final String startTime;
  final String endTime;
  final int appointmentDuration;
  final String slotType;
  final bool active;

  factory DoctorSchedule.fromMap(Map<String, dynamic> map) => DoctorSchedule(
        id: map['id'] as String,
        doctorId: map['doctor_id'] as String,
        weekday: map['dia_semana'] as String,
        startTime: _shortTime(map['hora_inicio'] as String),
        endTime: _shortTime(map['hora_fin'] as String),
        appointmentDuration: map['duracion_cita'] as int,
        slotType: map['tipo_turno'] as String,
        active: map['activo'] as bool,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'doctor_id': doctorId,
        'dia_semana': weekday,
        'hora_inicio': startTime,
        'hora_fin': endTime,
        'duracion_cita': appointmentDuration,
        'tipo_turno': slotType,
        'activo': active,
      };

  int get startMinutes => _minutes(startTime);
  int get endMinutes => _minutes(endTime);

  static int _minutes(String value) {
    final values = value.split(':');
    return int.parse(values[0]) * 60 + int.parse(values[1]);
  }

  static String _shortTime(String value) => value.substring(0, 5);
}
