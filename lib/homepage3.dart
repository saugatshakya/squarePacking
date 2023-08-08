import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Test3 extends StatefulWidget {
  const Test3({super.key});

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  final List<ChartData> chartData = [];
  bool loading = false;
  int num = 1;

  Future calculate() async {
    chartData.clear();
    int i = 1;
    chartData.add(ChartData(i, num));
    while (num != 1) {
      i++;
      if (num % 2 == 0) {
        num = (num / 2).truncate();
      } else {
        num = num * 3 + 1;
      }
      ChartData newchartData = ChartData(i, num);
      chartData.add(newchartData);
      await Future.delayed(const Duration(milliseconds: 1));
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: SizedBox(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: width * 0.8,
                                height: 32,
                                child: TextField(
                                  onChanged: (val) {
                                    setState(() {
                                      num = int.parse(val);
                                    });
                                  },
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder()),
                                )),
                            GestureDetector(
                              onTap: () async {
                                if (!loading) {
                                  setState(() {
                                    loading = true;
                                  });
                                  await calculate();
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                color: Colors.black,
                                child: Center(
                                  child: loading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            )
                          ]),
                      SizedBox(
                          width: width * 0.8,
                          height: 500,
                          child: SfCartesianChart(
                              margin: const EdgeInsets.all(8),
                              series: <ChartSeries>[
                                // Renders line chart
                                LineSeries<ChartData, int>(
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y)
                              ]))
                    ]),
              ))),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final int y;
}
