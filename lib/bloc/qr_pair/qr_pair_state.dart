part of 'qr_pair_cubit.dart';

abstract class QrPairState {
  MyBarcode? barcode;
  MyBarcode? qrCode;

  QrPairState({
    this.barcode,
    this.qrCode,
  });
}

class QrPairInactive extends QrPairState {}

class QrPairActive extends QrPairState {
  double qrAngle;
  QrPairActive({
    required this.qrAngle,
    required barcode,
    required qrCode,
  }) : super(
          barcode: barcode,
          qrCode: qrCode,
        );
}
