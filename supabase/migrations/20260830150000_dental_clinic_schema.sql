-- Ejecutar mediante `supabase db push` o en Supabase SQL Editor.
create extension if not exists pgcrypto;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'staff' check (role in ('admin', 'doctor', 'reception', 'staff')),
  created_at timestamptz not null default now()
);

create or replace function public.create_profile()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', new.email));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users for each row execute procedure public.create_profile();

create table public.patients (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id),
  first_name text not null, last_name text not null, document_number text,
  birth_date date, phone text, email text, address text, medical_notes text,
  created_at timestamptz not null default now()
);

create table public.doctors (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id),
  full_name text not null, specialty text, phone text, email text,
  created_at timestamptz not null default now()
);

create table public.appointments (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id),
  patient_id uuid not null references public.patients(id) on delete cascade,
  doctor_id uuid references public.doctors(id) on delete set null,
  starts_at timestamptz not null, ends_at timestamptz, reason text,
  status text not null default 'scheduled' check (status in ('scheduled', 'confirmed', 'completed', 'cancelled')),
  created_at timestamptz not null default now()
);

create table public.clinical_cases (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id),
  patient_id uuid not null references public.patients(id) on delete cascade,
  diagnosis text, treatment_plan text, notes text, created_at timestamptz not null default now()
);

create table public.prescriptions (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id),
  patient_id uuid not null references public.patients(id) on delete cascade,
  doctor_id uuid references public.doctors(id) on delete set null,
  medication text not null, instructions text, issued_at timestamptz not null default now()
);

create table public.lab_reports (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id),
  patient_id uuid not null references public.patients(id) on delete cascade,
  title text not null, result text, status text not null default 'pending' check (status in ('pending', 'completed')),
  created_at timestamptz not null default now()
);

create table public.insurances (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id),
  patient_id uuid not null references public.patients(id) on delete cascade,
  provider_name text not null, policy_number text, coverage_percent numeric(5,2),
  created_at timestamptz not null default now()
);

create table public.invoices (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id),
  patient_id uuid not null references public.patients(id) on delete restrict,
  invoice_date date not null default current_date, total numeric(12,2) not null default 0,
  paid numeric(12,2) not null default 0, status text not null default 'pending' check (status in ('pending', 'partial', 'paid', 'void')),
  created_at timestamptz not null default now()
);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id),
  invoice_id uuid references public.invoices(id) on delete set null,
  payment_date date not null default current_date, amount numeric(12,2) not null check (amount > 0),
  method text not null default 'cash', notes text, created_at timestamptz not null default now()
);

create index patients_owner_idx on public.patients(owner_id);
create index appointments_owner_starts_idx on public.appointments(owner_id, starts_at);
create index invoices_owner_idx on public.invoices(owner_id);

do $$
declare tab text;
begin
  foreach tab in array array['patients', 'doctors', 'appointments', 'clinical_cases', 'prescriptions', 'lab_reports', 'insurances', 'invoices', 'payments']
  loop
    execute format('alter table public.%I enable row level security', tab);
    execute format('create policy %I on public.%I for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid())', tab || '_own_data', tab);
  end loop;
end $$;

alter table public.profiles enable row level security;
create policy profiles_own_data on public.profiles for all to authenticated
  using (id = auth.uid()) with check (id = auth.uid());
