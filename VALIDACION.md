# Validación del laboratorio

Fecha: 31 de octubre de 2026.

## Comandos ejecutados

| Comando | Resultado final |
| --- | --- |
| flutter pub get | Correcto; dependencias resueltas |
| dart format lib test | Correcto; código formateado |
| flutter analyze | Sin errores ni advertencias |
| flutter test | 6 pruebas aprobadas |
| flutter run -d chrome --web-port 7358 | Aplicación compilada e iniciada en Chrome |
| node tool/verificar_chrome.mjs | Cinco capturas; imagen remota HTTP 200; sin excepciones de aplicación ni mensajes de desbordamiento |

Se utilizó Flutter desde C:\flutter_windows_3.35.3-stable\flutter\bin\flutter.bat porque no está en el PATH de esta terminal. El SDK no fue editado; los comandos necesitaron acceso normal a sus archivos de bloqueo y caché fuera del sandbox.

## Cobertura

- Navegación por las cuatro categorías en anchos de 320, 390 y 760 píxeles.
- Desplazamiento horizontal del carrusel y vertical del catálogo, comprobando sus posiciones de scroll.
- Apertura del detalle, regreso, agregar favoritos y eliminarlos desde Mi lista.
- Estado vacío de favoritos y mensaje de selección de un plan ficticio.
- Imagen local y alternativa de error ante una imagen remota inaccesible.
- Revisión visual de las cinco pantallas en Chrome, emulando 390 × 844 píxeles.
- Carga remota real con estado HTTP 200 en el navegador.

Las capturas y el informe del navegador están en docs/capturas/. Los errores iniciales de selectores de pruebas y la captura prematura de carga se corrigieron antes de la ejecución final.

## Límites y pendientes

- No se ejecutó la aplicación en un teléfono o emulador Android ni se generó un APK.
- Flutter mostró advertencias de conexión del inspector DevTools durante la automatización con otra ventana de Chrome; las capturas finales se renderizaron y el registro de la aplicación quedó sin excepciones. No se validó el uso interactivo del inspector.
- Los favoritos duran durante la sesión; no hay persistencia en disco por el alcance del laboratorio.
- Las imágenes locales son placeholders originales y los títulos son ficticios. Reemplazar solamente con material propio o autorizado si se desean posters cinematográficos.
- No se ha publicado el proyecto en GitHub ni se han creado commits.

## Actualización: integración OMDb
- Añadidos omdb_service.dart y paquete http; catálogo compartido entre Inicio, Películas y favoritos.
- Clave personal en omdb.local.json (ignorado por Git); ejecución disponible con F5 desde VS Code.
- Consulta real HTTPS: Response=True, Interstellar, 2014, poster disponible.
- flutter pub get y dart format lib test: correctos.
- flutter analyze: sin incidencias.
- flutter test: 11 pruebas aprobadas, incluyendo respuestas HTTP simuladas y errores de OMDb.
- Las series mantienen el catálogo de demostración.
- Chrome con OMDb: seis consultas y seis posters con HTTP 200. Cinco capturas actualizadas, sin excepciones ni mensajes RenderFlex. La primera automatización agotó la espera durante la compilación; la repetición con la aplicación lista terminó correctamente.
