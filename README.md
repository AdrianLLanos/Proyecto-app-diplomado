# DentalCare

Aplicacion Flutter para la gestion de clinicas dentales, conectada con Supabase.

## Configuracion

1. Crea un proyecto en Supabase.
2. Ejecuta la migracion con la CLI de Supabase o su contenido en SQL Editor.
3. Crea el usuario autorizado en **Authentication > Users** con el correo indicado.
4. Ejecuta la aplicacion desde el menu de Windows:

```powershell
scripts\00_PREPARAR_WINDOWS.bat
scripts\01_MENU_WINDOWS.bat
```

El menu inicia Flutter con `config/local.json` mediante
`--dart-define-from-file=config/local.json`.

No uses la clave `service_role` dentro de Flutter.
