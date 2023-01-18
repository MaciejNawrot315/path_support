import 'package:flutter/material.dart';

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key, required this.onPressed});
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: Semantics(
        child: TextButton(
            onPressed: () => onPressed(),
            style: TextButton.styleFrom(
                backgroundColor: Colors.blue, foregroundColor: Colors.white),
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
