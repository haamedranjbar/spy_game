import 'package:flutter_test/flutter_test.dart';
import 'package:spy_game/core/utils/spy_reveal.dart';
import 'package:spy_game/data/models/player_role.dart';

void main() {
  group('buildRoleRevealInfo', () {
    final roles = [
      const PlayerRole(playerName: 'A', role: GameRole.spy),
      const PlayerRole(playerName: 'B', role: GameRole.spy),
      const PlayerRole(playerName: 'C', role: GameRole.citizen, word: 'x'),
      const PlayerRole(playerName: 'D', role: GameRole.spy),
    ];

    test('lists every other spy by index when spies know each other', () {
      final info = buildRoleRevealInfo(
        player: roles[0],
        currentPlayerIndex: 0,
        secretWordHint: 'قرمز',
        showCategoryForSpy: false,
        spyHintEnabled: false,
        spiesKnowEachOther: true,
        allRoles: roles,
      );

      expect(info.coSpyNames, ['B', 'D']); // مرتب‌شده الفبایی
    });

    test('handles duplicate names using player index', () {
      final duplicateRoles = [
        const PlayerRole(playerName: 'علی', role: GameRole.spy),
        const PlayerRole(playerName: 'علی', role: GameRole.spy),
        const PlayerRole(playerName: 'سارا', role: GameRole.citizen, word: 'x'),
      ];

      final firstSpy = buildRoleRevealInfo(
        player: duplicateRoles[0],
        currentPlayerIndex: 0,
        secretWordHint: 'قرمز',
        showCategoryForSpy: false,
        spyHintEnabled: false,
        spiesKnowEachOther: true,
        allRoles: duplicateRoles,
      );

      final secondSpy = buildRoleRevealInfo(
        player: duplicateRoles[1],
        currentPlayerIndex: 1,
        secretWordHint: 'قرمز',
        showCategoryForSpy: false,
        spyHintEnabled: false,
        spiesKnowEachOther: true,
        allRoles: duplicateRoles,
      );

      expect(firstSpy.coSpyNames, ['علی']);
      expect(secondSpy.coSpyNames, ['علی']);
    });

    test('returns empty co-spy list when setting is disabled', () {
      final info = buildRoleRevealInfo(
        player: roles[1],
        currentPlayerIndex: 1,
        secretWordHint: 'قرمز',
        showCategoryForSpy: false,
        spyHintEnabled: false,
        spiesKnowEachOther: false,
        allRoles: roles,
      );

      expect(info.coSpyNames, isEmpty);
    });
  });
}
