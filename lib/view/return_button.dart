import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/bloc/guide/guide_cubit.dart';

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key, required this.onPressed});
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    GuideState state = context.read<GuideCubit>().state;
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: Semantics(
        child: TextButton(
            onPressed: onPressed(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.arrow_back),
                Text("Return"),
              ],
            )),
      ),
    );
  }
}
