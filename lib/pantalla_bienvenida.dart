import 'package:flutter/material.dart';

import 'datos.dart';
import 'estado.dart';
import 'pantalla_catalogo.dart';
import 'pantalla_mis_juegos.dart';
import 'tema.dart';

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4B45A8), Colores.primario],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.casino, size: 56, color: Colores.acento),
                ),
                const SizedBox(height: 24),
                const Text(
                  'GameNight',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Descubre el juego de mesa perfecto para tu próxima reunión.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 18,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${catalogoJuegos.length} juegos · filtra por categoría, duración y jugadores',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 14,
                  ),
                ),
                const Spacer(flex: 2),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colores.acento,
                    foregroundColor: Colores.texto,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PantallaCatalogo()),
                  ),
                  icon: const Icon(Icons.grid_view_rounded),
                  label: const Text('Explorar catálogo',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 12),
                ListenableBuilder(
                  listenable: misJuegos,
                  builder: (context, _) {
                    final total =
                        misJuegos.favoritos.length + misJuegos.pendientes.length;
                    return OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const PantallaMisJuegos()),
                      ),
                      icon: const Icon(Icons.favorite_border),
                      label: Text(
                        total == 0
                            ? 'Favoritos y por probar'
                            : 'Favoritos y por probar ($total)',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
