import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:riverpod/riverpod.dart';
import 'package:data/repo_impl/digifit/brain_teaser_game/boldi_finder_repo_impl.dart';

import '../../../model/request_model/digifit/brain_teaser_game/boldi_finder_request_model.dart';

final brainTeaserGameBoldiFinderUseCaseProvider = Provider((ref) =>
    BrainTeaserGameBoldiFinderUseCase(
        brainTeaserGameBoldiFinderRepositoryProvider:
            ref.read(brainTeaserGameBoldiFinderRepositoryProvider)));

class BrainTeaserGameBoldiFinderUseCase
    implements UseCase<BaseModel, BoldiFinderRequestModel> {
  final BrainTeaserGameTeaserBoldiFinderRepository
      brainTeaserGameBoldiFinderRepositoryProvider;

  BrainTeaserGameBoldiFinderUseCase(
      {required this.brainTeaserGameBoldiFinderRepositoryProvider});

  @override
  Future<Either<Exception, BaseModel>> call(
      BoldiFinderRequestModel requestModel, BaseModel responseModel) async {
    final result = await brainTeaserGameBoldiFinderRepositoryProvider.call(
        requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
