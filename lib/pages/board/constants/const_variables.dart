class RowConfig {
  final double width;
  final bool left;

  const RowConfig(this.width, this.left);
}

class HistoryTableConstants {
  HistoryTableConstants._();
  static const rowHeight = 52.0;
  static final columns = List<RowConfig>.of([
    const RowConfig(75, true),
    const RowConfig(100, false),
    const RowConfig(100, false),
    const RowConfig(100, false),
    const RowConfig(75, false),
  ]);
}
