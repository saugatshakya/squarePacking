import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

extension LoopList<T> on List {
  T loop(int index) => this[index % length];
}

class Spinner extends StatefulWidget {
  const Spinner({Key? key}) : super(key: key);

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> {
  final _controller = CarouselController();
  int claimed = -1;
  final ConfettiController _controllerCenter =
      ConfettiController(duration: const Duration(seconds: 2));
  bool spinning = false;
  List _rewards = [
    {
      "reward_name": "a",
      "description": "This is a a reward",
      "quantity": 20,
      "winners": 10,
      "id": 1
    },
    {
      "reward_name": "b",
      "description": "This is a b reward",
      "quantity": 20,
      "winners": 10,
      "id": 2
    },
    {
      "reward_name": "c",
      "description": "This is a c reward",
      "quantity": 20,
      "winners": 10,
      "id": 3
    },
    {
      "reward_name": "d",
      "description": "This is a d reward",
      "quantity": 20,
      "winners": 10,
      "id": 4
    },
    {
      "reward_name": "e",
      "description": "This is a e reward",
      "quantity": 20,
      "winners": 10,
      "id": 5
    },
    {
      "reward_name": "f",
      "description": "This is a f reward",
      "quantity": 20,
      "winners": 10,
      "id": 6
    },
    {
      "reward_name": "g",
      "description": "This is a g reward",
      "quantity": 20,
      "winners": 10,
      "id": 7
    },
  ];
  int currentReward = 0;

  @override
  void initState() {
    // spinElements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xffFBD30F),
        body: SafeArea(
            child: Stack(children: [
          _rewards.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(children: [
                  const SizedBox(height: 52),
                  Text(
                    claimed == -1 ? "Spin The Wheel" : "Congratulations",
                    // _rewards.toString(),
                    style: TextStyle(
                      color: const Color(0xff454545),
                      fontSize: claimed == -1 ? 24 : 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  claimed == -1
                      ? const Text(
                          "and get exciting offers",
                          style: TextStyle(
                            color: Color(0xff454545),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        width: Get.width * 0.7,
                        child: const Text(
                          "Only available for students, you need to verify with a valid student ID at the GO TAXI office to claim your prize voucher. ",
                          style: TextStyle(
                            color: Color(0xff454545),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.54,
                    child: Stack(children: [
                      SizedBox(
                          height: Get.height * 0.54,
                          child: CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.scale,
                                enableInfiniteScroll:
                                    claimed == -1 || spinning ? true : false,
                                onPageChanged: (page, xyz) {
                                  setState(() {
                                    currentReward = page;
                                  });
                                },
                                pageSnapping: true,
                                scrollDirection: Axis.vertical,
                                viewportFraction:
                                    claimed == -1 || spinning ? 0.32 : 3),
                            items: [
                              for (int i = 0; i < _rewards.length; i++)
                                Center(
                                  child: SpinnerChild(
                                      i: i,
                                      currentReward: currentReward,
                                      reward: _rewards[i],
                                      claimed: !(claimed == -1) && !spinning),
                                )
                            ],
                          )),
                      Positioned(
                          top: Get.height * 0.24,
                          left: Get.width * 0.10,
                          child: spinning || claimed != -1
                              ? const SizedBox()
                              : SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: Icon(Icons.pin_drop)))
                    ]),
                  ),
                  const SizedBox(
                    height: 54,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (claimed == -1) {
                        if (!spinning) {
                          setState(() {
                            spinning = true;
                          });
                          List choosePopulation = [];
                          for (int i = 0; i < _rewards.length; i++) {
                            int temp = _rewards[i]["quantity"] -
                                _rewards[i]["winners"];
                            for (int j = 0; j < temp; j++) {
                              choosePopulation.add(_rewards[i]["id"]);
                            }
                          }
                          int winnerIndex =
                              Random().nextInt(choosePopulation.length);
                          int winnerId = choosePopulation[winnerIndex];
                          int page = 0;
                          for (int i = 0; i < _rewards.length; i++) {
                            if (_rewards[i]["id"] == winnerId) {
                              page = i;
                            }
                          }
                          claimed = 0;
                          if (claimed == 2) {
                            Navigator.pop(context);
                          }
                          while (claimed == 1) {
                            winnerIndex =
                                Random().nextInt(choosePopulation.length);
                            winnerId = choosePopulation[winnerIndex];
                            page = 0;
                            for (int i = 0; i < _rewards.length; i++) {
                              if (_rewards[i]["id"] == winnerId) {
                                page = i;
                              }
                            }
                            // claimed = await Spin().claimElement(winnerId);
                            if (claimed == 2) {
                              Navigator.pop(context);
                            }
                          }
                          if (claimed == 0) {
                            while (currentReward != page) {
                              await _controller.nextPage(
                                  duration: const Duration(milliseconds: 80),
                                  curve: Curves.easeIn);
                            }
                            int i = (currentReward - 1) == -1
                                ? currentReward + 1
                                : currentReward - 1;
                            while (currentReward != i) {
                              await _controller.nextPage(
                                  duration: const Duration(milliseconds: 90),
                                  curve: Curves.easeIn);
                            }
                            i = (currentReward - 1) == -1
                                ? currentReward + 1
                                : currentReward - 1;
                            while (currentReward != i) {
                              await _controller.nextPage(
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.easeIn);
                            }
                            while (currentReward != page) {
                              await _controller.nextPage(
                                  duration: Duration(
                                      milliseconds: 100 *
                                          (_rewards.length -
                                              (currentReward - page).abs())),
                                  curve: Curves.decelerate);
                            }
                            List temp = [];
                            temp.add(_rewards[currentReward]);
                            _rewards = temp;
                            setState(() {});
                            _controllerCenter.play();
                          }
                          await Future.delayed(const Duration(seconds: 2));
                          setState(() {
                            spinning = false;
                          });
                        } else {
                          Get.showSnackbar(const GetSnackBar(
                            message: "Please wait while we find you a reward",
                            duration: Duration(seconds: 1),
                          ));
                        }
                      } else {
                        Get.back();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 296,
                      height: 40,
                      decoration: claimed == -1
                          ? BoxDecoration(
                              color: const Color(0xff69cd9d),
                              borderRadius: BorderRadius.circular(4))
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border:
                                  Border.all(color: const Color(0xff454545))),
                      child: Center(
                          child: Text(
                        claimed == -1 ? "Spin" : "Continue to Home",
                        style: claimed == -1
                            ? const TextStyle(color: Colors.white)
                            : const TextStyle(color: Color(0xff454545)),
                      )),
                    ),
                  )
                ]),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              // maximumSize: Size(
              //   Get.height,
              //   Get.width,
              // ),
              gravity: 0.1,
              numberOfParticles: 100,

              // particleDrag: 1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          )
        ])),
      ),
    );
  }
}

class SpinnerChild extends StatelessWidget {
  const SpinnerChild(
      {Key? key,
      required this.i,
      required this.currentReward,
      required this.reward,
      required this.claimed})
      : super(key: key);

  final int i;
  final int currentReward;
  final Map reward;
  final bool claimed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: i == currentReward
          ? 278
          : claimed
              ? Get.width * 0.8
              : 226,
      height: i == currentReward
          ? 124
          : claimed
              ? 213
              : 109,
      padding: const EdgeInsets.all(16),
      // margin: const EdgeInsets.all(10),

      decoration: claimed
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                  image: AssetImage("assets/images/Subtract.png"),
                  fit: BoxFit.cover))
          : BoxDecoration(
              color:
                  i == currentReward ? Colors.white : const Color(0xffededed),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xff696F8C), width: 2),
              boxShadow: [
                  BoxShadow(
                      offset: i == currentReward
                          ? const Offset(0, 12)
                          : const Offset(0, 4),
                      blurRadius: i == currentReward ? 12 : 8,
                      color: const Color(0xff786306).withOpacity(0.36))
                ]),
      child: Column(children: [
        SizedBox(
          height: claimed || i == currentReward ? 80 : 73,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Column(
                crossAxisAlignment: claimed
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Text(
                    " ${reward["reward_name"]}",
                    style: TextStyle(
                        color: claimed ? Colors.white : Colors.black,
                        fontSize: i == currentReward ? 32 : 24,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: i == currentReward ? 157 : 134,
                    child: Padding(
                      padding: claimed
                          ? const EdgeInsets.only(left: 8.0)
                          : const EdgeInsets.only(left: 0),
                      child: Text(
                        "${reward["description"]}",
                        textAlign: claimed ? TextAlign.left : TextAlign.center,
                        style: TextStyle(
                            fontSize: i == currentReward ? 14 : 12,
                            fontWeight: FontWeight.w500,
                            color: claimed ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  claimed
                      ? Padding(
                          padding: claimed
                              ? const EdgeInsets.only(left: 8.0)
                              : const EdgeInsets.only(left: 0),
                          child: const Text(
                            "Claim within 2weeks",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : const SizedBox()
                ]),
          ]),
        )
      ]),
    );
  }
}
