import 'package:flutter/material.dart';
import '../models/contenido.dart';
import 'contenido_card.dart';

class ContenidoCarousel extends StatelessWidget {
  const ContenidoCarousel({
    super.key,
    required this.titulo,
    required this.items,
    this.continuar = false,
  });
  final String titulo;
  final List<Contenido> items;
  final bool continuar;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: continuar ? 146 : 224,
          // ListView.builder crea las tarjetas visibles del carrusel horizontal.
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ContenidoCard(
                contenido: items[index],
                continuar: continuar,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
