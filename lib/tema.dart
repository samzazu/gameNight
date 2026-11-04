import 'package:flutter/material.dart';

class Colores {
  static const primario = Color(0xFF2D2A6E);
  static const primarioClaro = Color(0xFFECEBFA);
  static const acento = Color(0xFFFFB547);
  static const favorito = Color(0xFFFF5A5F);
  static const pendiente = Color(0xFF6C63FF);
  static const texto = Color(0xFF1D1D2B);
  static const textoSuave = Color(0xFF6E6E80);
  static const fondo = Color(0xFFF7F7FB);
  static const facil = Color(0xFF2EAD6B);
  static const media = Color(0xFFF2A33A);
  static const dificil = Color(0xFFE5484D);

  static Color dificultad(int nivel) =>
      nivel == 1 ? facil : (nivel == 2 ? media : dificil);
}

ThemeData construirTema() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colores.primario,
      primary: Colores.primario,
      secondary: Colores.acento,
    ),
    scaffoldBackgroundColor: Colores.fondo,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colores.fondo,
      foregroundColor: Colores.texto,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Colores.texto,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x14000000)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}

IconData iconoCategoria(String categoria) {
  switch (categoria) {
    case 'Estrategia':
      return Icons.psychology_outlined;
    case 'Familiar':
      return Icons.family_restroom_outlined;
    case 'Party':
      return Icons.celebration_outlined;
    case 'Cartas':
      return Icons.style_outlined;
    case 'Cooperativo':
      return Icons.handshake_outlined;
    case 'Habilidad':
      return Icons.back_hand_outlined;
    default:
      return Icons.casino_outlined;
  }
}
