import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/digifit/digifit_information_repo_impl.dart';

final digifitInformationUseCaseProvider = Provider((ref) =>
    DigifitInformationUseCase(
        digitfitInformationRepository:
            ref.read(digifitInformationRepositoryProvider)));

class DigifitInformationUseCase implements UseCase<BaseModel, EmptyRequest> {
  final DigifitInformationRepo digitfitInformationRepository;

  DigifitInformationUseCase({required this.digitfitInformationRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      EmptyRequest requestModel, BaseModel responseModel) async {
    final result =
        await digitfitInformationRepository.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
