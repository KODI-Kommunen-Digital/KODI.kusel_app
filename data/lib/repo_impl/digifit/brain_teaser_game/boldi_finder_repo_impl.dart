import 'package:core/base_model.dart';
import 'package:data/repo_impl/repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../../service/digifit_services/brain_teaser_game/boldi_finder_service.dart';

final brainTeaserGameBoldiFinderRepositoryProvider = Provider((ref) =>
    BrainTeaserGameTeaserBoldiFinderRepository(
        brainTeaserGameTeaserBoldiFinderServiceProvider:
            ref.read(brainTeaserGameBoldiFinderServiceProvider)));

class BrainTeaserGameTeaserBoldiFinderRepository implements Repository {
  BrainTeaserGameBoldiFinderService
      brainTeaserGameTeaserBoldiFinderServiceProvider;

  BrainTeaserGameTeaserBoldiFinderRepository(
      {required this.brainTeaserGameTeaserBoldiFinderServiceProvider});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await brainTeaserGameTeaserBoldiFinderServiceProvider.call(
        requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
