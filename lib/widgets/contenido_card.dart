import 'package:flutter/material.dart';
import '../models/contenido.dart';

class ImagenContenido extends StatelessWidget {
  const ImagenContenido({super.key, required this.contenido});
  final Contenido contenido;
  @override
  Widget build(BuildContext context) {
    Widget fallo(BuildContext context, Object error, StackTrace? stack) =>
        const ColoredBox(
          color: Color(0xFF16334D),
          child: Center(child: Icon(Icons.landscape_outlined, size: 48)),
        );
    // Image.network muestra carga y una alternativa cuando falla la conexión.
    if (contenido.enRed) {
      return Image.network(
        contenido.imagen,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : const Center(child: CircularProgressIndicator()),
        errorBuilder: fallo,
      );
    }
    // Image.asset carga el arte original incluido en el proyecto.
    return Image.asset(
      contenido.imagen,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: fallo,
    );
  }
}

class ContenidoCard extends StatelessWidget {
  const ContenidoCard({
    super.key,
    required this.contenido,
    this.continuar = false,
  });
  final Contenido contenido;
  final bool continuar;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: continuar ? 246 : 156,
    child: Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            Navigator.pushNamed(context, '/detalle', arguments: contenido),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImagenContenido(contenido: contenido),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xED050B15)],
                ),
              ),
            ),
            const Positioned(
              left: 12,
              top: 10,
              child: Text(
                'prime',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              left: 12,
              right: 10,
              top: 34,
              child: Text(
                contenido.etiqueta,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF72D7FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 10,
              bottom: continuar ? 24 : 14,
              child: Text(
                contenido.titulo,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  height: 1.1,
                ),
              ),
            ),
            if (continuar)
              const Positioned(
                bottom: 8,
                left: 12,
                right: 12,
                child: LinearProgressIndicator(value: .35, minHeight: 3),
              ),
          ],
        ),
      ),
    ),
  );
}
