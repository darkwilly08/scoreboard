import 'package:anotador/model/game.dart';
import 'package:anotador/model/team_status.dart';
import 'package:anotador/model/user.dart';
import 'package:anotador/utils/app_data.dart';
import 'package:anotador/utils/date_helper.dart';

class Filter {
  List<Game>? games;
  List<User>? users;

  Filter({this.games, this.users});
}

class TeamResult {
  // during ffa matches, teamName is the playerName
  String name;
  int lastScore;
  TeamStatus status;
  bool me;

  TeamResult(
      {required this.name,
      required this.lastScore,
      required this.status,
      required this.me});

  factory TeamResult.fromJson(Map<String, dynamic> json) {
    return TeamResult(
        // TODO: change to teamName in the future
        name: json['players'],
        lastScore: json['last_score'],
        status: TeamStatus(json['team_status_id']),
        me: json['is_my_team'] > 0);
  }
}

class Stats {
  int matchId;
  String gameName;
  DateTime createdAt;
  DateTime endAt;
  bool ffa;
  List<TeamResult> teamsResults;

// TODO: get from teamsResults
  String wonPlayerName = '';
  bool get iWon =>
      teamsResults.firstWhere((result) => result.me).status.id ==
      TeamStatus.WON;

  String get scoreLabel {
    if (teamsResults.length > 2) {
      return teamsResults
          .firstWhere((result) => result.me)
          .lastScore
          .toString();
    }

    return teamsResults.map((e) => e.lastScore).join(' - ');
  }

  Stats({
    required this.matchId,
    required this.gameName,
    required this.createdAt,
    required this.endAt,
    required this.ffa,
  }) : teamsResults = List.empty(growable: true);

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      matchId: json['match_id'],
      gameName: json['game_name'],
      createdAt: DateUtils.instance.fromDB(json['created_at']),
      endAt: DateUtils.instance.fromDB(json['end_at']),
      ffa: true,
    );
  }
}

class StatsRepository {
  Future<List<Stats>> getData(Filter? filter) async {
    final db = await AppData.database;

    final gamesToFilter = filter?.games?.map((g) => g.id).join(',');
    final usersToFilter = filter?.users?.map((u) => u.id).join(',');

    // TODO: instead of get max score, get the last entry of the team_score table
    final query = '''
      select 
          stats.game_name,
          stats.created_at,
          stats.end_at,
          case when stats.score is null then 0 else stats.score end as last_score,
          stats.players, 
          stats.team_status_id, 
          stats.match_id,
          case when stats.temp_min_user_id = 0 then 1 else 0 end as is_my_team
      from 
      (
          select g.game_name as game_name, 
              m.match_created_at as created_at, 
              m.match_end_at as end_at,
              m.match_id as match_id,
              t.team_id as team_id,
              GROUP_CONCAT(DISTINCT u.user_name) as players,
              MAX(t.team_status_id) as team_status_id,
              MIN(u.user_id) as temp_min_user_id,
              max(team_score_score) as score
        from match m
        inner join team t
        on m.match_id = t.team_match_id
        inner join game g
        on g.game_id = m.match_game_id ${gamesToFilter?.isNotEmpty == true ? 'and g.game_id in ($gamesToFilter)' : ''} 
        inner join team_player tp
        on t.team_id = tp.team_player_team_id
        inner join user u
          on u.user_id = tp.team_player_user_id
        left join team_score ts
          on ts.team_score_team_id = t.team_id
      where m.match_end_at is not null
      group by m.match_id, t.team_id
      ) as stats
      where exists (
          select null 
              from team_player tp2
              where 1 = 1
              and tp2.team_player_user_id in ${usersToFilter?.isNotEmpty == true ? '(0,$usersToFilter)' : '(0)'}
              and exists (
                  select null
                  from team t2
                  where t2.team_id = tp2.team_player_team_id
                  and t2.team_match_id = stats.match_id
              )
          
      )
      order by stats.created_at desc, is_my_team desc;
    ''';

    List<Map<String, dynamic>> resultMap = await db.rawQuery(query);

    Map<int, Stats> map = Map.identity();

    for (var row in resultMap) {
      int matchId = row['match_id'];

      final stats = map.putIfAbsent(matchId, () => Stats.fromJson(row));

      stats.teamsResults.add(TeamResult.fromJson(row));
    }

    return map.values.toList(growable: false);
  }
}
