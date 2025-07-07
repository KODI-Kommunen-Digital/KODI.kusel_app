import 'package:mobile_scanner/mobile_scanner.dart';

class DigifitQrScannerParam {
  Function(BarcodeCapture) onDetect;

  DigifitQrScannerParam({required this.onDetect});
}
