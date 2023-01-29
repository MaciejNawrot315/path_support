import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/bloc/compass_bloc/compass_bloc.dart';
import 'package:path_support/bloc/guide/guide_cubit.dart';
import 'package:path_support/models/relatively_positioned_message.dart';
import 'package:path_support/view/positioned_info_node.dart';
import 'package:path_support/view/return_button.dart';
import 'package:path_support/view/ring_painter.dart';

class DescriptionPage extends StatelessWidget {
  const DescriptionPage({super.key, required this.targetReached});
  final bool targetReached;
  @override
  Widget build(BuildContext context) {
    double nodeWidth = MediaQuery.of(context).size.width / 4;
    double nodeHeight = MediaQuery.of(context).size.height / 6;
    double radius = MediaQuery.of(context).size.width / 2 - nodeWidth / 2;
    return BlocBuilder<CompassBloc, double?>(
      builder: (context, compassState) {
        return BlocBuilder<GuideCubit, GuideState>(
          builder: (context, guideState) {
            List<Widget> infoNodes = [];

            //TODO IN PRACA it should be ensured that there is only one description for one direction
            for (RelativelyPositionedMessage message
                in guideState.currentLocation!.descriptions) {
              infoNodes.add(PositionedInfoNode(
                elementHeight: nodeHeight,
                elementWidth: nodeWidth,
                radius: radius,
                positionedDescription: message,
                screenRotationSnapshot: guideState.currentRotation!,
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
                Positioned.fill(
                  top: MediaQuery.of(context).size.height / 10,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        targetReached
                            ? Container(
                                color: Colors.red,
                                child:
                                    const Text("You reached your destination"),
                              )
                            : const SizedBox(),
                        Container(
                          color: Colors.red,
                          child: Text(guideState.currentLocation!.name),
                        ),
                      ],
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
