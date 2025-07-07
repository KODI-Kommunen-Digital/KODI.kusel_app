import 'package:domain/usecase/digifit/digifit_qr_scanner_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/digifit_screens/digifit_qr_scanner/digifit_qr_scanner_state.dart';

final digifitQrScannerControllerProvider = StateNotifierProvider.autoDispose<
    DigifitQrScannerController, DigifitQrScannerState>(
  (ref) => DigifitQrScannerController(),
);

class DigifitQrScannerController extends StateNotifier<DigifitQrScannerState> {


  DigifitQrScannerController() : super(DigifitQrScannerState.initial());


}
