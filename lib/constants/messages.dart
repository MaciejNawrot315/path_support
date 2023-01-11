import 'package:flutter_tts/flutter_tts.dart';

class Messages {
  static const String navigationMode = "Navigation mode";
  static const String descriptionMode = "Description mode";
  static const String initial =
      "Scan first QR code to start. QR codes should be placed on the corridor floors, in fornt of doors.";
  static const String codeScanned = "QR code scanned.";
  static const String buildingRecognized = "It seems like you are in ";
  static const String sayOrWrite =
      "Say or write the destination you want to arrive at .";
  static const String targetReached = "You have reached your destination.";
  static const String almostThere = "You are almost at Your destination";
  static const String pleaseSelectMode =
      "Select the mode in which you want to use the application";
  static const String descriptionModeHint =
      "Button, In description mode, you can get the description of the place you are in, by scanning a QR code placed on the floor.";
  static const String navigationModeHint =
      "Button, In navigation mode, you can choose a destination and you will receive instructions on how to navigate to it.";
  static const String navigationModeSelected = "Navigation mode selected.";
  static const String descriptionModeSelected = "Description mode selected.";
  static const String skipVoiceCommands = "Skip voice commands";
}

FlutterTts flutterTts = FlutterTts();

extension StringReading on String {
  Future<void> play() async {
    await flutterTts.stop();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.53);
    await flutterTts.speak(this);
  }
}

Future<void> skipVoiceCommands() async {
  await flutterTts.stop();
}
