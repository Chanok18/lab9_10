import 'package:flutter/foundation.dart';

class Contenido {
  const Contenido({
    required this.id,
    required this.titulo,
    required this.sinopsis,
    required this.genero,
    required this.anio,
    required this.imagen,
    this.esSerie = false,
    this.enRed = false,
    this.etiqueta = 'Incluido con Prime',
  });
  final String id, titulo, sinopsis, genero, imagen, etiqueta;
  final int anio;
  final bool esSerie, enRed;
}

// Los favoritos se guardan en memoria durante la sesión, sin base de datos.
class Favoritos extends ValueNotifier<Set<String>> {
  Favoritos() : super(<String>{});
  void alternar(String id) {
    final copia = {...value};
    copia.contains(id) ? copia.remove(id) : copia.add(id);
    value = copia;
  }
}

final favoritos = Favoritos();
