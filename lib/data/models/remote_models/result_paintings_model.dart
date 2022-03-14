import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_slide_puzzle/data/models/remote_models/painting_model.dart';

part 'result_paintings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResultPaintingModel {
  const ResultPaintingModel({
    required this.data,
  });

  factory ResultPaintingModel.fromJson(Map<String, dynamic> json) => _$ResultPaintingModelFromJson(json);

  final List<PaintingModel> data;
  Map<String, dynamic> toJson() => _$ResultPaintingModelToJson(this);
}
