import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MyBarcode {
  String buildingName;
  List<Offset> corners;
  int pairIndex;
  BarcodeFormat format;
  MyBarcode({
    required this.buildingName,
    required this.corners,
    required this.pairIndex,
    required this.format,
  });
}
