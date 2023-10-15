import 'package:anotador/repositories/stats_repository.dart';
import 'package:flutter/material.dart';

class StatsController extends ChangeNotifier {
  final StatsRepository _statsRepository = StatsRepository();

  Filter? _filters;

  List<Stats>? _rawTable;

  List<Stats>? get rawTable => _rawTable;

  Filter? get filters => _filters;

  StatsController();

  Future<void> getRawTable() async {
    _rawTable = await _statsRepository.getData(_filters);
    notifyListeners();
  }

  Future<void> updateFilters(Filter? filters) async {
    _filters = filters;
    await getRawTable();
  }

  void resetFilters() async {
    _filters = null;
    await getRawTable();
  }
}
