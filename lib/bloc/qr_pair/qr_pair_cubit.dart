import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_support/models/my_barcode.dart';

part 'qr_pair_state.dart';

class QrPairCubit extends Cubit<QrPairState> {
  QrPairCubit() : super(QrPairInitial());

  void updatePair(Barcode newBarcode) {
    MyBarcode? currentBarcode = parseAndValidateQr(newBarcode);
    if (currentBarcode == null) return;
    if (state is QrPairInitial ||
        state.prevBarcode!.format == currentBarcode.format) {
      emit(QrPairPartiallyFilled(prevBarcode: currentBarcode));
      return;
    }
    if (state.prevBarcode!.pairIndex == currentBarcode.pairIndex) {
      if (state.prevBarcode!.format == BarcodeFormat.code128 &&
          currentBarcode.format == BarcodeFormat.qrCode) {
        emit(QrPairActive(
            qrAngle: getQrPairDirection(state.prevBarcode!, currentBarcode),
            barcode: state.prevBarcode,
            qrCode: currentBarcode,
            prevBarcode: currentBarcode));
      } else if (state.prevBarcode!.format == BarcodeFormat.qrCode &&
          currentBarcode.format == BarcodeFormat.code128) {
        emit(QrPairActive(
            qrAngle: getQrPairDirection(currentBarcode, state.prevBarcode!),
            barcode: currentBarcode,
            qrCode: state.prevBarcode,
            prevBarcode: currentBarcode));
      }
    } else {
      emit(QrPairPartiallyFilled(prevBarcode: currentBarcode));
    }
  }

  double getQrPairDirection(MyBarcode barcode, MyBarcode qrCode) {
    List<Offset> barcodeCorners = barcode.corners;
    List<Offset> qrCodeCorners = qrCode.corners;

    double barcodeMidX = (barcodeCorners[0].dx + barcodeCorners[2].dx) / 2;
    double barcodeMidY = (barcodeCorners[0].dy + barcodeCorners[2].dy) / 2;
    double qrCodeMidX = (qrCodeCorners[0].dx + qrCodeCorners[2].dx) / 2;
    double qrCodeMidY = (qrCodeCorners[0].dy + qrCodeCorners[2].dy) / 2;
    Offset offset = Offset(qrCodeMidX - barcodeMidX, qrCodeMidY - barcodeMidY);
    // print(convertToRelativePosition(offset.direction, RelativePosition.N));
    return offset.direction;
  }

  MyBarcode? parseAndValidateQr(Barcode barcode) {
    try {
      List<String>? barcodeInfo = barcode.rawValue?.split(':');
      if (barcodeInfo == null ||
          barcodeInfo.length != 3 ||
          barcode.corners == null ||
          barcode.corners?.length != 4 ||
          (barcode.format != BarcodeFormat.code128 &&
              barcode.format != BarcodeFormat.qrCode)) {
        return null;
      }
      int pairIndex = int.parse(barcodeInfo[1]);

      return MyBarcode(
          buildingName: barcodeInfo[0],
          corners: barcode.corners!,
          pairIndex: pairIndex,
          format: barcode.format);
    } on Exception {
      return null;
    }
  }
}
