// ignore_for_file: constant_identifier_names

enum RelativePosition { N, NW, W, SW, S, SE, E, NE }

class MessToRead {
  String message;
  RelativePosition position;
  MessToRead({
    required this.message,
    required this.position,
  });

  String convertToString(RelativePosition cameraOrientation) {
    //TODO
    return '';
  }
}
