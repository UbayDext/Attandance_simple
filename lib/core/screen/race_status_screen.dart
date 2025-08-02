
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:flutter/material.dart';


class RaceStatusScreen extends StatefulWidget {
  const RaceStatusScreen({super.key});

  @override
  State<RaceStatusScreen> createState() => _RaceStatusScreenState();
}

class _RaceStatusScreenState extends State<RaceStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
    );
  }
}