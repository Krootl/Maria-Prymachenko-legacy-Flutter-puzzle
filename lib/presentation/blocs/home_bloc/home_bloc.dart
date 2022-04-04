import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/domain/entities/painting_entity.dart';
import 'package:very_good_slide_puzzle/domain/repository/i_repository.dart';
import 'package:very_good_slide_puzzle/domain/use_cases/get_paintings.dart' as get_paintings;
import 'package:very_good_slide_puzzle/injector.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/home_bloc/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(InitialHomeState()) {
    on<InitHome>(_onInitHome);
    on<GetPaintings>(_onGetPaintings);
  }

  final _paintings = <PaintingEntity>[];
  String? paginationTokken;

  Future<void> _onInitHome(HomeEvent event, Emitter<HomeState> emit) async {
    emit(InitialHomeState());
    add(GetPaintings());
  }

  Future<void> _onGetPaintings(HomeEvent event, Emitter<HomeState> emit) async {
    try {
      var result = await get_paintings.GetPaintings(repository: getIt<IRepository>()).execute(params: paginationTokken);
      if (result.data.isNotEmpty) {
        _paintings.addAll(result.data);
      }
      emit(GotPaintings(
        paintings: _paintings,
      ));
    } catch (e) {
      emit(GotPaintingsErrorState());
    }
  }
}
