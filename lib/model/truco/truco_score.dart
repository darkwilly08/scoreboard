class TrucoScore {
  final int points;
  final int pointsBySquare;
  final bool twoHalves;
  int get squareQuantity => points ~/ pointsBySquare;

  const TrucoScore(
      {required this.points,
      required this.pointsBySquare,
      required this.twoHalves});

  @override
  String toString() {
    int pointsByHalf = (points / 2).ceil();
    return twoHalves
        ? "$points ($pointsByHalf + $pointsByHalf)"
        : "$points (bad only)";
  }
}
