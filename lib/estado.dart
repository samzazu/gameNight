import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda favoritos y juegos pendientes en el dispositivo.
class MisJuegos extends ChangeNotifier {
  static const _claveFavoritos = 'favoritos';
  static const _clavePendientes = 'pendientes';

  final Set<String> _favoritos = {};
  final Set<String> _pendientes = {};

  Set<String> get favoritos => Set.unmodifiable(_favoritos);
  Set<String> get pendientes => Set.unmodifiable(_pendientes);

  bool esFavorito(String id) => _favoritos.contains(id);
  bool esPendiente(String id) => _pendientes.contains(id);

  Future<void> cargar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _favoritos
        ..clear()
        ..addAll(prefs.getStringList(_claveFavoritos) ?? []);
      _pendientes
        ..clear()
        ..addAll(prefs.getStringList(_clavePendientes) ?? []);
    } catch (_) {
      // Si falla la lectura se inicia con listas vacías.
    }
    notifyListeners();
  }

  Future<void> alternarFavorito(String id) async {
    if (!_favoritos.remove(id)) _favoritos.add(id);
    notifyListeners();
    await _guardar(_claveFavoritos, _favoritos);
  }

  Future<void> alternarPendiente(String id) async {
    if (!_pendientes.remove(id)) _pendientes.add(id);
    notifyListeners();
    await _guardar(_clavePendientes, _pendientes);
  }

  Future<void> _guardar(String clave, Set<String> valores) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(clave, valores.toList());
    } catch (_) {}
  }
}

/// Instancia única compartida por toda la app.
final MisJuegos misJuegos = MisJuegos();
