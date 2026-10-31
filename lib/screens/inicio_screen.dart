import 'package:flutter/material.dart';
import '../data/catalogo_data.dart';
import '../widgets/contenido_carousel.dart';
import '../widgets/featured_banner.dart';

void mensajeDemo(BuildContext context, String texto) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key, required this.verPlanes});
  final VoidCallback verPlanes;
  @override
  Widget build(BuildContext context) => ListView(
    key: const PageStorageKey('inicio'),
    children: [
      FeaturedBanner(contenido: catalogo.first),
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text('Bienvenido, Kevin. Tu próxima historia empieza aquí.'),
      ),
      ContenidoCarousel(
        titulo: 'Continuar explorando',
        items: catalogo.take(3).toList(),
        continuar: true,
      ),
      ContenidoCarousel(
        titulo: 'Prime · Películas recomendadas',
        items: catalogo.where((c) => !c.esSerie).toList(),
      ),
      ContenidoCarousel(
        titulo: 'Series para descubrir',
        items: catalogo.where((c) => c.esSerie).toList(),
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Un mundo de historias',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Explora nuestros planes de demostración para este laboratorio.',
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton(
                      onPressed: verPlanes,
                      child: const Text('Ver suscripciones'),
                    ),
                    OutlinedButton(
                      onPressed: () => mensajeDemo(
                        context,
                        'Identificación de demostración. No se necesita una cuenta.',
                      ),
                      child: const Text('Identificarse'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
