enum Dificultad {
  facil('Fácil', 1),
  media('Media', 2),
  dificil('Difícil', 3);

  final String etiqueta;
  final int nivel;
  const Dificultad(this.etiqueta, this.nivel);
}

class Juego {
  final String id;
  final String nombre;
  final String descripcionCorta;
  final String descripcion;
  final String categoria;
  final int minJugadores;
  final int maxJugadores;
  final int duracion;
  final Dificultad dificultad;
  final int edadMinima;
  final String imagen;
  final List<String> reglas;

  const Juego({
    required this.id,
    required this.nombre,
    required this.descripcionCorta,
    required this.descripcion,
    required this.categoria,
    required this.minJugadores,
    required this.maxJugadores,
    required this.duracion,
    required this.dificultad,
    required this.edadMinima,
    required this.imagen,
    required this.reglas,
  });

  bool admiteJugadores(int n) => n >= minJugadores && n <= maxJugadores;

  String get jugadoresTexto => minJugadores == maxJugadores
      ? '$minJugadores'
      : '$minJugadores–$maxJugadores';
}

enum RangoDuracion {
  cualquiera('Cualquiera', 0, 9999),
  corta('Hasta 20 min', 0, 20),
  media('21 a 45 min', 21, 45),
  larga('Más de 45 min', 46, 9999);

  final String etiqueta;
  final int min;
  final int max;
  const RangoDuracion(this.etiqueta, this.min, this.max);
}

class Filtros {
  static const String todas = 'Todas';

  String busqueda = '';
  String categoria = todas;
  RangoDuracion duracion = RangoDuracion.cualquiera;
  int? jugadores;

  int get activos {
    var n = 0;
    if (categoria != todas) n++;
    if (duracion != RangoDuracion.cualquiera) n++;
    if (jugadores != null) n++;
    return n;
  }

  void limpiar() {
    busqueda = '';
    categoria = todas;
    duracion = RangoDuracion.cualquiera;
    jugadores = null;
  }

  bool coincide(Juego j) {
    final okNombre = _normalizar(j.nombre).contains(_normalizar(busqueda.trim()));
    final okCategoria = categoria == todas || j.categoria == categoria;
    final okDuracion = j.duracion >= duracion.min && j.duracion <= duracion.max;
    final okJugadores = jugadores == null || j.admiteJugadores(jugadores!);
    return okNombre && okCategoria && okDuracion && okJugadores;
  }
}

String _normalizar(String texto) {
  const de = 'áéíóúüñÁÉÍÓÚÜÑ';
  const a = 'aeiouunaeiouun';
  var r = texto.toLowerCase();
  for (var i = 0; i < de.length; i++) {
    r = r.replaceAll(de[i].toLowerCase(), a[i]);
  }
  return r;
}
