import 'package:flutter/material.dart';
import 'package:memo/config/config.dart';
import 'package:memo/database/database_helper.dart';
import 'package:memo/dialogs/victory_dialog.dart';
import 'package:memo/widgets/headbar.dart';
import 'package:memo/widgets/parrilla.dart';

class Tablero extends StatefulWidget {
  final Nivel nivel;
  const Tablero(this.nivel, {super.key});

  @override
  State<Tablero> createState() => _TableroState();
}

class _TableroState extends State<Tablero> {
  int _paresEncontrados = 0;
  int _movimientos = 0;
  String _tiempo = "00:00";
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _cargarEstadisticas();
  }

  Future<void> _cargarEstadisticas() async {
    await _dbHelper.database;
  }

  void _reiniciarJuego() {
    setState(() {
      _paresEncontrados = 0;
      _movimientos = 0;
      _tiempo = "00:00";
    });
  }

  void _nuevoJuego() async {
    await _dbHelper.updateStats(false);
    _reiniciarJuego();
  }

  Future<void> _mostrarEstadisticas(BuildContext context) async {
    final stats = await _dbHelper.getStats();
    final history = await _dbHelper.getHistory();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Estadísticas"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Victorias: ${stats['wins']}"),
            Text("Derrotas: ${stats['losses']}"),
            const SizedBox(height: 20),
            const Text("Historial:"),
            ...history.map((entry) =>
                Text("${entry['date']}: ${entry['wins']} pares")
            ).toList(),
          ],
        ),
      ),
    );
  }

  Future<void> _salirJuego(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar salida"),
        content: const Text("¿Deseas guardar el progreso actual?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Guardar y Salir"),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      await _dbHelper.saveGame(DateTime.now().toString(), _paresEncontrados);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nivel: ${widget.nivel.name.toUpperCase()}"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'reiniciar':
                  _reiniciarJuego();
                  break;
                case 'nuevo':
                  _nuevoJuego();
                  break;
                case 'estadisticas':
                  _mostrarEstadisticas(context);
                  break;
                case 'salir':
                  _salirJuego(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'reiniciar',
                child: Text('Reiniciar Juego'),
              ),
              const PopupMenuItem(
                value: 'nuevo',
                child: Text('Juego Nuevo'),
              ),
              const PopupMenuItem(
                value: 'estadisticas',
                child: Text('Ver Estadísticas'),
              ),
              const PopupMenuItem(
                value: 'salir',
                child: Text('Salir del Juego'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Headbar(
            paresEncontrados: _paresEncontrados,
            movimientos: _movimientos,
            tiempo: _tiempo,
          ),
          Expanded(
            child: Parrilla(
              widget.nivel,
              onParesActualizados: (pares) => setState(() => _paresEncontrados = pares),
              onMovimiento: () => setState(() => _movimientos++),
              onTiempoActualizado: (tiempo) => setState(() => _tiempo = tiempo),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reiniciarJuego,
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => _salirJuego(context),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _nuevoJuego,
            ),
          ],
        ),
      ),
    );
  }
}