import 'package:flutter/material.dart';

import 'datos.dart';
import 'estado.dart';
import 'tema.dart';
import 'widgets.dart';

class PantallaMisJuegos extends StatelessWidget {
  const PantallaMisJuegos({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis juegos'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'Favoritos'),
              Tab(icon: Icon(Icons.bookmark), text: 'Por probar'),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: misJuegos,
          builder: (context, _) {
            return TabBarView(
              children: [
                _Lista(
                  ids: misJuegos.favoritos,
                  vacioIcono: Icons.favorite_border,
                  vacioTitulo: 'Aún no tienes favoritos',
                  vacioMensaje:
                      'Toca el corazón en cualquier juego para guardarlo aquí.',
                ),
                _Lista(
                  ids: misJuegos.pendientes,
                  vacioIcono: Icons.bookmark_border,
                  vacioTitulo: 'Tu lista por probar está vacía',
                  vacioMensaje:
                      'En el detalle de un juego toca "Quiero probarlo" para agregarlo.',
                  conQuitar: true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Lista extends StatelessWidget {
  final Set<String> ids;
  final IconData vacioIcono;
  final String vacioTitulo;
  final String vacioMensaje;
  final bool conQuitar;

  const _Lista({
    required this.ids,
    required this.vacioIcono,
    required this.vacioTitulo,
    required this.vacioMensaje,
    this.conQuitar = false,
  });

  @override
  Widget build(BuildContext context) {
    final juegos = catalogoJuegos.where((j) => ids.contains(j.id)).toList();
    if (juegos.isEmpty) {
      return EstadoVacio(
          icono: vacioIcono, titulo: vacioTitulo, mensaje: vacioMensaje);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: juegos.length,
      separatorBuilder: (context, i) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final juego = juegos[i];
        if (!conQuitar) return TarjetaJuego(juego: juego);
        return Stack(
          children: [
            TarjetaJuego(juego: juego),
            Positioned(
              right: 8,
              bottom: 6,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                    foregroundColor: Colores.pendiente,
                    visualDensity: VisualDensity.compact),
                onPressed: () => misJuegos.alternarPendiente(juego.id),
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Quitar'),
              ),
            ),
          ],
        );
      },
    );
  }
}
