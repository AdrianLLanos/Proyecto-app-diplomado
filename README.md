# DentalCare

Aplicacion Flutter para la gestion de clinicas dentales, conectada con Supabase.

## Configuracion

1. Crea un proyecto en Supabase.
2. Ejecuta la migracion con la CLI de Supabase o su contenido en SQL Editor.
3. Crea el usuario autorizado en **Authentication > Users** con el correo indicado.
4. En Windows, prepara el proyecto solo la primera vez:

```powershell
scripts\00_PREPARAR_WINDOWS.bat
```

5. Para levantar la aplicacion en cada ejecucion, usa el menu:

```powershell
scripts\01_MENU_WINDOWS.bat
```

En el menu elige `2. Supabase - Chrome`. El menu inicia Flutter con
`config/local.json` mediante `--dart-define-from-file=config/local.json`.

No uses la clave `service_role` dentro de Flutter.
