import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../dio_helper_object.dart';

final digifitQrScannerServicesProvider = Provider(
  (ref) => DigifitQrScannerServices(ref: ref),
);

class DigifitQrScannerServices {
  final Ref ref;

  DigifitQrScannerServices({required this.ref});

  Future<Either<Exception, String>> call(String shortUrl) async {
    final apiHelper = ref.read(apiHelperProvider);

    final result = await apiHelper.getRequestUrlHelper(shortUrl: shortUrl);

    return result.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
