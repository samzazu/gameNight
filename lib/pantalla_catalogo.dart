import 'package:flutter/material.dart';

import 'datos.dart';
import 'modelos.dart';
import 'pantalla_mis_juegos.dart';
import 'tema.dart';
import 'widgets.dart';

class PantallaCatalogo extends StatefulWidget {
  const PantallaCatalogo({super.key});

  @override
  State<PantallaCatalogo> createState() => _PantallaCatalogoState();
}

class _PantallaCatalogoState extends State<PantallaCatalogo> {
  final Filtros _filtros = Filtros();
  final TextEditingController _controladorBusqueda = TextEditingController();

  late final List<String> _categorias = [
    Filtros.todas,
    ...{for (final j in catalogoJuegos) j.categoria},
  ];

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  Future<void> _abrirFiltros() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _HojaFiltros(
        filtros: _filtros,
        alCambiar: () => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultados = catalogoJuegos.where(_filtros.coincide).toList();
    final hayFiltros = _filtros.activos > 0 || _filtros.busqueda.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        actions: [
          IconButton(
            tooltip: 'Favoritos y por probar',
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PantallaMisJuegos()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorBusqueda,
                    onChanged: (v) => setState(() => _filtros.busqueda = v),
                    decoration: InputDecoration(
                      hintText: 'Buscar juego por nombre',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _filtros.busqueda.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _controladorBusqueda.clear();
                                setState(() => _filtros.busqueda = '');
                              },
                            ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Badge(
                  isLabelVisible: _filtros.activos > 0,
                  label: Text('${_filtros.activos}'),
                  child: IconButton.filled(
                    tooltip: 'Filtros',
                    onPressed: _abrirFiltros,
                    icon: const Icon(Icons.tune),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categorias.length,
              separatorBuilder: (context, i) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = _categorias[i];
                return ChoiceChip(
                  label: Text(c),
                  avatar: c == Filtros.todas
                      ? null
                      : Icon(iconoCategoria(c), size: 16),
                  selected: _filtros.categoria == c,
                  onSelected: (_) => setState(() => _filtros.categoria = c),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Text(
                  '${resultados.length} ${resultados.length == 1 ? 'juego' : 'juegos'}',
                  style: const TextStyle(color: Colores.textoSuave),
                ),
                const Spacer(),
                if (hayFiltros)
                  TextButton(
                    onPressed: () {
                      _controladorBusqueda.clear();
                      setState(_filtros.limpiar);
                    },
                    child: const Text('Limpiar filtros'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: resultados.isEmpty
                ? const EstadoVacio(
                    icono: Icons.search_off,
                    titulo: 'Sin resultados',
                    mensaje: 'Prueba con otro nombre o quita algunos filtros.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: resultados.length,
                    separatorBuilder: (context, i) => const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        TarjetaJuego(juego: resultados[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _HojaFiltros extends StatefulWidget {
  final Filtros filtros;
  final VoidCallback alCambiar;

  const _HojaFiltros({required this.filtros, required this.alCambiar});

  @override
  State<_HojaFiltros> createState() => _HojaFiltrosState();
}

class _HojaFiltrosState extends State<_HojaFiltros> {
  void _cambiar(VoidCallback cambio) {
    setState(cambio);
    widget.alCambiar();
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.filtros;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Filtros',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const Spacer(),
                TextButton(
                  onPressed: () => _cambiar(() {
                    f.categoria = Filtros.todas;
                    f.duracion = RangoDuracion.cualquiera;
                    f.jugadores = null;
                  }),
                  child: const Text('Restablecer'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Duración',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final r in RangoDuracion.values)
                  ChoiceChip(
                    label: Text(r.etiqueta),
                    selected: f.duracion == r,
                    onSelected: (_) => _cambiar(() => f.duracion = r),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Número de participantes',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ChoiceChip(
                  label: const Text('Cualquiera'),
                  selected: f.jugadores == null,
                  onSelected: (_) => _cambiar(() => f.jugadores = null),
                ),
                for (var n = 1; n <= 8; n++)
                  ChoiceChip(
                    label: Text('$n'),
                    selected: f.jugadores == n,
                    onSelected: (_) => _cambiar(() => f.jugadores = n),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aplicar'),
            ),
          ],
        ),
      ),
    );
  }
}
