import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/data/models/remote_models/result_paintings_model.dart';
import 'package:very_good_slide_puzzle/domain/entities/painting_entity.dart';

class ResultPaintingEntity extends Equatable {
  const ResultPaintingEntity({
    required this.data,
  });

  factory ResultPaintingEntity.fromResultPaintingModel({required ResultPaintingModel resultPaintingModel}) =>
      ResultPaintingEntity(
        data: resultPaintingModel.data.map((e) => PaintingEntity.fromPaintingModel(paintingModel: e)).toList(),
      );

  final List<PaintingEntity> data;

  @override
  List<Object?> get props => [
        data,
      ];
}
