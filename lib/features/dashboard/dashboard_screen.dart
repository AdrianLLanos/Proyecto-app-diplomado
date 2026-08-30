import 'package:flutter/material.dart';

import '../modules/module_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _modules = <ClinicModule>[
    ClinicModule('Pacientes', 'Historias clinicas y datos de contacto', Icons.people_alt_outlined, 'pacientes'),
    ClinicModule('Doctores', 'Especialidades y perfiles profesionales', Icons.medical_services_outlined, 'doctores'),
    ClinicModule('Agenda medica', 'Horarios de doctores', Icons.calendar_month_outlined, 'citas'),
    ClinicModule('Citas', 'Reservas y atencion de pacientes', Icons.event_available_outlined, 'citas'),
    ClinicModule('Casos clinicos', 'Seguimiento y diagnostico', Icons.folder_shared_outlined, 'casos_clinicos'),
    ClinicModule('Recetas', 'Prescripciones de tratamiento', Icons.receipt_long_outlined, 'recetas'),
    ClinicModule('Laboratorio', 'Informes y plantillas', Icons.science_outlined, 'informes_laboratorio'),
    ClinicModule('Seguros', 'Coberturas de pacientes', Icons.verified_user_outlined, 'seguros'),
    ClinicModule('Facturas', 'Facturacion de servicios', Icons.request_quote_outlined, 'facturas'),
    ClinicModule('Pagos', 'Ingresos y movimientos', Icons.payments_outlined, 'pagos'),
    ClinicModule('Reportes financieros', 'Resumen contable', Icons.assessment_outlined, 'facturas'),
    ClinicModule('Configuracion', 'Usuarios, roles, moneda e impuestos', Icons.settings_outlined, 'perfiles'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DentalCare')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 900 ? 3 : constraints.maxWidth >= 600 ? 2 : 1;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Text('Panel de control', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Accede a los modulos operativos de la clinica.'),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: columns == 1 ? 3.5 : 1.7,
                ),
                itemCount: _modules.length,
                itemBuilder: (context, index) {
                  final module = _modules[index];
                  return _ModuleCard(
                    module: module,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ModuleScreen(module: module),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module, required this.onTap});
  final ClinicModule module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(children: <Widget>[
            CircleAvatar(backgroundColor: const Color(0xFFE0F2F1), child: Icon(module.icon, color: const Color(0xFF006B72))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text(module.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(module.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
          ]),
        ),
      ),
    );
  }
}
