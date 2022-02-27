class MatchStatus {
  static const int CREATED = 1;
  static const int IN_PROGRES = 2;
  static const int ENDED = 3;
  static const int CANCELLED = 4;

  int id;

  MatchStatus(this.id);
}