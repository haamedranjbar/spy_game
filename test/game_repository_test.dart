import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:spy_game/data/models/game_winner.dart';
import 'package:spy_game/data/models/player_role.dart';
import 'package:spy_game/data/repositories/game_repository.dart';

void main() {
  group('GameRepository.assignRoles', () {
    test('assigns exact spy count and gives word only to citizens', () {
      final repo = GameRepository(Random(42));
      final roles = repo.assignRoles(
        playerNames: ['A', 'B', 'C', 'D', 'E', 'F'],
        spyCount: 2,
        word: 'سیب',
      );

      expect(roles, hasLength(6));

      final spies = roles.where((r) => r.role == GameRole.spy).toList();
      final citizens = roles.where((r) => r.role == GameRole.citizen).toList();

      expect(spies, hasLength(2));
      expect(citizens, hasLength(4));

      for (final spy in spies) {
        expect(spy.word, isNull);
      }
      for (final citizen in citizens) {
        expect(citizen.word, 'سیب');
      }
    });

    test('clamps spy count when too high', () {
      final repo = GameRepository(Random(1));
      final roles = repo.assignRoles(
        playerNames: ['A', 'B', 'C'],
        spyCount: 5,
        word: 'کلمه',
      );

      final spyCount = roles.where((r) => r.role == GameRole.spy).length;
      // ۳ بازیکن → حداکثر ۱ جاسوس (یکی کمتر از نصف)
      expect(spyCount, 1);
    });
  });

  group('GameRepository.prepareNextRound', () {
    test('preserves roles and elimination, updates citizen word only', () {
      final repo = GameRepository();
      final roles = [
        const PlayerRole(
          playerName: 'A',
          role: GameRole.citizen,
          word: 'قدیم',
        ),
        const PlayerRole(
          playerName: 'B',
          role: GameRole.spy,
          isEliminated: true,
        ),
        const PlayerRole(
          playerName: 'C',
          role: GameRole.spy,
          word: null,
        ),
      ];

      final updated = repo.prepareNextRound(
        roles: roles,
        newWord: 'جدید',
      );

      expect(updated[0].word, 'جدید');
      expect(updated[0].role, GameRole.citizen);
      expect(updated[1].isEliminated, isTrue);
      expect(updated[1].word, isNull);
      expect(updated[2].role, GameRole.spy);
      expect(updated[2].word, isNull);
      expect(updated[2].isEliminated, isFalse);
    });
  });

  group('GameRepository.resolveVoting', () {
    test('eliminates player with most votes', () {
      final repo = GameRepository();
      final roles = [
        const PlayerRole(playerName: 'A', role: GameRole.citizen, word: 'x'),
        const PlayerRole(playerName: 'B', role: GameRole.spy),
        const PlayerRole(playerName: 'C', role: GameRole.citizen, word: 'x'),
        const PlayerRole(playerName: 'D', role: GameRole.citizen, word: 'x'),
      ];

      final result = repo.resolveVoting(
        roles: roles,
        votes: {
          'A': 'B',
          'B': 'C',
          'C': 'B',
          'D': 'B',
        },
      );

      expect(result.eliminatedPlayerName, 'B');
      expect(result.eliminatedRole, GameRole.spy);
      expect(result.isGameOver, isTrue);
      expect(result.winner, GameWinner.citizens);

      final eliminated =
          result.roles.firstWhere((r) => r.playerName == 'B');
      expect(eliminated.isEliminated, isTrue);
    });

    test('records votedFor on each role', () {
      final repo = GameRepository();
      final roles = [
        const PlayerRole(playerName: 'A', role: GameRole.citizen, word: 'x'),
        const PlayerRole(playerName: 'B', role: GameRole.spy),
        const PlayerRole(playerName: 'C', role: GameRole.citizen, word: 'x'),
      ];

      final result = repo.resolveVoting(
        roles: roles,
        votes: {
          'A': 'B',
          'B': 'C',
          'C': 'B',
        },
      );

      expect(
        result.roles.firstWhere((r) => r.playerName == 'A').votedFor,
        'B',
      );
      expect(
        result.roles.firstWhere((r) => r.playerName == 'C').votedFor,
        'B',
      );
    });

    test('spies win when spies equal or outnumber citizens', () {
      final repo = GameRepository();
      final roles = [
        const PlayerRole(playerName: 'A', role: GameRole.citizen, word: 'x'),
        const PlayerRole(playerName: 'B', role: GameRole.spy),
        const PlayerRole(playerName: 'C', role: GameRole.spy),
      ];

      final result = repo.resolveVoting(
        roles: roles,
        votes: {
          'A': 'B',
          'B': 'A',
          'C': 'A',
        },
      );

      expect(result.eliminatedPlayerName, 'A');
      expect(result.winner, GameWinner.spies);
      expect(result.isGameOver, isTrue);
    });

    test('game continues when citizens still outnumber spies', () {
      final repo = GameRepository();
      final roles = [
        const PlayerRole(playerName: 'A', role: GameRole.citizen, word: 'x'),
        const PlayerRole(playerName: 'B', role: GameRole.spy),
        const PlayerRole(playerName: 'C', role: GameRole.citizen, word: 'x'),
        const PlayerRole(playerName: 'D', role: GameRole.citizen, word: 'x'),
      ];

      final result = repo.resolveVoting(
        roles: roles,
        votes: {
          'A': 'C',
          'B': 'C',
          'C': 'A',
          'D': 'C',
        },
      );

      expect(result.eliminatedPlayerName, 'C');
      expect(result.winner, isNull);
      expect(result.isGameOver, isFalse);
    });

    test('breaks two-way vote tie with seeded random', () {
      final repo = GameRepository(Random(0));
      final roles = [
        const PlayerRole(playerName: 'A', role: GameRole.citizen, word: 'x'),
        const PlayerRole(playerName: 'B', role: GameRole.spy),
        const PlayerRole(playerName: 'C', role: GameRole.citizen, word: 'x'),
        const PlayerRole(playerName: 'D', role: GameRole.spy),
      ];

      // B و D هر کدام ۲ رای — تساوی دوتایی
      final result = repo.resolveVoting(
        roles: roles,
        votes: {
          'A': 'B',
          'B': 'D',
          'C': 'D',
          'D': 'B',
        },
      );

      expect(result.eliminatedPlayerName, isIn(['B', 'D']));
    });
  });

  group('GameRepository.checkWinner', () {
    test('citizens win when no spies remain', () {
      final repo = GameRepository();
      final roles = [
        const PlayerRole(playerName: 'A', role: GameRole.citizen, word: 'x'),
        const PlayerRole(
          playerName: 'B',
          role: GameRole.spy,
          isEliminated: true,
        ),
      ];

      final check = repo.checkWinner(roles);
      expect(check.winner, GameWinner.citizens);
      expect(check.isGameOver, isTrue);
    });

    test('citizens win when infiltrator is eliminated and no spies remain', () {
      final repo = GameRepository();
      final roles = [
        const PlayerRole(playerName: 'A', role: GameRole.citizen, word: 'x'),
        const PlayerRole(
          playerName: 'B',
          role: GameRole.infiltrator,
          word: 'x',
          isEliminated: true,
        ),
      ];

      final check = repo.checkWinner(roles);
      expect(check.winner, GameWinner.citizens);
      expect(check.isGameOver, isTrue);
    });

    test('spies win when infiltrator outnumbers citizens', () {
      final repo = GameRepository();
      final roles = [
        const PlayerRole(playerName: 'A', role: GameRole.citizen, word: 'x'),
        const PlayerRole(
          playerName: 'B',
          role: GameRole.infiltrator,
          word: 'x',
        ),
      ];

      final check = repo.checkWinner(roles);
      expect(check.winner, GameWinner.spies);
      expect(check.isGameOver, isTrue);
    });
  });

  group('GameRepository.assignRoles special roles', () {
    test('assigns detective and infiltrator when enabled', () {
      final repo = GameRepository(Random(7));
      final roles = repo.assignRoles(
        playerNames: ['A', 'B', 'C', 'D', 'E', 'F'],
        spyCount: 2,
        word: 'کلمه',
        hasDetective: true,
        hasInfiltrator: true,
      );

      expect(
        roles.where((r) => r.role == GameRole.detective),
        hasLength(1),
      );
      expect(
        roles.where((r) => r.role == GameRole.infiltrator),
        hasLength(1),
      );
      expect(
        roles.where((r) => r.role == GameRole.spy),
        hasLength(1),
      );

      final detective =
          roles.firstWhere((r) => r.role == GameRole.detective);
      final infiltrator =
          roles.firstWhere((r) => r.role == GameRole.infiltrator);

      expect(detective.word, 'کلمه');
      expect(infiltrator.word, 'کلمه');
    });
  });

  group('GameRepository.getInvestigationResult', () {
    test('infiltrator appears as citizen to detective', () {
      final repo = GameRepository();
      const infiltrator = PlayerRole(
        playerName: 'X',
        role: GameRole.infiltrator,
        word: 'کلمه',
      );

      expect(
        repo.getInvestigationResult(infiltrator),
        GameRole.citizen,
      );
    });

    test('spy appears as spy to detective', () {
      final repo = GameRepository();
      const spy = PlayerRole(playerName: 'X', role: GameRole.spy);

      expect(repo.getInvestigationResult(spy), GameRole.spy);
    });
  });
}
