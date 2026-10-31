import 'package:flutter/material.dart';
import '../data/catalogo_data.dart';
import '../models/contenido.dart';
import '../screens/inicio_screen.dart';
import '../screens/peliculas_screen.dart';
import '../screens/series_screen.dart';
import '../screens/suscripciones_screen.dart';
import '../data/omdb_service.dart';
import 'package:http/http.dart' as http;

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});
  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final _client = http.Client();
  bool _cargando = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    if (OmdbService.claveConfigurada.isNotEmpty) _cargarPeliculas();
  }

  Future<void> _cargarPeliculas() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final peliculas = await OmdbService(
        apiKey: OmdbService.claveConfigurada,
        client: _client,
      ).peliculas();
      if (!mounted) return;
      catalogoActual.value = [
        ...peliculas,
        ...catalogoDemo.where((c) => c.esSerie),
      ];
    } on OmdbException catch (error) {
      if (mounted) setState(() => _error = error.mensaje);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  int pagina = 0;
  static const nombres = ['Inicio', 'Películas', 'Series', 'Suscripciones'];
  void cambiar(int index) => setState(() => pagina = index);
  void verFavoritos() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: ValueListenableBuilder<Set<String>>(
        valueListenable: favoritos,
        builder: (context, ids, child) {
          final items = catalogo.where((c) => ids.contains(c.id)).toList();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Mi lista',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Aún no agregaste favoritos.'),
                ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(items[index].titulo.replaceAll('\n', ' ')),
                    trailing: IconButton(
                      tooltip: 'Quitar de favoritos',
                      icon: const Icon(Icons.favorite),
                      onPressed: () => favoritos.alternar(items[index].id),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        this.context,
                        '/detalle',
                        arguments: items[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'prime video',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 23,
          letterSpacing: -1,
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Transmitir demo',
          onPressed: () => mensajeDemo(
            context,
            'Transmisión de demostración: no hay dispositivos conectados.',
          ),
          icon: const Icon(Icons.cast),
        ),
        IconButton(
          tooltip: 'Mi lista',
          onPressed: verFavoritos,
          icon: const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF1679B7),
            child: Icon(Icons.person, size: 22, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: SizedBox(
          height: 58,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: nombres.length,
            separatorBuilder: (_, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) => ChoiceChip(
              label: Text(nombres[index]),
              selected: pagina == index,
              showCheckmark: false,
              selectedColor: Colors.white,
              labelStyle: TextStyle(
                color: pagina == index ? Colors.black : Colors.white,
              ),
              shape: const StadiumBorder(),
              onSelected: (_) => cambiar(index),
            ),
          ),
        ),
      ),
    ),
    body: Column(
      children: [
        if (_cargando) const LinearProgressIndicator(),
        if (_error != null)
          ListTile(
            title: Text(_error!),
            subtitle: const Text('Mostrando catálogo de demostración.'),
            trailing: IconButton(
              tooltip: 'Reintentar',
              onPressed: _cargarPeliculas,
              icon: const Icon(Icons.refresh),
            ),
          ),
        Expanded(
          child: ValueListenableBuilder<List<Contenido>>(
            valueListenable: catalogoActual,
            builder: (context, items, child) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: IndexedStack(
                  index: pagina,
                  children: [
                    InicioScreen(verPlanes: () => cambiar(3)),
                    PeliculasScreen(contenidos: items),
                    const SeriesScreen(),
                    const SuscripcionesScreen(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: pagina,
      onDestinationSelected: cambiar,
      backgroundColor: const Color(0xFF050B15),
      indicatorColor: const Color(0xFF17334C),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.movie_outlined),
          label: 'Películas',
        ),
        NavigationDestination(icon: Icon(Icons.live_tv), label: 'Series'),
        NavigationDestination(
          icon: Icon(Icons.workspace_premium_outlined),
          label: 'Suscripciones',
        ),
      ],
    ),
  );
}
