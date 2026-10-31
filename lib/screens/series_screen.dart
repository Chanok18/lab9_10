import 'package:flutter/material.dart';
import '../data/catalogo_data.dart';
import '../widgets/contenido_carousel.dart';
import '../widgets/featured_banner.dart';

class SeriesScreen extends StatelessWidget {
  const SeriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final series = catalogo.where((c) => c.esSerie).toList();
    return ListView(
      key: const PageStorageKey('series'),
      children: [
        FeaturedBanner(contenido: series.first),
        ContenidoCarousel(titulo: 'Series que te atrapan', items: series),
        const SizedBox(height: 20),
        // ListTile reúne título, descripción y acción en una fila.
        ...series.map(
          (c) => ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: const CircleAvatar(child: Icon(Icons.live_tv)),
            title: Text(c.titulo.replaceAll('\n', ' ')),
            subtitle: Text(
              c.sinopsis,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/detalle', arguments: c),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
