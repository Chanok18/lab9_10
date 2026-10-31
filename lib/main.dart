import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/app_navigation.dart';
import 'screens/detalle_screen.dart';
import 'models/contenido.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Prime Video • TECSUP',
    theme: AppTheme.dark,
    home: const AppNavigation(),
    // Navigator recibe el contenido mediante los argumentos de la ruta.
    onGenerateRoute: (settings) => settings.name == '/detalle'
        ? MaterialPageRoute<void>(
            settings: settings,
            builder: (_) =>
                DetalleScreen(contenido: settings.arguments! as Contenido),
          )
        : null,
  );
}
