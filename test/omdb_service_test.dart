import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_application_1/data/omdb_service.dart';

void main() {
  test(
    'Consulta HTTPS por IMDb y convierte el catálogo con sinopsis y posters',
    () async {
      var consultas = 0;
      final client = MockClient((request) async {
        consultas++;
        expect(request.url.scheme, 'https');
        expect(request.url.host, 'www.omdbapi.com');
        expect(request.url.queryParameters['plot'], 'full');
        expect(request.url.queryParameters['apikey'], 'clave-de-prueba');
        return http.Response(
          jsonEncode({
            'Response': 'True',
            'imdbID': request.url.queryParameters['i'],
            'Title': 'Interstellar',
            'Year': '2014',
            'Genre': 'Sci-Fi',
            'Plot': 'Una expedición espacial.',
            'imdbRating': '8.7',
            'Poster': 'https://example.com/poster.jpg',
          }),
          200,
        );
      });
      addTearDown(client.close);
      final peliculas = await OmdbService(
        apiKey: 'clave-de-prueba',
        client: client,
      ).peliculas();
      expect(consultas, 6);
      expect(peliculas.length, 6);
      expect(peliculas.first.anio, 2014);
      expect(peliculas.first.sinopsis, 'Una expedición espacial.');
      expect(peliculas.first.enRed, isTrue);
      expect(peliculas.first.etiqueta, 'IMDb 8.7 / 10');
    },
  );
  test('Sin clave no se hacen solicitudes', () async {
    final client = MockClient(
      (_) async => throw StateError('No debe consultar'),
    );
    addTearDown(client.close);
    await expectLater(
      OmdbService(apiKey: '', client: client).peliculas(),
      throwsA(isA<OmdbException>()),
    );
  });
  test('La cuota agotada devuelve un error comprensible', () async {
    final client = MockClient(
      (_) async => http.Response(
        '{"Response":"False","Error":"Request limit reached!"}',
        200,
      ),
    );
    addTearDown(client.close);
    await expectLater(
      OmdbService(apiKey: 'test', client: client).porId('tt0816692'),
      throwsA(
        isA<OmdbException>().having(
          (e) => e.mensaje,
          'mensaje',
          contains('límite'),
        ),
      ),
    );
  });
  test(
    'Credenciales inválidas y errores de conexión no exponen la clave',
    () async {
      final client = MockClient((_) async => http.Response('', 401));
      addTearDown(client.close);
      await expectLater(
        OmdbService(apiKey: 'secreto', client: client).porId('tt0816692'),
        throwsA(
          isA<OmdbException>().having(
            (e) => e.mensaje,
            'mensaje',
            isNot(contains('secreto')),
          ),
        ),
      );
      final offline = MockClient(
        (_) async => throw http.ClientException('offline'),
      );
      addTearDown(offline.close);
      await expectLater(
        OmdbService(apiKey: 'test', client: offline).porId('tt0816692'),
        throwsA(isA<OmdbException>()),
      );
    },
  );
  test('Campos N/A usan alternativas locales', () {
    final pelicula = OmdbService.desdeJson({
      'Title': 'Sin poster',
      'Poster': 'N/A',
      'Year': 'N/A',
      'Plot': 'N/A',
    });
    expect(pelicula.enRed, isFalse);
    expect(pelicula.imagen, 'assets/images/orbita.png');
    expect(pelicula.sinopsis, 'Sinopsis no disponible.');
  });
}
