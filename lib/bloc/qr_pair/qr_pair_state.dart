part of 'qr_pair_cubit.dart';

abstract class QrPairState {
  MyBarcode? barcode;
  MyBarcode? qrCode;
  MyBarcode? prevBarcode;
  QrPairState({
    this.barcode,
    this.qrCode,
    this.prevBarcode,
  });
}

class QrPairInitial extends QrPairState {}

class QrPairInactive extends QrPairState {
  QrPairInactive({required MyBarcode prevBarcode})
      : super(prevBarcode: prevBarcode);
}

class QrPairActive extends QrPairState {
  double qrAngle;
  QrPairActive({
    required this.qrAngle,
    required barcode,
    required qrCode,
    required MyBarcode prevBarcode,
  }) : super(
          barcode: barcode,
          qrCode: qrCode,
          prevBarcode: prevBarcode,
        );
}
