-- Traduce el esquema dental ya aplicado, conservando datos, claves foraneas y RLS.
alter table public.profiles rename to perfiles;
alter table public.patients rename to pacientes;
alter table public.doctors rename to doctores;
alter table public.appointments rename to citas;
alter table public.clinical_cases rename to casos_clinicos;
alter table public.prescriptions rename to recetas;
alter table public.lab_reports rename to informes_laboratorio;
alter table public.insurances rename to seguros;
alter table public.invoices rename to facturas;
alter table public.payments rename to pagos;

alter table public.perfiles rename column full_name to nombre_completo;
alter table public.perfiles rename column role to rol;
alter table public.perfiles rename column created_at to creado_en;

alter table public.pacientes rename column owner_id to propietario_id;
alter table public.pacientes rename column first_name to nombres;
alter table public.pacientes rename column last_name to apellidos;
alter table public.pacientes rename column document_number to numero_documento;
alter table public.pacientes rename column birth_date to fecha_nacimiento;
alter table public.pacientes rename column phone to telefono;
alter table public.pacientes rename column address to direccion;
alter table public.pacientes rename column medical_notes to notas_medicas;
alter table public.pacientes rename column created_at to creado_en;

alter table public.doctores rename column owner_id to propietario_id;
alter table public.doctores rename column full_name to nombre_completo;
alter table public.doctores rename column specialty to especialidad;
alter table public.doctores rename column phone to telefono;
alter table public.doctores rename column created_at to creado_en;

alter table public.citas rename column owner_id to propietario_id;
alter table public.citas rename column patient_id to paciente_id;
alter table public.citas rename column starts_at to inicia_en;
alter table public.citas rename column ends_at to finaliza_en;
alter table public.citas rename column reason to motivo;
alter table public.citas rename column status to estado;
alter table public.citas rename column created_at to creado_en;

alter table public.casos_clinicos rename column owner_id to propietario_id;
alter table public.casos_clinicos rename column patient_id to paciente_id;
alter table public.casos_clinicos rename column treatment_plan to plan_tratamiento;
alter table public.casos_clinicos rename column notes to notas;
alter table public.casos_clinicos rename column created_at to creado_en;

alter table public.recetas rename column owner_id to propietario_id;
alter table public.recetas rename column patient_id to paciente_id;
alter table public.recetas rename column medication to medicamento;
alter table public.recetas rename column instructions to indicaciones;
alter table public.recetas rename column issued_at to emitida_en;

alter table public.informes_laboratorio rename column owner_id to propietario_id;
alter table public.informes_laboratorio rename column patient_id to paciente_id;
alter table public.informes_laboratorio rename column title to titulo;
alter table public.informes_laboratorio rename column result to resultado;
alter table public.informes_laboratorio rename column status to estado;
alter table public.informes_laboratorio rename column created_at to creado_en;

alter table public.seguros rename column owner_id to propietario_id;
alter table public.seguros rename column patient_id to paciente_id;
alter table public.seguros rename column provider_name to aseguradora;
alter table public.seguros rename column policy_number to numero_poliza;
alter table public.seguros rename column coverage_percent to porcentaje_cobertura;
alter table public.seguros rename column created_at to creado_en;

alter table public.facturas rename column owner_id to propietario_id;
alter table public.facturas rename column patient_id to paciente_id;
alter table public.facturas rename column invoice_date to fecha_factura;
alter table public.facturas rename column paid to pagado;
alter table public.facturas rename column status to estado;
alter table public.facturas rename column created_at to creado_en;

alter table public.pagos rename column owner_id to propietario_id;
alter table public.pagos rename column invoice_id to factura_id;
alter table public.pagos rename column payment_date to fecha_pago;
alter table public.pagos rename column amount to monto;
alter table public.pagos rename column method to metodo;
alter table public.pagos rename column notes to notas;
alter table public.pagos rename column created_at to creado_en;

create or replace function public.create_profile()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.perfiles (id, nombre_completo)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', new.email));
  return new;
end;
$$;
