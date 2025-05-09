import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/virtual_town_hall/virtual_town_hall_repo_impl.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/response_model/virtual_town_hall/virtual_town_hall_response_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final virtualTownHallUseCaseProvider = Provider((ref) => VirtualTownHallUseCase(
    virtualTownHallRepository: ref.read(virtualTownHallRepositoryProvider)));

class VirtualTownHallUseCase implements UseCase<BaseModel, EmptyRequest> {
  VirtualTownHallRepository virtualTownHallRepository;

  VirtualTownHallUseCase({required this.virtualTownHallRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      EmptyRequest requestModel, BaseModel responseModel) async {
    final result =
        await virtualTownHallRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
