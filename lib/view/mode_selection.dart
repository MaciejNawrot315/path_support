import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/bloc/guide/guide_cubit.dart';
import 'package:path_support/constants/messages.dart';

class ModeSelectionView extends StatelessWidget {
  const ModeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Messages.descriptionModeDesc.play(),
                onDoubleTap: () {
                  Messages.descriptionModeSelected.play();
                  context.read<GuideCubit>().descriptionMode();
                },
                child: Container(
                  color: Colors.red,
                  child: const Text("description mode"),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => Messages.navigationModeDesc.play(),
                onDoubleTap: () {
                  Messages.navigationModeSelected.play();
                  context.read<GuideCubit>().navigationMode();
                },
                child: Container(
                  color: Colors.blue,
                  child: const Text("navigation mode"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
