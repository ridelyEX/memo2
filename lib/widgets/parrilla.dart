import 'dart:async';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import 'package:flip_card/flip_card.dart';

class Parrilla extends StatefulWidget {
  final Nivel? nivel;

  const Parrilla(this.nivel, {super.key});

  @override
  _ParrillaState createState() => _ParrillaState();
}

class _ParrillaState extends State<Parrilla> {
  int? prevClicked;
  bool flag = false;
  bool habilitado = false;

  @override
  void initState() {
    super.initState();
    controles = [];
    baraja = [];
    estados = [];
    barajar(widget.nivel!);
    prevClicked = -1;
    flag = false;
    habilitado = false;

    // Después de 3 segundos, mostrar todas las cartas y habilitar el juego
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        for (int i = 0; i < baraja.length; i++) {
          controles[i].toggleCard(); // Voltear todas las cartas
        }
        habilitado = true; // Habilitar el juego
      });
    });
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
            if (!habilitado) return; // Si el juego no está habilitado, no hacer nada

            if (!flag) {
              // Primer clic en una carta
              prevClicked = index;
              estados[index] = false; // Deshabilitar la carta clickeada
              flag = true;
            } else {
              // Segundo clic en una carta
              if (prevClicked != index) {
                setState(() {
                  habilitado = false; // Deshabilitar el juego temporalmente
                });

                if (baraja[index] == baraja[prevClicked!]) {
                  // Si las cartas son iguales
                  debugPrint("Son iguales");
                  setState(() {
                    estados[index] = false;
                    estados[prevClicked!] = false;
                    habilitado = true; // Habilitar el juego nuevamente
                  });
                } else {
                  // Si las cartas no son iguales, voltearlas de nuevo después de 1 segundo
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      controles[prevClicked!].toggleCard();
                      controles[index].toggleCard();
                      estados[prevClicked!] = true;
                      estados[index] = true;
                      habilitado = true; // Habilitar el juego nuevamente
                    });
                  });
                }
                flag = false; // Reiniciar el estado de "flag"
              }
            }
          },
          fill: Fill.fillBack,
          controller: controles[index],
          flipOnTouch: habilitado ? estados[index] : false,
          back: Image.asset("images/quest.png"),
          front: Image.asset(baraja[index]),
        );
      },
    );
  }
}