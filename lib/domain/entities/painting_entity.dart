import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/data/models/remote_models/painting_model.dart';

class PaintingEntity extends Equatable {
  const PaintingEntity({
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

  factory PaintingEntity.fromPaintingModel({required PaintingModel paintingModel}) =>
      PaintingEntity(
        id: paintingModel.id,
        title: paintingModel.title,
        url: paintingModel.url,
        artistUrl: paintingModel.artistUrl,
        artistName: paintingModel.artistName,
        artistId: paintingModel.artistId,
        completitionYear: paintingModel.completitionYear,
        width: paintingModel.width,
        image: paintingModel.image,
        height: paintingModel.height,
      );

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

  @override
  List<Object?> get props => [
        id,
        title,
        url,
        artistUrl,
        artistName,
        artistId,
        completitionYear,
        width,
        height,
        image,
      ];
}
