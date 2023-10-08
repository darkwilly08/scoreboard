import 'package:anotador/repositories/stats_repository.dart';
import 'package:flutter/material.dart';

class StatsController extends ChangeNotifier {
  final StatsRepository _statsRepository = StatsRepository();

  List<Stats>? _rawTable;

  List<Stats>? get rawTable => _rawTable;

  StatsController();

  Future<void> getRawTable() async {
    _rawTable = await _statsRepository.getRawTable();
    notifyListeners();
  }
}
