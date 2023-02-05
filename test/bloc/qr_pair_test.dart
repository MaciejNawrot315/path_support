import 'package:flutter_test/flutter_test.dart';
import 'package:path_support/bloc/qr_pair/qr_pair_cubit.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('QrPaiCubit', () {
    blocTest(
      '',
      build: () => QrPairCubit(),
      expect: () => [],
    );
  });
}
