import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:hive/hive.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_support/bloc/compass_bloc/compass_bloc.dart';
import 'package:path_support/bloc/guide/guide_cubit.dart';
import 'package:path_support/bloc/qr_pair/qr_pair_cubit.dart';
import 'package:path_support/constants/messages.dart';
import 'package:path_support/models/graph_link.dart';
import 'package:path_support/models/building.dart';
import 'package:path_support/models/relatively_positioned_message.dart';
import 'package:path_support/models/node.dart';
import 'package:path_support/models/my_barcode.dart';
import 'package:path_support/view/description_page.dart';
import 'package:path_support/view/destination_selection_page.dart';
import 'package:path_support/view/mode_selection.dart';
import 'package:path_support/view/navigation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MyBarcode? prevBarcode;
  @override
  void initState() {
    super.initState();
    Box<dynamic> box = Hive.box('buildings');
    Building building = Building(
        name: "PSL",
        graph: fillGraph(),
        fullName: "Silesian University of Technology");
    box.put(building.name, building);
    // box.delete(building.name);
    FlutterCompass.events?.listen((event) {
      context.read<CompassBloc>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrPairCubit, QrPairState>(
      listener: (context, state) {
        if (state is QrPairActive) {
          GuideState guideState = context.read<GuideCubit>().state;

          if (state.barcode!.buildingName == guideState.building?.name) {
            if (guideState is GuideDescriptionMode) {
              if (guideState.currentLocation!.name ==
                  guideState.building!.graph[state.qrCode!.pairIndex].name) {
                return;
              }
              context.read<GuideCubit>().descriptionMode(
                    currentLocation:
                        guideState.building!.graph[state.qrCode!.pairIndex],
                    currentRotation: state.qrAngle,
                    compassSnapshot: context.read<CompassBloc>().state,
                  );
              return;
            }
            if (guideState is GuideNavigationMode) {
              if (state.qrCode!.pairIndex == guideState.target) {
                context.read<GuideCubit>().targetReached(
                    currentLocation:
                        guideState.building!.graph[state.qrCode!.pairIndex],
                    currentRotation: state.qrAngle,
                    compassSnapshot: context.read<CompassBloc>().state);
                return;
              }
              context.read<GuideCubit>().nextStep(
                  state.qrCode!.pairIndex, context.read<CompassBloc>().state);
              return;
            }

            return;
          }

          Box<dynamic> box = Hive.box("buildings");
          Building building = box.get(state.barcode!.buildingName)!;

          if (!building.graph.asMap().containsKey(state.qrCode!.pairIndex)) {
            throw Exception("Pair index not found");
          }
          context.read<GuideCubit>().newBuildingChoosed(
                building,
                building.graph[state.qrCode!.pairIndex],
                state.qrAngle,
                context.read<CompassBloc>().state,
              );
        }
      },
      child: BlocBuilder<GuideCubit, GuideState>(
        builder: (context, state) {
          //initial
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Stack(
                children: [
                  MobileScanner(
                    allowDuplicates: false,
                    onDetect: (barcode, args) async {
                      if (barcode.rawValue == null) {
                      } else {
                        context.read<QrPairCubit>().updatePair(barcode);
                      }
                    },
                  ),
                  Builder(
                    builder: (context) {
                      if (state is GuideInitial) {
                        return BlocBuilder<CompassBloc, double?>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                const SizedBox(height: 100),
                                Center(
                                  child: Container(
                                    color: Colors.white,
                                    child: const Text(
                                        "start by scannning a qr code that should be located on the ground, in front of doors, stairs or elevators"),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      if (state is GuideModeSelection) {
                        return const ModeSelectionView();
                      }
                      if (state is GuideDestinationSelection) {
                        return const DestinationSelectionPage();
                      }
                      if (state is GuideDescriptionMode) {
                        return const Center(
                          child: DescriptionPage(
                            targetReached: false,
                          ),
                        );
                      }
                      if (state is GuideNavigationMode) {
                        return const Center(
                          child: NavigationPage(),
                        );
                      }
                      if (state is GuideTargetReached) {
                        return const Center(
                          child: DescriptionPage(
                            targetReached: false,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

//////////////////////////////////////////////////////////////////////
  List<Node> fillGraph() {
    List<Node> graph = [];
    graph.addAll(
      [
        Node(
          name: "kitchen",
          tempParent: -1,
          index: 0,
          links: [
            GraphLink(
                index: 6,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 8 meters through the whole house",
                    position: RelativePosition.S,
                  ),
                ],
                distance: 8),
          ],
          descriptions: [
            RelativelyPositionedMessage(
              message: "green room !-!-!",
              position: RelativePosition.E,
            ),
            RelativelyPositionedMessage(
              message: "table !-!-!",
              position: RelativePosition.W,
            ),
            RelativelyPositionedMessage(
              message: "fridge !-!-!",
              position: RelativePosition.NW,
            ),
            RelativelyPositionedMessage(
              message: "corridor !-!-!",
              position: RelativePosition.S,
            ),
          ],
          tempDistance: double.infinity,
        ),
        Node(
          name: "corridor end",
          tempParent: -1,
          index: 1,
          links: [
            GraphLink(
                index: 2,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 3 meters",
                    position: RelativePosition.S,
                  ),
                ],
                distance: 3),
          ],
          descriptions: [
            RelativelyPositionedMessage(
              message: "elevator !-!-!",
              position: RelativePosition.N,
            ),
            RelativelyPositionedMessage(
              message: "corridor !-!-!",
              position: RelativePosition.S,
            ),
          ],
          tempDistance: double.infinity,
        ),
        Node(
          name: "middle of the corridor",
          tempParent: -1,
          index: 2,
          links: [
            GraphLink(
                index: 1,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 3 meters",
                    position: RelativePosition.N,
                  ),
                ],
                distance: 3),
            GraphLink(
                index: 3,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 2 meters",
                    position: RelativePosition.E,
                  ),
                ],
                distance: 2),
            GraphLink(
                index: 4,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 4 meters",
                    position: RelativePosition.S,
                  ),
                ],
                distance: 4),
          ],
          descriptions: [
            RelativelyPositionedMessage(
              message: "elevator !-!-!",
              position: RelativePosition.N,
            ),
            RelativelyPositionedMessage(
              message: "maicek's room !-!-!",
              position: RelativePosition.E,
            ),
            RelativelyPositionedMessage(
              message: "red toilet !-!-!",
              position: RelativePosition.SW,
            ),
            RelativelyPositionedMessage(
              message: "bathroom !-!-!",
              position: RelativePosition.SW,
            ),
          ],
          tempDistance: double.infinity,
        ),
        Node(
          name: "Maciek's room",
          tempParent: -1,
          index: 3,
          links: [
            GraphLink(
                index: 2,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 2 meters",
                    position: RelativePosition.W,
                  ),
                ],
                distance: 2),
          ],
          descriptions: [
            RelativelyPositionedMessage(
              message: "chair !-!-!",
              position: RelativePosition.E,
            ),
            RelativelyPositionedMessage(
              message: "bed !-!-!",
              position: RelativePosition.SE,
            ),
            RelativelyPositionedMessage(
              message: "window !-!-!",
              position: RelativePosition.NE,
            ),
            RelativelyPositionedMessage(
              message: "corridor !-!-!",
              position: RelativePosition.W,
            ),
          ],
          tempDistance: double.infinity,
        ),
        Node(
          name: "start of the corridor upstairs",
          tempParent: -1,
          index: 4,
          links: [
            GraphLink(
                index: 5,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 3 meters downstairs",
                    position: RelativePosition.W,
                  ),
                  RelativelyPositionedMessage(
                    message: "Then you should !-!-! and go 1 meter down",
                    position: RelativePosition.S,
                  ),
                ],
                distance: 4),
            GraphLink(
                index: 2,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 3 meters ",
                    position: RelativePosition.N,
                  ),
                ],
                distance: 4),
          ],
          descriptions: [
            RelativelyPositionedMessage(
              message: "stairs !-!-!",
              position: RelativePosition.W,
            ),
          ],
          tempDistance: double.infinity,
        ),
        Node(
          name: "entrance",
          tempParent: -1,
          index: 5,
          links: [
            GraphLink(
                index: 4,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 1 meters upstairs",
                    position: RelativePosition.N,
                  ),
                  RelativelyPositionedMessage(
                    message: "Then you should turn !-!-! and go 3 meters up",
                    position: RelativePosition.S,
                  ),
                ],
                distance: 4),
            GraphLink(
                index: 6,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 2 meters ",
                    position: RelativePosition.E,
                  ),
                ],
                distance: 2),
          ],
          descriptions: [
            RelativelyPositionedMessage(
              message: "doors !-!-!",
              position: RelativePosition.W,
            ),
            RelativelyPositionedMessage(
              message: "stairs !-!-!",
              position: RelativePosition.N,
            ),
          ],
          tempDistance: double.infinity,
        ),
        Node(
          name: "christmas tree",
          tempParent: -1,
          index: 6,
          links: [
            GraphLink(
                index: 5,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 3 meters ",
                    position: RelativePosition.W,
                  ),
                ],
                distance: 3),
            GraphLink(
                index: 0,
                pathDescriptions: [
                  RelativelyPositionedMessage(
                    message: "Go !-!-! 8 meters through the house",
                    position: RelativePosition.N,
                  ),
                ],
                distance: 8),
          ],
          descriptions: [
            RelativelyPositionedMessage(
              message: "christmas tree !-!-!",
              position: RelativePosition.S,
            ),
            RelativelyPositionedMessage(
              message: "rest of the house !-!-!",
              position: RelativePosition.N,
            ),
            RelativelyPositionedMessage(
              message: "couch !-!-!",
              position: RelativePosition.E,
            ),
          ],
          tempDistance: double.infinity,
        ),
      ],
    );

    return graph;
  }
}
// graph.add(Node(
//         name: "Node $i",
//         index: i,
//         tempParent: -1,
//         adjNodes: [],
//         tempDistance: double.infinity,
//         description: [
//           MessageToRead(
//             message: "Bass is !-!-!",
//             position: RelativePosition.W,
//           )
//         ],
//       ));
//     }
//     graph[0].adjNodes.add(AdjNode(index: 1, distance: 4, pathDescriptions: [
//           MessageToRead(
//             message: "Go !-!-! 4 meters",
//             position: RelativePosition.NE,
//           ),
//         ]));
//     graph[0].adjNodes.add(AdjNode(
//         index: 7,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go !-!-! 8 meters",
//             position: RelativePosition.SE,
//           )
//         ],
//         distance: 8));
//     graph[1].adjNodes.add(AdjNode(
//         index: 2,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 8 meters !-!-! ",
//             position: RelativePosition.N,
//           )
//         ],
//         distance: 8));
//     graph[1].adjNodes.add(AdjNode(
//         index: 7,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 11 meters !-!-!",
//             position: RelativePosition.E,
//           )
//         ],
//         distance: 11));
//     graph[1].adjNodes.add(AdjNode(
//         index: 0,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 4 meters !-!-!",
//             position: RelativePosition.SE,
//           )
//         ],
//         distance: 7));
//     graph[2].adjNodes.add(AdjNode(
//         index: 1,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 8 meters !-!-!",
//             position: RelativePosition.N,
//           )
//         ],
//         distance: 8));
//     graph[2].adjNodes.add(AdjNode(
//         index: 3,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 7 meters !-!-!",
//             position: RelativePosition.S,
//           )
//         ],
//         distance: 7));
//     graph[2].adjNodes.add(AdjNode(
//         index: 8,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 2 meters !-!-!",
//             position: RelativePosition.W,
//           )
//         ],
//         distance: 2));
//     graph[2].adjNodes.add(AdjNode(
//         index: 5,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 4 meters !-!-!",
//             position: RelativePosition.SW,
//           )
//         ],
//         distance: 4));
//     graph[3].adjNodes.add(AdjNode(
//         index: 2,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 7 meters !-!-!",
//             position: RelativePosition.W,
//           )
//         ],
//         distance: 7));
//     graph[3].adjNodes.add(AdjNode(
//         index: 4,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 9 meters !-!-!",
//             position: RelativePosition.SE,
//           )
//         ],
//         distance: 9));
//     graph[3].adjNodes.add(AdjNode(
//         index: 5,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 14 meters !-!-!",
//             position: RelativePosition.S,
//           )
//         ],
//         distance: 14));
//     graph[4].adjNodes.add(AdjNode(
//         index: 3,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 9 meters !-!-!",
//             position: RelativePosition.NW,
//           )
//         ],
//         distance: 9));
//     graph[4].adjNodes.add(AdjNode(
//         index: 5,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 10 meters !-!-!",
//             position: RelativePosition.SW,
//           )
//         ],
//         distance: 10));
//     graph[5].adjNodes.add(AdjNode(
//         index: 4,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 10 meters!-!-!",
//             position: RelativePosition.NE,
//           )
//         ],
//         distance: 10));
//     graph[5].adjNodes.add(AdjNode(
//         index: 6,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 2 meters !-!-!",
//             position: RelativePosition.E,
//           )
//         ],
//         distance: 2));
//     graph[6].adjNodes.add(AdjNode(
//         index: 5,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 2 meters !-!-!",
//             position: RelativePosition.S,
//           )
//         ],
//         distance: 2));
//     graph[6].adjNodes.add(AdjNode(
//         index: 7,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 1 meter !-!-!",
//             position: RelativePosition.N,
//           )
//         ],
//         distance: 1));
//     graph[6].adjNodes.add(AdjNode(
//         index: 8,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 6 meters !-!-!",
//             position: RelativePosition.E,
//           )
//         ],
//         distance: 6));
//     graph[7].adjNodes.add(AdjNode(
//         index: 0,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 8 meters !-!-!",
//             position: RelativePosition.NW,
//           )
//         ],
//         distance: 8));
//     graph[7].adjNodes.add(AdjNode(
//         index: 1,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 11 meters !-!-!",
//             position: RelativePosition.N,
//           )
//         ],
//         distance: 11));
//     graph[7].adjNodes.add(AdjNode(
//         index: 6,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 1 meter !-!-!",
//             position: RelativePosition.W,
//           )
//         ],
//         distance: 1));
//     graph[7].adjNodes.add(AdjNode(
//         index: 8,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 7 meters !-!-!",
//             position: RelativePosition.NE,
//           )
//         ],
//         distance: 7));
//     graph[8].adjNodes.add(AdjNode(
//         index: 2,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 2 meters !-!-!",
//             position: RelativePosition.W,
//           )
//         ],
//         distance: 2));
//     graph[8].adjNodes.add(AdjNode(
//         index: 6,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 6 meters  !-!-!",
//             position: RelativePosition.E,
//           )
//         ],
//         distance: 6));
//     graph[8].adjNodes.add(AdjNode(
//         index: 7,
//         pathDescriptions: [
//           MessageToRead(
//             message: "Go 7 meters !-!-!",
//             position: RelativePosition.SE,
//           )
//         ],
//         distance: 7));