class Patient {
  const Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.documentNumber,
    this.birthDate,
    this.phone,
    this.email,
    this.address,
    this.medicalNotes,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? documentNumber;
  final DateTime? birthDate;
  final String? phone;
  final String? email;
  final String? address;
  final String? medicalNotes;

  String get fullName => '$firstName $lastName';

  factory Patient.fromMap(Map<String, dynamic> map) => Patient(
        id: map['id'] as String,
        firstName: map['nombres'] as String,
        lastName: map['apellidos'] as String,
        documentNumber: map['numero_documento'] as String?,
        birthDate: map['fecha_nacimiento'] == null
            ? null
            : DateTime.tryParse(map['fecha_nacimiento'] as String),
        phone: map['telefono'] as String?,
        email: map['email'] as String?,
        address: map['direccion'] as String?,
        medicalNotes: map['notas_medicas'] as String?,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'nombres': firstName.trim(),
        'apellidos': lastName.trim(),
        'numero_documento': _nullIfBlank(documentNumber),
        'fecha_nacimiento': birthDate == null ? null : _dateToIso(birthDate!),
        'telefono': _nullIfBlank(phone),
        'email': _nullIfBlank(email),
        'direccion': _nullIfBlank(address),
        'notas_medicas': _nullIfBlank(medicalNotes),
      };

  static String? _nullIfBlank(String? value) =>
      value == null || value.trim().isEmpty ? null : value.trim();

  static String _dateToIso(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
