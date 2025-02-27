import 'dart:async';

import 'package:flutter/material.dart';
import '../config/config.dart';
import 'package:flip_card/flip_card.dart';

class Parrilla extends StatefulWidget {
  final Nivel? nivel;

  const Parrilla(this.nivel, {super.key});

  @override
  _ParrillaState createState() => _ParrillaState();
}

class _ParrillaState extends State<Parrilla>  {
  int? prevclicked;
  bool? flag, habilitado;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controles = [];
    baraja = [];
    estados = [];
    barajar(widget.nivel!);
    prevclicked = -1;
    flag = false;
    habilitado = true;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: baraja.length,
      shrinkWrap: true,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return FlipCard(
            onFlip: () {
              if (!flag!) {
                prevclicked = index;
                estados[index] = false;
              } else {
                setState(() {
                  habilitado = false;
                });
              }
              flag = !flag!;
              estados[index] = false;

              if (prevclicked != index && !flag!) {
                if (baraja.elementAt(index) == baraja.elementAt(prevclicked!)) {
                  debugPrint("clicked:Son iguales");
                  setState(() {
                    habilitado = true;
                  });
                } else {
                  Future.delayed(
                    Duration(seconds: 1),
                    () {
                      controles.elementAt(prevclicked!).toggleCard();
                      estados[prevclicked!] = true;
                      prevclicked = index;
                      controles.elementAt(index).toggleCard();
                      estados[index] = true;
                      setState(() {
                        habilitado = true;
                      });
                    },
                  );
                }
              } else {
                setState(() {
                  habilitado = true;
                });
              }
            },
            fill: Fill.fillBack,
            controller: controles[index],
            // autoFlipDuration: const Duration(milliseconds: 500),
            flipOnTouch: habilitado! ? estados.elementAt(index) : false,
            //side: CardSide.FRONT,
            front: Image.asset("images/quest.png"),
            back: Image.asset(baraja[index]));
      },
    );
  }

}
