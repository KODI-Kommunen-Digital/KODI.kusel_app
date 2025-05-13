import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:data/repo_impl/mein_ort/mein_ort_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final meinOrtUseCaseProvider = Provider((ref) => MeinOrtUseCase(
    meinOrtRepository: ref.read(meinOrtRepositoryProvider)));

class MeinOrtUseCase
    implements UseCase<BaseModel, EmptyRequest> {
  MeinOrtRepository meinOrtRepository;

  MeinOrtUseCase({required this.meinOrtRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      EmptyRequest requestModel, BaseModel responseModel) async {
    final result =
    await meinOrtRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
