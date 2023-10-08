import 'package:anotador/model/team_status.dart';
import 'package:anotador/repositories/tables.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:anotador/utils/date_helper.dart' as date_helper;

class TeamResult {
  // during ffa matches, teamName is the playerName
  String teamName;
  int maxScore;
  int matchId;
  bool me;

  TeamResult(
      {required this.teamName,
      required this.maxScore,
      required this.matchId,
      required this.me});

  factory TeamResult.fromJson(int myTeamId, Map<String, dynamic> json) {
    return TeamResult(
        teamName: json['team_name'],
        maxScore: json['score'],
        matchId: json['match_id'],
        me: json['team_id'] == myTeamId);
  }
}

class ScoreSummarized {
  List<TeamResult> teamResult;

  get scoreLabel {
    if (teamResult.length > 2) {
      return teamResult.firstWhere((result) => result.me).maxScore.toString();
    }

    // TODO: sort by maxScore
    return teamResult.map((e) => e.maxScore).join(' - ');
  }

  get opponentName {
    if (teamResult.length > 2) {
      return 'Multiple';
    }

    return teamResult.firstWhere((result) => !result.me).teamName;
  }

  ScoreSummarized(this.teamResult);

  factory ScoreSummarized.fromJson(
      int myTeamId, List<Map<String, dynamic>> json) {
    return ScoreSummarized(json
        .map((e) => TeamResult.fromJson(myTeamId, e))
        .toList(growable: false));
  }
}

class Stats {
  int matchId;
  String gameName;
  DateTime createdAt;
  bool iWon;
  bool ffa;
  int myTeamId;
  ScoreSummarized? scoreSummarized;

  Stats(
      {required this.matchId,
      required this.gameName,
      required this.createdAt,
      required this.iWon,
      required this.ffa,
      required this.myTeamId,
      this.scoreSummarized});

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
        matchId: json['match_id'],
        gameName: json['game_name'],
        createdAt: date_helper.DateUtils.instance.fromDB(json['created_at']),
        iWon: json['is_me'] > 0,
        ffa: true,
        myTeamId: json['team_id'],
        scoreSummarized: null);
  }
}

class StatsRepository {
  Future<List<Stats>> getRawTable() async {
    // TODO: move filters outside
    const game = '%';

    final db = await AppData.database;

    var resultMap = await db.rawQuery(''' 
    select game_name, created_at, is_me, match_id, team_id
    from (
      select g.${Tables.game}_name as game_name, 1 is_me, 
             m.${Tables.match}_created_at as created_at, m.${Tables.match}_id as match_id,
             t.${Tables.team}_id as team_id
      from ${Tables.match} m
      inner join ${Tables.team} t
      on m.${Tables.match}_id = t.${Tables.team}_match_id
      inner join ${Tables.game} g
      on g.${Tables.game}_id = m.${Tables.match}_game_id and g.${Tables.game}_name like '$game'
      where t.${Tables.team}_status_id = ${TeamStatus.WON} and exists (
        select null
        from ${Tables.team_player} tp
        where t.${Tables.team}_id = tp.${Tables.team_player}_team_id and ${Tables.team_player}_user_id = 0
      )
      UNION ALL
      select g.${Tables.game}_name as game_name, 0 is_me, 
             m.${Tables.match}_created_at as created_at, m.${Tables.match}_id as match_id,
             t.${Tables.team}_id as team_id
      from ${Tables.match} m
      inner join ${Tables.team} t
      on m.${Tables.match}_id = t.${Tables.team}_match_id
      inner join ${Tables.game} g
      on g.${Tables.game}_id = m.${Tables.match}_game_id and g.${Tables.game}_name like '$game'
      where t.${Tables.team}_status_id = ${TeamStatus.LOST} and exists (
        select null
        from ${Tables.team_player} tp
        where t.${Tables.team}_id = tp.${Tables.team_player}_team_id and ${Tables.team_player}_user_id = 0
      )
    )
    ''');

    final scoreSummarized = await db.rawQuery('''
      select t.${Tables.team}_id as team_id, t.${Tables.team}_name as team_name, max(${Tables.team_score}_score) as score, m.${Tables.match}_id as match_id
      from ${Tables.team_score} ts
      inner join ${Tables.team} t
      on ts.${Tables.team_score}_team_id = t.${Tables.team}_id
      inner join ${Tables.match} m
      on t.${Tables.team}_match_id = m.${Tables.match}_id
      inner join ${Tables.game} g
      on m.${Tables.match}_game_id = g.${Tables.game}_id
      where g.${Tables.game}_name like '$game'
      group by ts.${Tables.team_score}_team_id
    ''');

    print(resultMap);
    print(scoreSummarized);
    return List.generate(resultMap.length, (i) {
      final json = resultMap[i];
      final stats = Stats.fromJson(json);
      stats.scoreSummarized = ScoreSummarized.fromJson(
          stats.myTeamId,
          scoreSummarized
              .where((element) => element['match_id'] == stats.matchId)
              .toList(growable: false));

      return stats;
    });
  }
}
