import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/bloc/compass_bloc/compass_bloc.dart';
import 'package:path_support/bloc/guide/guide_cubit.dart';
import 'package:path_support/models/message_to_read.dart';
import 'package:path_support/view/positioned_info_node.dart';
import 'package:path_support/view/return_button.dart';
import 'package:path_support/view/ring_painter.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    double nodeWidth = MediaQuery.of(context).size.width / 4;
    double nodeHeight = MediaQuery.of(context).size.height / 6;
    double radius = MediaQuery.of(context).size.width / 2 - nodeWidth / 2;
    return BlocBuilder<CompassBloc, double?>(
      builder: (context, compassState) {
        List<Widget> infoNodes = [];

        return BlocBuilder<GuideCubit, GuideState>(
          builder: (context, guideState) {
            List<MessageToRead> nextPathDescriptions = guideState
                .currentLocation!.adjNodes
                .firstWhere((element) =>
                    element.index ==
                    guideState.path[guideState.currentStep! + 1].index)
                .pathDescriptions;
            //TODO IN PRACA it should be ensured that there is only one description for one direction
            for (MessageToRead message
                in guideState.currentLocation!.description) {
              infoNodes.add(PositionedInfoNode(
                nodeHeight: nodeHeight,
                nodeWidth: nodeWidth,
                radius: radius,
                messageToRead: message,
                currentRotation: guideState.currentRotation!,
                compassSnapshot: guideState.compassSnapshot,
                currentCompassSnapshot: compassState,
              ));
            }
            return Stack(
              children: [
                ReturnButton(
                  onPressed: () => context
                      .read<GuideCubit>()
                      .newBuildingChoosed(
                          guideState.building!,
                          guideState.currentLocation!,
                          guideState.currentRotation!,
                          guideState.compassSnapshot),
                ),
                Center(
                  child: Semantics(
                    label: 'Next path description',
                    child: Container(
                      color: Colors.white,
                      width: nodeWidth,
                      height: nodeHeight,
                      child: ListView.builder(
                        itemCount: nextPathDescriptions.length,
                        itemBuilder: ((context, index) => Text(
                              nextPathDescriptions[index]
                                  .convertToRelativePosition(
                                      guideState.currentRotation!),
                            )),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: CustomPaint(
                    painter: RingPainter(
                        radius: radius, strokeWidth: 15, color: Colors.red),
                  ),
                ),
                ...infoNodes,
              ],
            );
          },
        );
      },
    );
  }
}
