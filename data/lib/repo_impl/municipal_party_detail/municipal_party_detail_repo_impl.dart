import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/municipal_party_detail/municipal_party_detail_service.dart';

final municipalPartyDetailRepositoryProvider = Provider((ref) =>
    MunicipalPartyDetailRepoImpl(
        municipalPartyDetailRepository:
            ref.read(municipalPartyDetailServiceProvider)));

abstract class MunicipalPartyDetailRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class MunicipalPartyDetailRepoImpl implements MunicipalPartyDetailRepo {
  MunicipalPartyDetailService municipalPartyDetailRepository;

  MunicipalPartyDetailRepoImpl({required this.municipalPartyDetailRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await municipalPartyDetailRepository.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
