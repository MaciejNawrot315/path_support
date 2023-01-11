import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/bloc/guide/guide_cubit.dart';
import 'package:path_support/constants/messages.dart';
import 'package:path_support/view/return_button.dart';

class ModeSelectionView extends StatelessWidget {
  const ModeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Text(
              "${Messages.buildingRecognized} ${context.read<GuideCubit>().state.building!.fullName}",
            ),
          ),
          const Center(
            child: Text(
              "Choose a guide mode that you want to use:",
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: MergeSemantics(
                  child: Semantics(
                    label: Messages.descriptionMode,
                    hint: Messages.descriptionModeHint,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: TextButton(
                        onPressed: () {
                          context.read<GuideCubit>().descriptionMode();
                        },
                        child: const Text(Messages.descriptionMode),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MergeSemantics(
                  child: Semantics(
                    label: Messages.navigationMode,
                    hint: Messages.navigationModeHint,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: TextButton(
                        onPressed: () {
                          context.read<GuideCubit>().navigationMode();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Center(
                          child: Text(Messages.navigationMode),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
