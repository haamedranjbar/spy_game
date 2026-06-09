import 'package:flutter_test/flutter_test.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/constants/game_config.dart';

void main() {
  test('AppColors defines project theme palette', () {
    expect(AppColors.background.value, 0xFF0A0E1A);
    expect(AppColors.primaryRed.value, 0xFFE53935);
    expect(AppColors.primaryBlue.value, 0xFF1E88E5);
    expect(AppColors.accentDefault.value, 0xFF8B5CF6);
  });

  test('GameConfig defines default player limits', () {
    expect(GameConfig.minPlayers, 3);
    expect(GameConfig.maxPlayers, 100);
    expect(GameConfig.defaultPlayerCount, 5);
  });
}
