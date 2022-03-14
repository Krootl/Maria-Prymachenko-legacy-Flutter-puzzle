import 'package:very_good_slide_puzzle/data/models/remote_models/result_paintings_model.dart';

abstract class IRemoteDataSource {
  const IRemoteDataSource();

  Future<ResultPaintingModel> getPaintings({String? paginationToken});
}
