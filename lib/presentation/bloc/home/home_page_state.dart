import 'package:very_good_slide_puzzle/domain/entities/painting_entity.dart';

abstract class HomePageState {
  const HomePageState({
    this.paintings = const <PaintingEntity>[],
  });

  final List<PaintingEntity> paintings;
}

class InitialHomePageState extends HomePageState {}

class GotPaintings extends HomePageState {
  const GotPaintings({
    required List<PaintingEntity> paintings,
  }) : super(
          paintings: paintings,
        );
}

class PaginationErrorState extends HomePageState {
  const PaginationErrorState({
    required List<PaintingEntity> paintings,
    required bool hasMore,
    required String? paginationTokken,
  }) : super(
          paintings: paintings,
        );
}

class GotPaintingsErrorState extends HomePageState {}
