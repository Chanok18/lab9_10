import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contenido.dart';

class OmdbException implements Exception {
  const OmdbException(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

class OmdbService {
  OmdbService({required this.apiKey, required this.client});
  final String apiKey;
  final http.Client client;
  static const claveConfigurada = String.fromEnvironment('OMDB_API_KEY');
  // Consultamos por ID para obtener sinopsis y género, no solo la búsqueda.
  static const seleccion = [
    'tt0816692', // Interstellar
    'tt1375666', // Inception
    'tt1160419', // Dune
    'tt0133093', // The Matrix
    'tt0468569', // The Dark Knight
    'tt0245429', // Spirited Away
  ];

  Future<List<Contenido>> peliculas() async {
    if (apiKey.trim().isEmpty) {
      throw const OmdbException('Falta configurar la clave de OMDb.');
    }
    return Future.wait(seleccion.map(porId));
  }

  Future<Contenido> porId(String id) async {
    try {
      final uri = Uri.https('www.omdbapi.com', '/', {
        'apikey': apiKey.trim(),
        'i': id,
        'type': 'movie',
        'plot': 'full',
      });
      final response = await client
          .get(uri)
          .timeout(const Duration(seconds: 12));
      if (response.statusCode == 401) {
        throw const OmdbException(
          'La clave de OMDb no es válida o no está activada.',
        );
      }
      if (response.statusCode != 200) {
        throw const OmdbException(
          'No se pudo conectar con OMDb. Intenta nuevamente.',
        );
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['Response'] != 'True') {
        // Los errores de cuota o credenciales no se muestran como un catálogo vacío.
        final error = (json['Error'] as String? ?? '').toLowerCase();
        throw OmdbException(
          error.contains('limit')
              ? 'Se alcanzó el límite de consultas de OMDb. Intenta más tarde.'
              : 'OMDb no pudo devolver esta película. Revisa tu clave e intenta nuevamente.',
        );
      }
      return desdeJson(json);
    } on OmdbException {
      rethrow;
    } catch (_) {
      // No exponemos URLs ni la API key en mensajes o registros.
      throw const OmdbException(
        'No se pudieron cargar las películas. Revisa tu conexión.',
      );
    }
  }

  static Contenido desdeJson(Map<String, dynamic> json) {
    String texto(String campo, String alternativa) {
      final valor = json[campo];
      return valor is String && valor.isNotEmpty && valor != 'N/A'
          ? valor
          : alternativa;
    }

    final poster = texto('Poster', '');
    final remoto = Uri.tryParse(poster)?.scheme == 'https';
    final nota = double.tryParse(texto('imdbRating', ''));
    return Contenido(
      id: texto('imdbID', 'sin-id'),
      titulo: texto('Title', 'Sin título'),
      sinopsis: texto('Plot', 'Sinopsis no disponible.'),
      genero: texto('Genre', 'Género no disponible'),
      anio:
          int.tryParse(RegExp(r'\d{4}').stringMatch(texto('Year', '')) ?? '') ??
          0,
      imagen: remoto ? poster : 'assets/images/orbita.png',
      enRed: remoto,
      etiqueta: nota == null
          ? 'OMDb · Película'
          : 'IMDb ${nota.toStringAsFixed(1)} / 10',
    );
  }
}
