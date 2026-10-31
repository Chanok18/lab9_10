import 'package:flutter/material.dart';
import '../models/contenido.dart';
import '../widgets/contenido_card.dart';
import 'inicio_screen.dart';

class DetalleScreen extends StatelessWidget {
  const DetalleScreen({super.key, required this.contenido});
  final Contenido contenido;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Información del título')),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 360, child: ImagenContenido(contenido: contenido)),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contenido.etiqueta,
                  style: const TextStyle(color: Color(0xFF00A8E1)),
                ),
                const SizedBox(height: 12),
                Text(
                  contenido.titulo,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  '${contenido.anio}   •   ${contenido.esSerie ? 'Serie' : 'Película'}   •   ${contenido.genero}',
                ),
                const SizedBox(height: 24),
                Text('Sinopsis', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(contenido.sinopsis),
                const SizedBox(height: 24),
                ValueListenableBuilder<Set<String>>(
                  valueListenable: favoritos,
                  builder: (_, ids, child) => FilledButton.icon(
                    onPressed: () => favoritos.alternar(contenido.id),
                    icon: Icon(
                      ids.contains(contenido.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    label: Text(
                      ids.contains(contenido.id)
                          ? 'Quitar de favoritos'
                          : 'Agregar a favoritos',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => mensajeDemo(
                    context,
                    'Laboratorio académico: reproducción no disponible.',
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Reproducir demo'),
                ),
                const SizedBox(height: 18),
                Text(
                  contenido.id.startsWith('tt')
                      ? 'Información e imágenes: OMDb API • CC BY-NC 4.0. Uso académico. No implica disponibilidad en Prime Video.'
                      : 'Contenido ficticio creado para el laboratorio TECSUP.',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
