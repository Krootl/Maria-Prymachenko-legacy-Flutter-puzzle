import 'package:very_good_slide_puzzle/domain/entities/result_painting_entity.dart';

abstract class IRepository {
  const IRepository();

  Future<ResultPaintingEntity> getPaintings({String? paginationToken});
}
