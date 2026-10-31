import 'package:flutter/material.dart';
import '../data/catalogo_data.dart';
import 'inicio_screen.dart';

class SuscripcionesScreen extends StatelessWidget {
  const SuscripcionesScreen({super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.auto_awesome, color: Color(0xFF00A8E1), size: 38),
        const SizedBox(height: 20),
        Text(
          'Más historias.\nMás posibilidades.',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        const Text(
          'Planes académicos de demostración. Precios ficticios, sin cobros ni contrataciones.',
        ),
        const SizedBox(height: 24),
        ...planes.map(
          (plan) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    plan['nombre']!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${plan['precio']} / mes',
                    style: const TextStyle(fontSize: 26, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 12),
                  Text(plan['beneficio']!),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF00A8E1),
                    ),
                    title: Text('Películas y series'),
                    subtitle: Text('Interfaz de demostración'),
                  ),
                  FilledButton(
                    onPressed: () => mensajeDemo(
                      context,
                      '${plan['nombre']}: selección de demostración. No se realizará ningún pago.',
                    ),
                    child: const Text('Elegir plan de demostración'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
