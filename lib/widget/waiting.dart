import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SpinKitFadingCircle(
        color: HexColor('#DBD6D6'),
        size: 40.0,
      ),
    );
  }
}
