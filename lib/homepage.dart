import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // double diameter = 16;
  int maxRetries = 1000;
  bool loading = false;
  double maxdiameter = 60;
  double mindiameter = 4;
  List colors = [
    "070709",
    "0a0a0d",
    "0e0e12",
    "eaeaee",
    "e5e5eb",
    "e1e1e7",
    "dcdce3",
    "d8d8e0",
    "d3d3dc",
    "cfcfd9",
    "cacad5",
    "c6c6d1",
    "c1c1ce",
    "bcbcca",
    "b8b8c7",
    "b3b3c3",
    "afafbf",
    "aaaabc",
    "a6a6b8",
    "a1a1b5",
    "9d9db1",
    "9898ad",
    "9494aa",
    "8f8fa6",
    "8a8aa3",
    "86869f",
    "81819b",
    "7d7d98",
    "787894",
    "747490",
    "6f6f8d",
    "6c6c88",
    "686884",
    "65657f",
    "61617a",
    "5d5d76",
    "5a5a71",
    "56566d",
    "525268",
    "4f4f64",
    "4b4b5f",
    "48485b",
    "444456",
    "404051",
    "3d3d4d",
    "393948",
    "363644",
    "32323f",
    "2e2e3b",
    "2b2b36",
    "272732",
    "24242d",
    "202028",
    "1c1c24",
    "19191f",
    "15151b",
    "121216",
    "0e0e12",
    "0a0a0d",
    "070709",
  ];
  clamp(value, leftMin, leftMax, rightMin, rightMax) {
    double leftSpan = (leftMax - leftMin) * 1.0;
    double rightSpan = (rightMax - rightMin) * 1.0;

    double valueScaled = (value - leftMin) / leftSpan;
    int clammped = (rightMin + (valueScaled * rightSpan)).floor();
    // print("clammping $value: to $clammped");
    return clammped;
  }

  validPoint(top, left, diameter) {
    for (int i = 0; i < tops.length; i++) {
      if (((top - diameter / 2) + (diameter + nodes[i]["diameter"]) / 2 >
                  nodes[i]["top"] &&
              nodes[i]["top"] >
                  (top - diameter / 2) -
                      (diameter + nodes[i]["diameter"]) / 2) &&
          ((left - diameter / 2) + (diameter + nodes[i]["diameter"]) / 2 >
                  nodes[i]["left"] &&
              nodes[i]["left"] >
                  (left - diameter / 2) -
                      (diameter + nodes[i]["diameter"]) / 2)) {
        // print(
        //     "invalid point found on checking $top,$left compared to ${tops[i]},${lefts[i]}");
        return false;
      }
    }
    return true;
  }

  createNode() async {
    setState(() {
      loading = true;
    });
    int retries = 0;
    while (retries < maxRetries) {
      int top =
          Random().nextInt(MediaQuery.of(context).size.height.truncate() - 32) +
              16;
      int left =
          Random().nextInt(MediaQuery.of(context).size.width.truncate() - 32) +
              16;
      // double diameter = (Random().nextInt(32 - 8) + 8) * 1.0;
      if (tops.isNotEmpty) {
        while (!validPoint(top, left, maxdiameter)) {
          retries++;
          if (retries >= maxRetries) {
            if (maxdiameter > mindiameter) {
              maxdiameter = maxdiameter - 1;
              retries = 0;
            } else {
              setState(() {
                loading = false;
              });
              return;
            }
          }
          top = Random().nextInt(
                  (MediaQuery.of(context).size.height * 0.92 - maxdiameter)
                      .truncate()) +
              maxdiameter.toInt();
          left = Random().nextInt(
                  (MediaQuery.of(context).size.width - maxdiameter)
                      .truncate()) +
              maxdiameter.toInt();
        }
      }

      // Color color = Color.fromRGBO(
      //     clamp(top.truncate(), 0, MediaQuery.of(context).size.height, 0, 255),
      //     clamp(left.truncate(), MediaQuery.of(context).size.width, 0, 0, 255),
      //     clamp(maxdiameter, 4, 32, 0, 255),
      //     1);
      int colorCode =
          int.parse("0xff${colors[colors.length - maxdiameter.toInt()]}");
      nodes.add({
        "top": top - maxdiameter / 2,
        "left": left - maxdiameter / 2,
        "color": Color(colorCode),
        "diameter": maxdiameter,
      });
      retries = 0;
      tops.add(top);
      lefts.add(left);
      // print(
      //     "node${nodes.length} added at $top, $left with color $color and $colorCode");
      setState(() {});
      await Future.delayed(const Duration(microseconds: 10));
    }
    setState(() {
      loading = false;
    });
  }

  List nodes = [];
  List lefts = [];
  List tops = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.92,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                for (int i = 0; i < nodes.length; i++)
                  Positioned(
                    top: (nodes[i]["top"] * 1.0) - nodes[i]["diameter"] / 2,
                    left: (nodes[i]["left"] * 1.0) - nodes[i]["diameter"] / 2,
                    child: Container(
                      width: nodes[i]["diameter"],
                      height: nodes[i]["diameter"],
                      decoration: BoxDecoration(
                        color: nodes[i]["color"],
                      ),
                      // child: Center(
                      //   child: Text(
                      //     (i + 1).toString(),
                      //     style: TextStyle(
                      //         color: nodes[i]["opColor"],
                      //         fontSize: (nodes[i]["diameter"] / 2)),
                      //   ),
                      // ),
                    ),
                  ),
              ],
            ),
          ),
          loading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 32,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                          "finding space for ${nodes.length + 1}th node with diameter $maxdiameter")
                    ],
                  ))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      GestureDetector(
                        onTap: createNode,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          width: 132,
                          height: 32,
                          color: Colors.blue,
                          child: const Center(child: Text("Create Node")),
                        ),
                      ),
                      Text(colors.length.toString()),
                      GestureDetector(
                        onTap: () {
                          nodes = [];
                          lefts = [];
                          tops = [];
                          maxdiameter = 60;
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          width: 132,
                          height: 32,
                          color: Colors.blue,
                          child: Center(
                              child: Text("Total Nodes: ${nodes.length}")),
                        ),
                      )
                    ]),
        ]),
      ),
    );
  }
}
