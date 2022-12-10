import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_support/models/qr_code.dart';

part 'qr_pair_state.dart';

class QrPairCubit extends Cubit<QrPairState> {
  QrPairCubit() : super(QrPairInactive());

  void deactivePair() {
    emit(QrPairInactive());
  }

  Future<void> updateActivePair(MyBarcode barcode, MyBarcode qrCode) async {
    emit(QrPairActive(
      qrAngle: getQrAngle(barcode, qrCode),
      barcode: barcode,
      qrCode: qrCode,
    ));
  }

  double getQrAngle(MyBarcode barcode, MyBarcode qrCode) {
    List<Offset> barcodeCorners = barcode.corners;
    List<Offset> qrCodeCorners = qrCode.corners;

    double barcodeMidX = (barcodeCorners[0].dx + barcodeCorners[2].dx) / 2;
    double barcodeMidY = (barcodeCorners[0].dy + barcodeCorners[2].dy) / 2;
    double qrCodeMidX = (qrCodeCorners[0].dx + qrCodeCorners[2].dx) / 2;
    double qrCodeMidY = (qrCodeCorners[0].dy + qrCodeCorners[2].dy) / 2;
    Offset offset = Offset(qrCodeMidX - barcodeMidX, qrCodeMidY - barcodeMidY);
    return offset.direction;
  }
}
