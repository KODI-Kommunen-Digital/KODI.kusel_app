import 'package:domain/usecase/digifit/digifit_qr_scanner_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/digifit_screens/digifit_qr_scanner/digifit_qr_scanner_state.dart';

final digifitQrScannerControllerProvider = StateNotifierProvider.autoDispose<
    DigifitQrScannerController, DigifitQrScannerState>(
  (ref) => DigifitQrScannerController(
    digifitQrScannerUseCase: ref.read(digifitQrScannerUseCaseProvider),
  ),
);

class DigifitQrScannerController extends StateNotifier<DigifitQrScannerState> {
  final DigifitQrScannerUseCase digifitQrScannerUseCase;

  DigifitQrScannerController({
    required this.digifitQrScannerUseCase,
  }) : super(DigifitQrScannerState.initial());

  Future<void> validateQrScanner(String shortUrl, String equipmentSlug) async {
    final result = await digifitQrScannerUseCase.call(shortUrl);

    result.fold((error) {
      debugPrint("[Validate Url Expansion] URL expansion failed: $error");
    }, (expandedUrl) {
      final slugUrl = digifitQrScannerUseCase.getSlugFromUrl(expandedUrl);

      final isCorrectEquipment = slugUrl == equipmentSlug;

      if (isCorrectEquipment) {
        state = state.copyWith(isCorrectEquipment: isCorrectEquipment);
      }
    });
  }
}
