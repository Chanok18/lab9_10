import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/contenido.dart';
import 'package:flutter_application_1/widgets/featured_banner.dart';
import 'package:flutter_application_1/widgets/contenido_card.dart';
import 'package:flutter_application_1/widgets/contenido_carousel.dart';
import 'package:flutter_application_1/screens/inicio_screen.dart';

void main() {
  setUp(() => favoritos.value = <String>{});
  for (final width in [320.0, 390.0, 760.0]) {
    testWidgets('Navegación y scroll sin desbordamientos a ${width}px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      for (final index in [1, 2, 3, 0]) {
        final nav = find.byType(NavigationBar);
        await tester.tap(
          find
              .descendant(of: nav, matching: find.byType(NavigationDestination))
              .at(index),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      final carrusel = find.descendant(
        of: find.byType(ContenidoCarousel).hitTestable().first,
        matching: find.byType(ListView),
      );
      await tester.ensureVisible(carrusel);
      await tester.pumpAndSettle();
      await tester.drag(carrusel, const Offset(-200, 0));
      await tester.pumpAndSettle();
      final horizontal = tester.state<ScrollableState>(
        find.descendant(of: carrusel, matching: find.byType(Scrollable)),
      );
      expect(horizontal.position.pixels, greaterThan(0));
      final list = find
          .descendant(
            of: find.byType(InicioScreen),
            matching: find.byType(ListView),
          )
          .first;
      await tester.drag(list, const Offset(0, -550));
      await tester.pumpAndSettle();
      final vertical = tester.state<ScrollableState>(
        find.descendant(of: list, matching: find.byType(Scrollable)).first,
      );
      expect(vertical.position.pixels, greaterThan(0));
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Detalle, favoritos compartidos, regreso y eliminación', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final banner = find.byType(FeaturedBanner).hitTestable();
    await tester.tap(
      find.descendant(of: banner, matching: find.text('Ver información')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Información del título'), findsOneWidget);
    final favorito = find.text('Agregar a favoritos');
    await tester.scrollUntilVisible(
      favorito,
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(favorito);
    await tester.pumpAndSettle();
    expect(favoritos.value, contains('orbita'));
    expect(find.text('Quitar de favoritos'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mi lista'));
    await tester.pumpAndSettle();
    expect(find.text('Mi lista'), findsOneWidget);
    await tester.tap(find.byTooltip('Quitar de favoritos').last);
    await tester.pumpAndSettle();
    expect(favoritos.value, isEmpty);
    expect(find.text('Aún no agregaste favoritos.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'Imágenes locales se decodifican y la imagen remota tiene alternativa',
    (tester) async {
      const local = Contenido(
        id: 'local',
        titulo: 'Local',
        sinopsis: '',
        genero: '',
        anio: 2026,
        imagen: 'assets/images/orbita.png',
      );
      const remoto = Contenido(
        id: 'red',
        titulo: 'Red',
        sinopsis: '',
        genero: '',
        anio: 2026,
        imagen: 'https://example.invalid/test.png',
        enRed: true,
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(height: 300, child: ImagenContenido(contenido: local)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.landscape_outlined), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            height: 300,
            child: ImagenContenido(contenido: remoto),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.landscape_outlined), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('Planes muestran un mensaje y no inician pagos', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(
      find
          .descendant(
            of: find.byType(NavigationBar),
            matching: find.byType(NavigationDestination),
          )
          .at(3),
    );
    await tester.pumpAndSettle();
    final boton = find.text('Elegir plan de demostración').first;
    await tester.ensureVisible(boton);
    await tester.tap(boton);
    await tester.pump();
    expect(find.textContaining('No se realizará ningún pago.'), findsOneWidget);
  });
}
