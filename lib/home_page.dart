import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_support/bloc/qr_pair/qr_pair_cubit.dart';
import 'package:path_support/models/adj_node.dart';
import 'package:path_support/models/guide.dart';
import 'package:path_support/models/message_to_read.dart';
import 'package:path_support/models/node.dart';
import 'package:path_support/models/qr_code.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MyBarcode? prevBarcode;
  @override
  Widget build(BuildContext context) {
    return BlocListener<QrPairCubit, QrPairState>(
      listener: (context, state) {
        if (state is QrPairActive) {
          checkDijkstra();
        }
      },
      child: BlocBuilder<QrPairCubit, QrPairState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                MobileScanner(
                  allowDuplicates: false,
                  onDetect: (barcode, args) async {
                    if (barcode.rawValue == null) {
                    } else {
                      MyBarcode? currentBarcode = parseAndValidateQr(barcode);
                      if (currentBarcode == null) return;
                      if (prevBarcode == null ||
                          prevBarcode!.format == currentBarcode.format) {
                        prevBarcode = currentBarcode;
                        return;
                      }
                      if (prevBarcode!.pairIndex == currentBarcode.pairIndex) {
                        if (prevBarcode!.format == BarcodeFormat.code128 &&
                            currentBarcode.format == BarcodeFormat.qrCode) {
                          context.read<QrPairCubit>().updateActivePair(
                                prevBarcode!,
                                currentBarcode,
                              );
                        } else if (prevBarcode!.format ==
                                BarcodeFormat.qrCode &&
                            currentBarcode.format == BarcodeFormat.code128) {
                          context.read<QrPairCubit>().updateActivePair(
                                currentBarcode,
                                prevBarcode!,
                              );
                        }
                      } else {
                        context.read<QrPairCubit>().deactivePair();
                      }
                      prevBarcode == currentBarcode;
                    }
                  },
                ),
                state is QrPairActive
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.qrCode!.pairIndex.toString()),
                            Transform.rotate(
                              angle: state.qrAngle,
                              child: const Icon(
                                Icons.arrow_right_alt_sharp,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      )
                    : const Icon(
                        Icons.abc,
                        color: Colors.red,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  MyBarcode? parseAndValidateQr(Barcode barcode) {
    try {
      List<String>? barcodeInfo = barcode.rawValue?.split(':');
      if (barcodeInfo == null ||
          barcodeInfo.length != 3 ||
          barcode.corners == null ||
          barcode.corners?.length != 4 ||
          (barcode.format != BarcodeFormat.code128 &&
              barcode.format != BarcodeFormat.qrCode)) {
        return null;
      }
      int pairIndex = int.parse(barcodeInfo[1]);

      return MyBarcode(
          buildingName: barcodeInfo[0],
          corners: barcode.corners!,
          pairIndex: pairIndex,
          format: barcode.format);
    } on Exception {
      return null;
    }
  }

  checkDijkstra() {
    Guide guide = Guide();
    List<Node> graph = [];
    for (int i = 0; i < 9; i++) {
      graph.add(Node(
        name: "Node $i",
        index: i,
        tempParent: -1,
        adjNodes: [],
        tempDistance: double.infinity,
        messToRead: [
          MessToRead(
            message: "!-!-!",
            position: RelativePosition.N,
          )
        ],
      ));
    }
    graph[0].adjNodes.add(AdjNode(index: 1, distance: 4));
    graph[0].adjNodes.add(AdjNode(index: 7, distance: 8));
    graph[1].adjNodes.add(AdjNode(index: 2, distance: 8));
    graph[1].adjNodes.add(AdjNode(index: 7, distance: 11));
    graph[1].adjNodes.add(AdjNode(index: 0, distance: 7));
    graph[2].adjNodes.add(AdjNode(index: 1, distance: 8));
    graph[2].adjNodes.add(AdjNode(index: 3, distance: 7));
    graph[2].adjNodes.add(AdjNode(index: 8, distance: 2));
    graph[2].adjNodes.add(AdjNode(index: 5, distance: 4));
    graph[3].adjNodes.add(AdjNode(index: 2, distance: 7));
    graph[3].adjNodes.add(AdjNode(index: 4, distance: 9));
    graph[3].adjNodes.add(AdjNode(index: 5, distance: 14));
    graph[4].adjNodes.add(AdjNode(index: 3, distance: 9));
    graph[4].adjNodes.add(AdjNode(index: 5, distance: 10));
    graph[5].adjNodes.add(AdjNode(index: 4, distance: 10));
    graph[5].adjNodes.add(AdjNode(index: 6, distance: 2));
    graph[6].adjNodes.add(AdjNode(index: 5, distance: 2));
    graph[6].adjNodes.add(AdjNode(index: 7, distance: 1));
    graph[6].adjNodes.add(AdjNode(index: 8, distance: 6));
    graph[7].adjNodes.add(AdjNode(index: 0, distance: 8));
    graph[7].adjNodes.add(AdjNode(index: 1, distance: 11));
    graph[7].adjNodes.add(AdjNode(index: 6, distance: 1));
    graph[7].adjNodes.add(AdjNode(index: 8, distance: 7));
    graph[8].adjNodes.add(AdjNode(index: 2, distance: 2));
    graph[8].adjNodes.add(AdjNode(index: 6, distance: 6));
    graph[8].adjNodes.add(AdjNode(index: 7, distance: 1));
    List<Node> path = guide.fastestPathToTargetDijkstra(0, graph, 4);
    print(path);
  }
}
