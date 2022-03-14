import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/domain/entities/painting_entity.dart';
import 'package:very_good_slide_puzzle/domain/repository/i_repository.dart';
import 'package:very_good_slide_puzzle/domain/use_cases/get_paintings.dart' as get_paintings;
import 'package:very_good_slide_puzzle/injector.dart';
import 'package:very_good_slide_puzzle/presentation/bloc/home/bloc.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(InitialHomePageState()) {
    on<InitHomePage>(_onInitHomePage);
    on<GetPaintings>(_onGetPaintings);
  }
  var _paintings = <PaintingEntity>[];
  var _hasMore = false;
  String? paginationTokken;

  Future<void> _onInitHomePage(HomePageEvent event, Emitter<HomePageState> emit) async {
    emit(InitialHomePageState());
    add(GetPaintings());
  }

  Future<void> _onGetPaintings(HomePageEvent event, Emitter<HomePageState> emit) async {
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
