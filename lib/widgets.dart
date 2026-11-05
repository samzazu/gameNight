import 'package:flutter/material.dart';

import 'estado.dart';
import 'modelos.dart';
import 'pantalla_detalle.dart';
import 'tema.dart';

class Etiqueta extends StatelessWidget {
  final IconData icono;
  final String texto;
  final Color? color;

  const Etiqueta({super.key, required this.icono, required this.texto, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colores.primario;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 15, color: c),
          const SizedBox(width: 4),
          Text(texto,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c)),
        ],
      ),
    );
  }
}

class ImagenJuego extends StatelessWidget {
  final String ruta;
  final BoxFit fit;

  const ImagenJuego({super.key, required this.ruta, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ruta,
      fit: fit,
      errorBuilder: (context, error, stack) => Container(
        color: Colores.primarioClaro,
        alignment: Alignment.center,
        child: const Icon(Icons.casino_outlined, color: Colores.primario, size: 36),
      ),
    );
  }
}

class BotonFavorito extends StatelessWidget {
  final String id;
  const BotonFavorito({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: misJuegos,
      builder: (context, _) {
        final activo = misJuegos.esFavorito(id);
        return IconButton(
          tooltip: activo ? 'Quitar de favoritos' : 'Agregar a favoritos',
          onPressed: () => misJuegos.alternarFavorito(id),
          icon: Icon(
            activo ? Icons.favorite : Icons.favorite_border,
            color: activo ? Colores.favorito : Colores.textoSuave,
          ),
        );
      },
    );
  }
}

class TarjetaJuego extends StatelessWidget {
  final Juego juego;
  const TarjetaJuego({super.key, required this.juego});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PantallaDetalle(juego: juego)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 110,
              child: Hero(
                tag: 'img_${juego.id}',
                child: ImagenJuego(ruta: juego.imagen),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(juego.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(juego.descripcionCorta,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, color: Colores.textoSuave)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Etiqueta(
                            icono: Icons.group_outlined,
                            texto: juego.jugadoresTexto),
                        Etiqueta(
                            icono: Icons.schedule,
                            texto: '${juego.duracion} min'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BotonFavorito(id: juego.id),
          ],
        ),
      ),
    );
  }
}

class EstadoVacio extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String mensaje;

  const EstadoVacio({
    super.key,
    required this.icono,
    required this.titulo,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 56, color: Colores.textoSuave),
            const SizedBox(height: 12),
            Text(titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colores.textoSuave)),
          ],
        ),
      ),
    );
  }
}
