# Reglas para Codex

## Uso de CPU
- Ejecutar solo un comando de terminal a la vez.
- No ejecutar comandos de Dart o Flutter en paralelo.
- Esperar a que cada comando termine antes de iniciar otro.
- No ejecutar `dart format lib`.
- Formatear únicamente los archivos Dart modificados.
- No ejecutar un nuevo `dart format` si ya hay otro en ejecución.
- Evitar procesos pesados innecesarios.
- Priorizar bajo consumo de CPU.

## Flutter
- No ejecutar `flutter analyze` automáticamente después de cada cambio.
- No ejecutar `flutter test` automáticamente salvo que sea necesario.
- Si se necesita validar código, hacerlo una sola vez al terminar los cambios.
- Si un comando tarda demasiado, detenerlo antes de iniciar otro.

## Codex
- No lanzar varias terminales PowerShell para una misma tarea.
- No ejecutar varias validaciones simultáneamente.
- Realizar los cambios primero y las comprobaciones al final.