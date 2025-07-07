import 'package:data/repo_impl/digifit/digifit_qr_scanner_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

final digifitQrScannerUseCaseProvider = Provider(
  (ref) => DigifitQrScannerUseCase(
    digifitQrScannerRepository: ref.read(digifitQrScannerRepositoryProvide),
  ),
);

abstract class QrScannerUseCase<T, R> {
  Future<R> call(T request);
}

class DigifitQrScannerUseCase
    implements QrScannerUseCase<String, Either<Exception, String>> {
  final DigifitQrScannerRepository digifitQrScannerRepository;

  DigifitQrScannerUseCase({
    required this.digifitQrScannerRepository,
  });

  @override
  Future<Either<Exception, String>> call(String shortUrl) async {
    return await digifitQrScannerRepository.call(shortUrl);
  }

  String getSlugFromUrl(String url) {
    Uri uri = Uri.parse(url);
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return segments.isNotEmpty ? segments.last : "";
  }
}
