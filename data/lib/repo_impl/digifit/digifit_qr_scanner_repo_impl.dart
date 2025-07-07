import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../service/digifit_services/digifit_qr_scanner_services.dart';

final digifitQrScannerRepositoryProvide = Provider(
  (ref) => DigifitQrScannerRepoImpl(
    digifitQrScannerService: ref.read(digifitQrScannerServicesProvider),
  ),
);

abstract class DigifitQrScannerRepository {
  Future<Either<Exception, String>> call(String shortUrl);
}

class DigifitQrScannerRepoImpl implements DigifitQrScannerRepository {
  final DigifitQrScannerServices digifitQrScannerService;

  DigifitQrScannerRepoImpl({
    required this.digifitQrScannerService,
  });

  @override
  Future<Either<Exception, String>> call(String shortUrl) async {
    final result = await digifitQrScannerService.call(shortUrl);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
