import 'package:equatable/equatable.dart';

class Position extends Equatable implements Comparable<Position> {
  const Position({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  @override
  List<Object> get props => [x, y];

  @override
  int compareTo(Position other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    } else {
      if (x < other.x) {
        return -1;
      } else if (x > other.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}
