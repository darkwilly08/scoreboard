class TrucoScore {
  final int points;
  final int pointsBySquare;
  int get squareQuantity => points ~/ pointsBySquare;

  const TrucoScore({required this.points, required this.pointsBySquare});
}
