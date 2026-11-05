import 'package:flutter/material.dart';

import 'estado.dart';
import 'pantalla_splash.dart'; 
import 'tema.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await misJuegos.cargar();
  runApp(const GameNightApp());
}

class GameNightApp extends StatelessWidget {
  const GameNightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameNight',
      debugShowCheckedModeBanner: false,
      theme: construirTema(),
      home: const PantallaSplash(), 
    );
  }
}
