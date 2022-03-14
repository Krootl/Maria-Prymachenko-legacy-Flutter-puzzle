import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_slide_puzzle/data/data_source/remote_data_source/i_remote_data_source.dart';
import 'package:very_good_slide_puzzle/data/models/remote_models/result_paintings_model.dart';

const String artistID = '57726d92edc2cb3880b4a8b2';

@LazySingleton(as: IRemoteDataSource)
class RemoteDataSource extends IRemoteDataSource {
  @override
  Future<ResultPaintingModel> getPaintings({String id = artistID, String? paginationToken}) async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/art_bank.json');
      return ResultPaintingModel.fromJson(json.decode(jsonString));
    } catch (e) {
      rethrow;
    }
  }
}
