import 'package:spy_game/data/models/player_role.dart';

/// اطلاعات نمایشی کارت نقش — بر اساس تنظیمات دور
class RoleRevealInfo {
  const RoleRevealInfo({
    this.word,
    this.categoryName,
    this.spyHint,
    this.coSpyNames = const [],
  });

  final String? word;
  final String? categoryName;
  final String? spyHint;
  final List<String> coSpyNames;
}

/// ساخت راهنمای کلمه برای جاسوس — حرف اول + ماسک
String buildSpyHint(String word) {
  if (word.isEmpty) return '';
  final runes = word.runes.toList();
  if (runes.length <= 1) return word;
  final first = String.fromCharCode(runes.first);
  return '$first${'•' * (runes.length - 1)}';
}

/// محاسبه محتوای نمایشی کارت بر اساس نقش و تنظیمات بازی
RoleRevealInfo buildRoleRevealInfo({
  required PlayerRole player,
  required int currentPlayerIndex,
  required String secretWord,
  required bool showCategoryForSpy,
  required bool spyHintEnabled,
  required bool spiesKnowEachOther,
  required List<PlayerRole> allRoles,
  String? categoryName,
}) {
  // شهروند و نفوذی کلمه را می‌بینند
  if (player.role == GameRole.citizen ||
      player.role == GameRole.infiltrator) {
    return RoleRevealInfo(word: player.word);
  }

  String? hint;
  if (spyHintEnabled && secretWord.isNotEmpty) {
    hint = buildSpyHint(secretWord);
  }

  String? category;
  if (showCategoryForSpy && categoryName != null && categoryName.isNotEmpty) {
    category = categoryName;
  }

  // شناسایی جاسوس‌های دیگر با ایندکس در لیست کامل نقش‌ها
  List<String> coSpies = const [];
  if (spiesKnowEachOther) {
    coSpies = allRoles
        .asMap()
        .entries
        .where(
          (entry) =>
              entry.key != currentPlayerIndex &&
              entry.value.role == GameRole.spy,
        )
        .map((entry) => entry.value.playerName)
        .toList()
      ..sort();
  }

  return RoleRevealInfo(
    categoryName: category,
    spyHint: hint,
    coSpyNames: coSpies,
  );
}
