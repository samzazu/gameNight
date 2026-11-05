import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pantalla_bienvenida.dart';
import 'tema.dart';

class OnboardingPrefs {
  static const _clave = 'onboarding_visto';

  static Future<bool> fueVisto() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_clave) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> marcarVisto() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_clave, true);
    } catch (_) {}
  }
}

class _PaginaOnboarding {
  final IconData icono;
  final String titulo;
  final String texto;

  const _PaginaOnboarding({
    required this.icono,
    required this.titulo,
    required this.texto,
  });
}

const List<_PaginaOnboarding> _paginas = [
  _PaginaOnboarding(
    icono: Icons.search,
    titulo: 'Encuentra el juego ideal',
    texto:
        'Explora un catálogo de juegos de mesa con descripción, reglas, dificultad y edad recomendada.',
  ),
  _PaginaOnboarding(
    icono: Icons.tune,
    titulo: 'Filtra a tu medida',
    texto:
        'Elige según el número de jugadores, el tiempo que tienen y la categoría que más les guste.',
  ),
  _PaginaOnboarding(
    icono: Icons.favorite,
    titulo: 'Guarda tus favoritos',
    texto:
        'Marca tus juegos favoritos y arma tu lista de juegos por probar para la próxima reunión.',
  ),
];

class PantallaOnboarding extends StatefulWidget {
  const PantallaOnboarding({super.key});

  @override
  State<PantallaOnboarding> createState() => _PantallaOnboardingState();
}

class _PantallaOnboardingState extends State<PantallaOnboarding> {
  final PageController _controlador = PageController();
  int _indice = 0;

  bool get _esUltima => _indice == _paginas.length - 1;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _terminar() async {
    await OnboardingPrefs.marcarVisto();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PantallaBienvenida()),
    );
  }

  void _siguiente() {
    if (_esUltima) {
      _terminar();
    } else {
      _controlador.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Visibility(
                  visible: !_esUltima,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: TextButton(
                    onPressed: _terminar,
                    child: const Text('Saltar'),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controlador,
                  itemCount: _paginas.length,
                  onPageChanged: (i) => setState(() => _indice = i),
                  itemBuilder: (context, i) => _VistaPagina(pagina: _paginas[i]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _paginas.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _indice ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _indice
                            ? Colores.primario
                            : Colores.primario.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _siguiente,
                child: Text(
                  _esUltima ? 'Comenzar' : 'Siguiente',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VistaPagina extends StatelessWidget {
  final _PaginaOnboarding pagina;
  const _VistaPagina({required this.pagina});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: const BoxDecoration(
            color: Colores.primarioClaro,
            shape: BoxShape.circle,
          ),
          child: Icon(pagina.icono, size: 68, color: Colores.primario),
        ),
        const SizedBox(height: 36),
        Text(
          pagina.titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colores.texto,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          pagina.texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            height: 1.4,
            color: Colores.textoSuave,
          ),
        ),
      ],
    );
  }
}
