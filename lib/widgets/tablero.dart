import 'package:flutter/material.dart';
import 'package:memo/config/config.dart';
import 'package:memo/widgets/parrilla.dart';
import 'package:memo/widgets/headbar.dart';

class Tablero extends StatefulWidget {
  final Nivel? nivel;

  const Tablero(this.nivel, {super.key});

  @override
  _TableroState createState() => _TableroState();
}

class _TableroState extends State<Tablero> {

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }
  @override
  void dispose() {
    // Libera el ScrollController cuando el widget sea eliminado
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nivel:${widget.nivel?.name}"),
      ),
      body: Row(
        children: [
          Expanded(
              child: SingleChildScrollView(
            controller: _scrollController,
            child: Parrilla(widget.nivel),
          )
              //Headbar(),
              ),
        ],
      ),
    );
  }
}
