import 'package:flutter/material.dart';
import '../data/catalogo_data.dart';
import '../widgets/contenido_carousel.dart';
import '../widgets/featured_banner.dart';
import '../models/contenido.dart';

class PeliculasScreen extends StatelessWidget {
  const PeliculasScreen({super.key, this.contenidos});
  final List<Contenido>? contenidos;
  @override
  Widget build(BuildContext context) {
    final peliculas = (contenidos ?? catalogo)
        .where((c) => !c.esSerie)
        .toList();
    return ListView(
      key: const PageStorageKey('peliculas'),
      children: [
        FeaturedBanner(contenido: peliculas[1]),
        ContenidoCarousel(
          titulo: 'Películas populares',
          items: peliculas,
          continuar: true,
        ),
        ContenidoCarousel(
          titulo: 'Nuevas historias',
          items: peliculas.reversed.toList(),
        ),
        ...peliculas.map(
          (c) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: const Color(0xFF111D2E),
              leading: const Icon(Icons.movie_outlined),
              title: Text(c.titulo.replaceAll('\n', ' ')),
              subtitle: Text(c.etiqueta),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  Navigator.pushNamed(context, '/detalle', arguments: c),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
