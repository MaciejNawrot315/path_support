import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/bloc/guide/guide_cubit.dart';
import 'package:path_support/view/return_button.dart';
import 'package:searchfield/searchfield.dart';

class DestinationSelectionPage extends StatefulWidget {
  const DestinationSelectionPage({super.key});

  @override
  State<DestinationSelectionPage> createState() =>
      _DestinationSelectionPageState();
}

class _DestinationSelectionPageState extends State<DestinationSelectionPage> {
  late String destination;
  bool textFieldFocused = false;
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  @override
  void initState() {
    super.initState();
    focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      textFieldFocused = focus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    GuideState guideState = context.read<GuideCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            //TODO IN PRACA it was neccesary to change this button when the textfield was open
            ReturnButton(onPressed: () {
              if (textFieldFocused) {
                focus.unfocus();
              } else {
                context.read<GuideCubit>().newBuildingChoosed(
                    guideState.building!,
                    guideState.currentLocation!,
                    guideState.currentRotation!,
                    guideState.compassSnapshot);
              }
            }),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          child: Center(
            child: Container(
              color: Colors.white,
              child: Text(
                guideState.building!.fullName,
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: SearchField(
            controller: controller,
            focusNode: focus,
            maxSuggestionsInViewPort: 4,
            autoCorrect: false,
            hint: "Search for a destination",
            onSubmit: (p0) => saveDestination(p0),
            suggestions: guideState.building!.graph
                .map((e) => SearchFieldListItem(e.name, item: e))
                .toList(),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          child: Semantics(
            excludeSemantics: textFieldFocused,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () async {
                int targetIndex =
                    context.read<GuideCubit>().findNodeIndex(destination);
                if (targetIndex == -1) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Destination not found, try correcting inserted text",
                    ),
                  ));
                } else {
                  context.read<GuideCubit>().navigateTo(targetIndex);
                }
              },
              child: const Text("Submit"),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    focus.removeListener(_onFocusChange);
    focus.dispose();
  }

  void saveDestination(String destination) {
    this.destination = destination;
  }
}
