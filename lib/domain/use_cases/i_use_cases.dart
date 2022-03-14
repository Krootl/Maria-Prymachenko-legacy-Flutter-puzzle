import 'package:equatable/equatable.dart';

mixin IUseCase<T, P> {
  Future<T> execute({required P params});
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
