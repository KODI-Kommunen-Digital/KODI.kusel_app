import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:data/repo_impl/Participate/Participate_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final participateUseCaseProvider = Provider((ref) => ParticipateUseCase(
    participateRepoImpl: ref.read(participateRepositoryProvider)));

class ParticipateUseCase
    implements UseCase<BaseModel, EmptyRequest> {
  ParticipateRepoImpl participateRepoImpl;

  ParticipateUseCase({required this.participateRepoImpl});

  @override
  Future<Either<Exception, BaseModel>> call(
      EmptyRequest requestModel, BaseModel responseModel) async {
    final result = await participateRepoImpl.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
