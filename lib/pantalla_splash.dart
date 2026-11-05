import 'package:flutter/material.dart';

import 'pantalla_bienvenida.dart';
import 'pantalla_onboarding.dart';
import 'tema.dart';

class PantallaSplash extends StatefulWidget {
  const PantallaSplash({super.key});

  @override
  State<PantallaSplash> createState() => _PantallaSplashState();
}

class _PantallaSplashState extends State<PantallaSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final Animation<double> _opacidad =
      CurvedAnimation(parent: _controlador, curve: Curves.easeIn);

  late final Animation<double> _escala = Tween<double>(begin: 0.7, end: 1.0)
      .animate(CurvedAnimation(parent: _controlador, curve: Curves.easeOutBack));

  @override
  void initState() {
    super.initState();
    _continuar();
  }

  Future<void> _continuar() async {
    final visto = await OnboardingPrefs.fueVisto();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            visto ? const PantallaBienvenida() : const PantallaOnboarding(),
      ),
    );
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4B45A8), Colores.primario],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _opacidad,
            child: ScaleTransition(
              scale: _escala,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/Logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'GameNight',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colores.acento,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
