import 'dart:async';

import 'package:flutter/material.dart';

import '../config/config.dart';

class Headbar extends StatefulWidget {

  final Nivel? nivel;
  const Headbar(this.nivel, {super.key});

  @override
  _HeadbarState createState() => _HeadbarState();
}



class _HeadbarState extends State<Headbar> {

  int? cont, mov, pares;
  int seg=0,min=0;
  bool? par = false;

  void _contadorTiempo() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seg++;
        if (seg>60) {
          seg=0;
          min++;
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contadorTiempo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tiempo: ${min.toString().padLeft(2, '0')}:${seg.toString().padLeft(2, '0')}",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
