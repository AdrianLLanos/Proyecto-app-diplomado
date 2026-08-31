class Doctor {
  const Doctor({
    required this.id,
    required this.fullName,
    this.specialty,
    this.phone,
    this.email,
  });

  final String id;
  final String fullName;
  final String? specialty;
  final String? phone;
  final String? email;

  factory Doctor.fromMap(Map<String, dynamic> map) => Doctor(
        id: map['id'] as String,
        fullName: map['nombre_completo'] as String,
        specialty: map['especialidad'] as String?,
        phone: map['telefono'] as String?,
        email: map['email'] as String?,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'nombre_completo': fullName.trim(),
        'especialidad': _nullIfBlank(specialty),
        'telefono': _nullIfBlank(phone),
        'email': _nullIfBlank(email),
      };

  static String? _nullIfBlank(String? value) =>
      value == null || value.trim().isEmpty ? null : value.trim();
}
