import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Test2 extends StatefulWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  Map train = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          for (int i = 0; i < stations.length; i++)
            Positioned(
              top: MediaQuery.of(context).size.height * stations[i].location,
              child: Container(
                height: 32,
                width: MediaQuery.of(context).size.width,
                color: Colors.blue,
              ),
            )
        ],
      ),
    );
  }
}

List<Station> stations = [
  Station(location: 0.2, name: "A"),
  Station(location: 0.4, name: "B"),
  Station(location: 0.6, name: "C"),
  Station(location: 0.8, name: "D"),
  Station(location: 0.98, name: "E")
];

class Station {
  final double location;
  final String name;
  Station({required this.location, required this.name});
  late Timer timer;
  List<Passanger> passengers = [];
  start() {
    Timer.periodic(const Duration(seconds: 5), (timers) {
      int noOfPassengers = Random().nextInt(10);
      // List<Station> otherStation = stations.
      for (int i = 0; i < noOfPassengers; i++) {
        passengers.add(Passanger(
            destination: stations[Random().nextInt(stations.length)]));
      }
    });
  }
}

class Train {
  final String name;
  final Station startStation;
  final Station endStation;
  Train(
      {required this.name,
      required this.startStation,
      required this.endStation});
  move() {}
}

class Passanger {
  final Station destination;
  Passanger({required this.destination});

  boardTrain() {}
  leaveTrain() {}
}
