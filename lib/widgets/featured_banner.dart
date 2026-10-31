import 'package:flutter/material.dart';
import '../models/contenido.dart';
import 'contenido_card.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({super.key, required this.contenido});
  final Contenido contenido;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 440,
    child: Stack(
      fit: StackFit.expand,
      children: [
        ImagenContenido(contenido: contenido),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, .35, 1],
              colors: [Color(0x15050B15), Color(0x45050B15), Color(0xFF050B15)],
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 20,
          right: 20,
          // Column organiza los textos y las acciones verticalmente.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'P R I M E   •   SELECCIÓN DEL DÍA',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.4,
                  color: Color(0xFF72D7FF),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                contenido.titulo,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                '${contenido.anio}   •   ${contenido.genero}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                contenido.sinopsis,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              // Row coloca ambos botones en la misma fila; Expanded limita su ancho.
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/detalle',
                        arguments: contenido,
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Ver información'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ValueListenableBuilder<Set<String>>(
                    valueListenable: favoritos,
                    builder: (_, ids, child) => IconButton.filledTonal(
                      tooltip: ids.contains(contenido.id)
                          ? 'Quitar de favoritos'
                          : 'Agregar a favoritos',
                      onPressed: () => favoritos.alternar(contenido.id),
                      icon: Icon(
                        ids.contains(contenido.id) ? Icons.check : Icons.add,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  '●  ○  ○  ○  ○',
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
