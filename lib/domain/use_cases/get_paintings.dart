import 'package:very_good_slide_puzzle/domain/entities/result_painting_entity.dart';
import 'package:very_good_slide_puzzle/domain/repository/i_repository.dart';
import 'package:very_good_slide_puzzle/domain/use_cases/i_use_cases.dart';

class GetPaintings with IUseCase<ResultPaintingEntity, String?> {
  const GetPaintings({
    required IRepository repository,
  }) : _repository = repository;

  final IRepository _repository;

  @override
  Future<ResultPaintingEntity> execute({required String? params}) =>
      _repository.getPaintings(paginationToken: params);
}
