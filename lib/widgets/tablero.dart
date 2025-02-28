
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nivel:${widget.nivel?.name }"),),
      body: Column(
        children: [
        //Headbar(),
      Parrilla(widget.nivel) ,
      ],
      ),
    );
  }

}




