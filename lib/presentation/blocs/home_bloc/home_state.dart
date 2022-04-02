import 'package:very_good_slide_puzzle/domain/entities/painting_entity.dart';

abstract class HomeState {
  const HomeState({
    this.paintings = const <PaintingEntity>[],
  });

  final List<PaintingEntity> paintings;
}

class InitialHomeState extends HomeState {}

class GotPaintings extends HomeState {
  const GotPaintings({
    required List<PaintingEntity> paintings,
  }) : super(
          paintings: paintings,
        );
}

class PaginationErrorState extends HomeState {
  const PaginationErrorState({
    required List<PaintingEntity> paintings,
    required bool hasMore,
    required String? paginationTokken,
  }) : super(
          paintings: paintings,
        );
}

class GotPaintingsErrorState extends HomeState {}
