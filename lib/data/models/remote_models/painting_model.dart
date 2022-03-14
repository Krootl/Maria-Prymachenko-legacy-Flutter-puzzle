import 'package:json_annotation/json_annotation.dart';

part 'painting_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaintingModel {
  const PaintingModel({
    required this.id,
    required this.title,
    required this.url,
    required this.artistUrl,
    required this.artistName,
    required this.artistId,
    required this.completitionYear,
    required this.width,
    required this.image,
    required this.height,
  });

  factory PaintingModel.fromJson(Map<String, dynamic> json) => _$PaintingModelFromJson(json);

  final String id;
  final String title;
  final String url;
  final String? artistUrl;
  final String? artistName;
  final String artistId;
  final int completitionYear;
  final int width;
  final String image;
  final int height;

  Map<String, dynamic> toJson() => _$PaintingModelToJson(this);
}
