-- Horarios de atencion por doctor para el modulo DentalCare.
create table if not exists public.horarios_doctores (
  id uuid primary key default gen_random_uuid(),
  propietario_id uuid not null default auth.uid() references auth.users(id),
  doctor_id uuid not null references public.doctores(id) on delete cascade,
  dia_semana text not null check (dia_semana in ('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')),
  hora_inicio time not null,
  hora_fin time not null,
  duracion_cita integer not null default 30 check (duracion_cita > 0),
  tipo_turno text not null default 'horario' check (tipo_turno in ('secuencial', 'horario')),
  activo boolean not null default true,
  creado_en timestamptz not null default now(),
  check (hora_fin > hora_inicio)
);

alter table public.horarios_doctores enable row level security;

create policy horarios_doctores_propios on public.horarios_doctores
  for all to authenticated
  using (propietario_id = auth.uid())
  with check (propietario_id = auth.uid());

create index horarios_doctores_doctor_dia_idx
  on public.horarios_doctores(doctor_id, dia_semana, hora_inicio);
