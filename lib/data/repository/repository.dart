import 'package:injectable/injectable.dart';
import 'package:very_good_slide_puzzle/data/data_source/remote_data_source/i_remote_data_source.dart';
import 'package:very_good_slide_puzzle/domain/entities/result_painting_entity.dart';
import 'package:very_good_slide_puzzle/domain/repository/i_repository.dart';

@LazySingleton(as: IRepository)
class Repository extends IRepository {
  const Repository({required IRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final IRemoteDataSource _remoteDataSource;

  @override
  Future<ResultPaintingEntity> getPaintings({String? paginationToken}) async {
    final paintings = await _remoteDataSource.getPaintings(paginationToken: paginationToken);

    final resultPaintingsEntity =
        ResultPaintingEntity.fromResultPaintingModel(resultPaintingModel: paintings);
    return resultPaintingsEntity;
  }
}
