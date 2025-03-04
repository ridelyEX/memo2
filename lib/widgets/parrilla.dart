import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:memo/config/config.dart';
import 'package:memo/database/database_helper.dart';
import 'package:memo/dialogs/victory_dialog.dart';

class Parrilla extends StatefulWidget {
  final Nivel nivel;
  final Function(int)? onParesActualizados;
  final Function()? onMovimiento;
  final Function(String)? onTiempoActualizado;

  const Parrilla(
      this.nivel, {
        super.key,
        this.onParesActualizados,
        this.onMovimiento,
        this.onTiempoActualizado,
      });

  @override
  State<Parrilla> createState() => _ParrillaState();
}

class _ParrillaState extends State<Parrilla> {
  late List<FlipCardController> _controles;
  late List<String> _baraja;
  late List<bool> _estados;
  int? _primerIndice;
  Timer? _temporizador;
  int _segundos = 0;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precargarImagenes().then((_) => _inicializarJuego());
    });
  }

  Future<void> _precargarImagenes() async {
    try {
      final List<String> rutasUnicas = [
        "images/cloud.png",
        "images/cloud.png",
        "images/day.png",
        "images/day.png",
        "images/dino.png",
        "images/dino.png",
        "images/fish.png",
        "images/fish.png",
        "images/frog.png",
        "images/frog.png",
        "images/moon.png",
        "images/moon.png",
        "images/night.png",
        "images/night.png",
        "images/octo.png",
        "images/octo.png",
        "images/peacock.png",
        "images/peacock.png",
        "images/rabbit.png",
        "images/rabbit.png",
        "images/rain.png",
        "images/rain.png",
        "images/rainbow.png",
        "images/rainbow.png",
        "images/seahorse.png",
        "images/seahorse.png",
        "images/shark.png",
        "images/shark.png",
        "images/star.png",
        "images/star.png",
        "images/sun.png",
        "images/sun.png",
        "images/whale.png",
        "images/whale.png",
        "images/wolf.png",
        "images/wolf.png",
        "images/zoo.png",
        "images/zoo.png",
        ...cards().sublist(0, _obtenerTamanoBaraja())
      ].toSet().toList();

      await Future.wait(rutasUnicas.map((ruta) =>
          precacheImage(AssetImage(ruta), context)
      ));
    } catch (e) {
      debugPrint("Error al precargar imágenes: $e");
    }
  }
  void _inicializarJuego() {
    if (!mounted) return; // Verificar si el widget está activo

    setState(() {
      final size = _obtenerTamanoBaraja();
      _baraja = cards().sublist(0, size)..shuffle();
      _controles = List.generate(size, (_) => FlipCardController());
      _estados = List.generate(size, (_) => true);
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      for (int i = 0; i < _controles.length; i++) {
        _controles[i].toggleCard(); // Voltear cartas después de 3 segundos
      }
    });
  }

  int _obtenerTamanoBaraja() {
    switch (widget.nivel) {
      case Nivel.facil: return 16;
      case Nivel.medio: return 24;
      case Nivel.dificil: return 32;
      case Nivel.imposible: return 36;
    }
  }

  void _iniciarTemporizador() {
    _temporizador = Timer.periodic(const Duration(seconds: 1), (_) {
      _segundos++;
      widget.onTiempoActualizado?.call(
        "${(_segundos ~/ 60).toString().padLeft(2, '0')}:"
            "${(_segundos % 60).toString().padLeft(2, '0')}",
      );
    });
  }

  void _manejarCarta(int index) {
    if (!_estados[index] || _primerIndice == index) return;
    widget.onMovimiento?.call();
    try {
      _controles[index].toggleCard();

      if (_primerIndice == null) {
        _primerIndice = index;
      } else {
        _estados[index] = _estados[_primerIndice!] = false;
        widget.onParesActualizados?.call(
            _baraja.length ~/ 2 - _estados
                .where((e) => e)
                .length ~/ 2
        );

        if (_baraja[index] != _baraja[_primerIndice!]) {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              _controles[index].toggleCard();
              _controles[_primerIndice!].toggleCard();
              _estados[index] = _estados[_primerIndice!] = true;
            }
          });
        } else {
          if (_verificarVictoria()) {
            _dbHelper.updateStats(true);
            _mostrarVictoria();
          }
        }
        _primerIndice = null;
      }
    } catch(e){
      debugPrint("error al voltear cartas: $e");
    }
  }

  bool _verificarVictoria() {
    return _estados.every((estado) => !estado);
  }

  void _mostrarVictoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => VictoryDialog(
        time: "${(_segundos ~/ 60).toString().padLeft(2, '0')}:"
            "${(_segundos % 60).toString().padLeft(2, '0')}",
        moves: widget.onMovimiento.toString(),
        onRestart: () {
          Navigator.pop(ctx);
          _reiniciarJuego();
        },
      ),
    );
  }

  void _reiniciarJuego() {
    setState(() {
      _segundos = 0;
      _primerIndice = null;
      _inicializarJuego();
    });
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: _baraja.length,
      itemBuilder: (context, index) => FlipCard(
        controller: _controles[index],
        flipOnTouch: _estados[index],
        onFlip: () => _manejarCarta(index),
        front: Image.asset("images/quest.png"),
        back: Image.asset(_baraja[index]),
      ),
    );
  }
}