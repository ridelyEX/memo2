import 'package:flutter/material.dart';

class Headbar extends StatelessWidget {
  final int paresEncontrados;
  final int movimientos;
  final String tiempo;

  const Headbar({
    super.key,
    required this.paresEncontrados,
    required this.movimientos,
    required this.tiempo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
    color: Colors.blueGrey[900],
    boxShadow: const [
    BoxShadow(
    color: Colors.black26,
    blurRadius: 10,
    offset: Offset(0, 3),
    ),
    ],
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    _buildStat(Icons.check, paresEncontrados.toString()),
    _buildStat(Icons.timer, tiempo),
    _buildStat(Icons.touch_app, movimientos.toString()),
    ],
    ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}