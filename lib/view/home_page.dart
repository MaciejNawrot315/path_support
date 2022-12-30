import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_support/bloc/guide/guide_cubit.dart';
import 'package:path_support/bloc/qr_pair/qr_pair_cubit.dart';
import 'package:path_support/constants/messages.dart';
import 'package:path_support/models/adj_node.dart';
import 'package:path_support/models/building.dart';
import 'package:path_support/models/message_to_read.dart';
import 'package:path_support/models/node.dart';
import 'package:path_support/models/qr_code.dart';
import 'package:path_support/view/mode_selection.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GuideCubit, GuideState>(
      listener: (context, state) {
        if (state is BuildingChoosed) {
          "${Messages.buildingRecognized} ${state.building!.fullName}".play();
          Messages.pleaseSelectMode.play();
        }
        if (state is TargetChoosed) {
          if (state.path[state.currentStep! + 1].index == state.target) {
            Messages.almostThere.play();
          }
        }
        if (state is TargetReached) {
          Messages.targetReached.play();
        }
      },
      child: BlocListener<QrPairCubit, QrPairState>(
        listener: (context, state) {
          if (state is QrPairActive) {
            GuideState guideState = context.read<GuideCubit>().state;

            if (state.barcode!.buildingName == guideState.building?.name) {
              if (guideState is GuideDescriptionMode) {
                for (var element in guideState
                    .building!.graph[state.qrCode!.pairIndex].description) {
                  element.message.play();
                }
                return;
              }
              if (guideState is TargetChoosed) {
                if (state.qrCode!.pairIndex == guideState.target) {
                  context.read<GuideCubit>().targetReached();
                }
                return;
              }

              return;
            }

            Box<dynamic> box = Hive.box("buildings");
            Building building = box.get(state.barcode!.buildingName)!;

            if (!building.graph.asMap().containsKey(state.qrCode!.pairIndex)) {
              throw Exception("Pair index not found");
            }
            Messages.codeScanned.play();
            context.read<GuideCubit>().newBuildingChoosed(
                building, building.graph[state.qrCode!.pairIndex]);
          }
        },
        child: BlocBuilder<GuideCubit, GuideState>(
          builder: (context, state) {
            //initial
            return Scaffold(
              body: Stack(
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
                      if (state is BuildingChoosed) {
                        return const ModeSelectionView();
                      }
                      if (state is GuideNavigationMode) {
                        return const SizedBox();
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Node> fillGraph() {
    List<Node> graph = [];
    for (int i = 0; i < 9; i++) {
      graph.add(Node(
        name: "Node $i",
        index: i,
        tempParent: -1,
        adjNodes: [],
        tempDistance: double.infinity,
        description: [
          MessageToRead(
            message: "!-!-!",
            position: RelativePosition.N,
          )
        ],
      ));
    }
    graph[0].adjNodes.add(AdjNode(index: 1, distance: 4, pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ]));
    graph[0].adjNodes.add(AdjNode(
        index: 7,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 8));
    graph[1].adjNodes.add(AdjNode(
        index: 2,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 8));
    graph[1].adjNodes.add(AdjNode(
        index: 7,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 11));
    graph[1].adjNodes.add(AdjNode(
        index: 0,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 7));
    graph[2].adjNodes.add(AdjNode(
        index: 1,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 8));
    graph[2].adjNodes.add(AdjNode(
        index: 3,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 7));
    graph[2].adjNodes.add(AdjNode(
        index: 8,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 2));
    graph[2].adjNodes.add(AdjNode(
        index: 5,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 4));
    graph[3].adjNodes.add(AdjNode(
        index: 2,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 7));
    graph[3].adjNodes.add(AdjNode(
        index: 4,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 9));
    graph[3].adjNodes.add(AdjNode(
        index: 5,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 14));
    graph[4].adjNodes.add(AdjNode(
        index: 3,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 9));
    graph[4].adjNodes.add(AdjNode(
        index: 5,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 10));
    graph[5].adjNodes.add(AdjNode(
        index: 4,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 10));
    graph[5].adjNodes.add(AdjNode(
        index: 6,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 2));
    graph[6].adjNodes.add(AdjNode(
        index: 5,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 2));
    graph[6].adjNodes.add(AdjNode(
        index: 7,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 1));
    graph[6].adjNodes.add(AdjNode(
        index: 8,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 6));
    graph[7].adjNodes.add(AdjNode(
        index: 0,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 8));
    graph[7].adjNodes.add(AdjNode(
        index: 1,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 11));
    graph[7].adjNodes.add(AdjNode(
        index: 6,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 1));
    graph[7].adjNodes.add(AdjNode(
        index: 8,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 7));
    graph[8].adjNodes.add(AdjNode(
        index: 2,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 2));
    graph[8].adjNodes.add(AdjNode(
        index: 6,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 6));
    graph[8].adjNodes.add(AdjNode(
        index: 7,
        pathDescriptions: [
          MessageToRead(
            message: "Go !-!-!",
            position: RelativePosition.N,
          )
        ],
        distance: 1));
    return graph;
  }
}
