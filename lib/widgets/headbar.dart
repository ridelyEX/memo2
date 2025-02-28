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
  bool? par = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
