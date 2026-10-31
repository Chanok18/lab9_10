import '../models/contenido.dart';
import 'package:flutter/foundation.dart';

// List contiene varios elementos; cada Map relaciona un campo con su valor.
const List<Map<String, String>> planes = [
  {
    'nombre': 'Prime Esencial',
    'precio': 'S/ 19.90',
    'beneficio': 'Un dispositivo • Calidad HD',
  },
  {
    'nombre': 'Prime Familiar',
    'precio': 'S/ 29.90',
    'beneficio': 'Tres dispositivos • Full HD',
  },
  {
    'nombre': 'Prime Premium',
    'precio': 'S/ 39.90',
    'beneficio': 'Cuatro dispositivos • Calidad 4K',
  },
];
final catalogoActual = ValueNotifier<List<Contenido>>(catalogoDemo);
List<Contenido> get catalogo => catalogoActual.value;

const catalogoDemo = <Contenido>[
  Contenido(
    id: 'orbita',
    titulo: 'ÓRBITA\nPERDIDA',
    sinopsis:
        'Una señal llega desde el límite del sistema solar. Una piloto emprende un viaje para descubrir quién sigue esperando al otro lado.',
    genero: 'Ciencia ficción · Aventura',
    anio: 2026,
    imagen: 'assets/images/orbita.png',
    etiqueta: 'Nueva película',
  ),
  Contenido(
    id: 'ciudad',
    titulo: 'CIUDAD\nSIN ECO',
    sinopsis:
        'Una investigadora sigue una pista que podría cambiar el destino de una ciudad que nunca duerme.',
    genero: 'Suspenso · Acción',
    anio: 2025,
    imagen: 'assets/images/ciudad.png',
    etiqueta: 'Mejor valorado',
  ),
  Contenido(
    id: 'marea',
    titulo: 'LA ÚLTIMA\nMAREA',
    sinopsis:
        'Dos hermanos regresan a la costa donde crecieron para recuperar una historia que creían olvidada.',
    genero: 'Drama · Aventura',
    anio: 2024,
    imagen: 'assets/images/marea.png',
  ),
  Contenido(
    id: 'bosque',
    titulo: 'EL BOSQUE\nAZUL',
    sinopsis:
        'Una exploradora encuentra el camino hacia un mundo inesperado. Un pequeño pueblo guarda un secreto.',
    genero: 'Fantasía · Misterio',
    anio: 2026,
    imagen: 'assets/images/bosque.png',
    esSerie: true,
    etiqueta: 'Nueva serie',
  ),
  Contenido(
    id: 'horizonte',
    titulo: 'HORIZONTE',
    sinopsis:
        'Viajeros documentan paisajes y las historias de quienes los habitan. Una nueva aventura en cada episodio.',
    genero: 'Documental · Naturaleza',
    anio: 2025,
    imagen:
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=900&auto=format&fit=crop&q=80',
    esSerie: true,
    enRed: true,
    etiqueta: 'Mejor valorado',
  ),
  Contenido(
    id: 'noche',
    titulo: 'DESPUÉS DE\nMEDIANOCHE',
    sinopsis:
        'Cada noche, una emisora conecta a desconocidos cuyas vidas están a punto de cruzarse.',
    genero: 'Drama · Misterio',
    anio: 2025,
    imagen: 'assets/images/ciudad.png',
    esSerie: true,
  ),
];
