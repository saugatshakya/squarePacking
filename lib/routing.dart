import 'package:flutter/material.dart';
import 'package:test/data.dart';
import 'package:test/djakwkaiw.dart';

class RoutingWidget extends StatefulWidget {
  const RoutingWidget({super.key});

  @override
  State<RoutingWidget> createState() => _RoutingWidgetState();
}

class _RoutingWidgetState extends State<RoutingWidget> {
  Map<int, Map<int, double>> graph = {};
  int? start;
  int? end;
  List nodes = [];
  bool loading = false;

  createGraph() {
    setState(() {
      loading = true;
    });
    for (Map<String, dynamic> data in routingData) {
      if (graph[data["source"]] == null) {
        Map<int, Map<int, double>> newNode = {
          data["source"]: {data["target"]: data["cost_length"]}
        };
        graph.addAll(newNode);
        nodes.add(data["source"]);
      } else {
        Map<int, double> existingNode = graph[data["source"]]!;
        Map<int, double> newNode = {data["target"]: data["cost_length"]};
        existingNode.addAll(newNode);
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    createGraph();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          loading
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PopupMenuButton(
                        itemBuilder: (_) {
                          return [
                            for (int i = 0; i < nodes.length; i++)
                              PopupMenuItem(
                                onTap: () {
                                  setState(() {
                                    start = nodes[i];
                                  });
                                },
                                value: nodes[i],
                                child: Text("${nodes[i]}"),
                              )
                          ];
                        },
                        child: Text("${start ?? 'start'}")),
                    PopupMenuButton(
                        itemBuilder: (_) {
                          return [
                            for (int i = 0; i < nodes.length; i++)
                              PopupMenuItem(
                                onTap: () {
                                  setState(() {
                                    end = nodes[i];
                                  });
                                },
                                value: nodes[i],
                                child: Text("${nodes[i]}"),
                              )
                          ];
                        },
                        child: Text("${end ?? 'end'}")),
                  ],
                ),
          SizedBox(
            height: 32,
          ),
          if (start != null && end != null)
            GestureDetector(
              onTap: () async {
                var output2 =
                    await Dijkstra.findPathFromGraph(graph, start, end);
                print(output2);
              },
              child: Container(
                width: 132,
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text("Route"),
                ),
              ),
            )
        ]),
      ),
    );
  }
}
