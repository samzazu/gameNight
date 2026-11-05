import 'package:flutter/material.dart';

import 'estado.dart';
import 'modelos.dart';
import 'tema.dart';
import 'widgets.dart';

class PantallaDetalle extends StatelessWidget {
  final Juego juego;
  const PantallaDetalle({super.key, required this.juego});

  @override
  Widget build(BuildContext context) {
    final colorDif = Colores.dificultad(juego.dificultad.nivel);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colores.primario,
            foregroundColor: Colors.white,
            actions: [BotonFavorito(id: juego.id)],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(juego.nombre,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              background: Hero(
                tag: 'img_${juego.id}',
                child: ImagenJuego(ruta: juego.imagen),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Etiqueta(
                          icono: iconoCategoria(juego.categoria),
                          texto: juego.categoria),
                      Etiqueta(
                          icono: Icons.speed,
                          texto: 'Dificultad ${juego.dificultad.etiqueta}',
                          color: colorDif),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _Dato(
                          icono: Icons.group_outlined,
                          titulo: 'Jugadores',
                          valor: juego.jugadoresTexto),
                      _Dato(
                          icono: Icons.schedule,
                          titulo: 'Duración',
                          valor: '${juego.duracion} min'),
                      _Dato(
                          icono: Icons.cake_outlined,
                          titulo: 'Edad',
                          valor: '${juego.edadMinima}+'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _Titulo('Descripción'),
                  Text(juego.descripcion,
                      style: const TextStyle(fontSize: 15, height: 1.5)),
                  const SizedBox(height: 24),
                  const _Titulo('Dificultad'),
                  Row(
                    children: [
                      for (var i = 1; i <= 3; i++)
                        Container(
                          width: 36,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: i <= juego.dificultad.nivel
                                ? colorDif
                                : Colors.black12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      const SizedBox(width: 6),
                      Text(juego.dificultad.etiqueta,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: colorDif)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _Titulo('Reglas básicas'),
                  for (var i = 0; i < juego.reglas.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Colores.primarioClaro,
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colores.primario)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(juego.reglas[i],
                                style: const TextStyle(fontSize: 15, height: 1.4)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  ListenableBuilder(
                    listenable: misJuegos,
                    builder: (context, _) {
                      final pendiente = misJuegos.esPendiente(juego.id);
                      return FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              pendiente ? Colores.pendiente : Colores.primario,
                        ),
                        onPressed: () {
                          misJuegos.alternarPendiente(juego.id);
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                              content: Text(pendiente
                                  ? 'Quitado de tu lista por probar'
                                  : 'Agregado a tu lista por probar'),
                            ));
                        },
                        icon: Icon(pendiente
                            ? Icons.bookmark_added
                            : Icons.bookmark_add_outlined),
                        label: Text(pendiente
                            ? 'En mi lista por probar'
                            : 'Quiero probarlo'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  final String texto;
  const _Titulo(this.texto);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(texto,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      );
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;

  const _Dato({required this.icono, required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icono, color: Colores.primario),
              const SizedBox(height: 6),
              Text(valor,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800)),
              Text(titulo,
                  style: const TextStyle(
                      fontSize: 12, color: Colores.textoSuave)),
            ],
          ),
        ),
      ),
    );
  }
}
