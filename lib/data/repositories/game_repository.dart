import 'dart:math';

import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/data/models/game_winner.dart';
import 'package:spy_game/data/models/player_role.dart';

/// نتیجه رای‌گیری یک دور
class VotingResult {
  const VotingResult({
    required this.roles,
    this.eliminatedPlayerName,
    this.eliminatedRole,
    this.winner,
    this.isGameOver = false,
  });

  final List<PlayerRole> roles;
  final String? eliminatedPlayerName;
  final GameRole? eliminatedRole;
  final GameWinner? winner;
  final bool isGameOver;
}

/// منطق خالص بازی — تخصیص نقش، رای‌گیری، تعیین برنده
class GameRepository {
  GameRepository([Random? random]) : _random = random ?? Random();

  final Random _random;

  /// تخصیص نقش جاسوس به تعداد مشخص — شهروندها کلمه را می‌بینند
  List<PlayerRole> assignRoles({
    required List<String> playerNames,
    required int spyCount,
    required String word,
  }) {
    if (playerNames.isEmpty) return const [];

    final effectiveSpyCount = spyCount.clamp(
      GameConfig.minSpies,
      GameConfig.maxSpiesForPlayerCount(playerNames.length),
    );
    // تخصیص بر اساس ایندکس — با اسامی تکراری هم تعداد جاسوس درست می‌ماند
    final shuffledIndices = List.generate(playerNames.length, (index) => index)
      ..shuffle(_random);
    final spyIndices =
        shuffledIndices.take(effectiveSpyCount).toSet();

    return playerNames
        .asMap()
        .entries
        .map(
          (entry) => PlayerRole(
            playerName: entry.value,
            role: spyIndices.contains(entry.key)
                ? GameRole.spy
                : GameRole.citizen,
            word: spyIndices.contains(entry.key) ? null : word,
          ),
        )
        .toList();
  }

  /// آماده‌سازی دور بعدی — نقش‌ها و حذف‌شدگان حفظ، فقط کلمه عوض می‌شود
  List<PlayerRole> prepareNextRound({
    required List<PlayerRole> roles,
    required String newWord,
  }) {
    return roles
        .map(
          (role) => role.isEliminated
              ? role
              : role.copyWith(
                  word: role.role == GameRole.citizen ? newWord : null,
                  votedFor: null,
                ),
        )
        .toList();
  }

  /// محاسبه نتیجه رای‌گیری و بررسی شرط برد
  VotingResult resolveVoting({
    required List<PlayerRole> roles,
    required Map<String, String> votes,
  }) {
    final voteCounts = <String, int>{};
    for (final target in votes.values) {
      voteCounts[target] = (voteCounts[target] ?? 0) + 1;
    }

    if (voteCounts.isEmpty) {
      return VotingResult(roles: roles);
    }

    final maxVotes = voteCounts.values.reduce((a, b) => a > b ? a : b);
    final topVoted = voteCounts.entries
        .where((entry) => entry.value == maxVotes)
        .map((entry) => entry.key)
        .toList();

    // در صورت تساوی رای، حذف تصادفی
    final eliminatedName = topVoted.length == 1
        ? topVoted.first
        : topVoted[_random.nextInt(topVoted.length)];

    final updatedRoles = roles
        .map(
          (role) {
            final votedFor = votes[role.playerName];
            if (role.playerName == eliminatedName) {
              return role.copyWith(
                isEliminated: true,
                votedFor: votedFor,
              );
            }
            return role.copyWith(votedFor: votedFor);
          },
        )
        .toList();

    final eliminatedRole = updatedRoles
        .firstWhere((role) => role.playerName == eliminatedName)
        .role;

    final winnerCheck = checkWinner(updatedRoles);

    return VotingResult(
      roles: updatedRoles,
      eliminatedPlayerName: eliminatedName,
      eliminatedRole: eliminatedRole,
      winner: winnerCheck.winner,
      isGameOver: winnerCheck.isGameOver,
    );
  }

  /// بررسی شرط برد — شهروندها: همه جاسوس‌ها حذف | جاسوس‌ها: حداقل یک جاسوس باقی + برتری عددی
  ({GameWinner? winner, bool isGameOver}) checkWinner(
    List<PlayerRole> roles,
  ) {
    final alive = roles.where((role) => !role.isEliminated).toList();
    final spyCount = alive.where((role) => role.role == GameRole.spy).length;
    final citizenCount =
        alive.where((role) => role.role == GameRole.citizen).length;

    if (spyCount == 0) {
      return (winner: GameWinner.citizens, isGameOver: true);
    }
    if (spyCount >= citizenCount) {
      return (winner: GameWinner.spies, isGameOver: true);
    }
    return (winner: null, isGameOver: false);
  }
}
