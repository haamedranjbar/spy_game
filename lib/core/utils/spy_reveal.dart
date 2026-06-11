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

/// محاسبه محتوای نمایشی کارت بر اساس نقش و تنظیمات بازی
RoleRevealInfo buildRoleRevealInfo({
  required PlayerRole player,
  required int currentPlayerIndex,
  required bool showCategoryForSpy,
  required bool spyHintEnabled,
  required bool spiesKnowEachOther,
  required List<PlayerRole> allRoles,
  String? secretWordHint,
  String? categoryName,
}) {
  // شهروند و کاراگاه کلمه را می‌بینند
  if (player.role == GameRole.citizen ||
      player.role == GameRole.detective) {
    return RoleRevealInfo(word: player.word);
  }

  // نفوذی کلمه را می‌بیند و همیشه جاسوس‌های دیگر را می‌شناسد
  if (player.role == GameRole.infiltrator) {
    final coSpies = allRoles
        .where((role) => role.role == GameRole.spy)
        .map((role) => role.playerName)
        .toList()
      ..sort();
    return RoleRevealInfo(
      word: player.word,
      coSpyNames: coSpies,
    );
  }

  // راهنمای توصیفی از دیتابیس — نه حرف اول کلمه
  String? hint;
  if (spyHintEnabled &&
      secretWordHint != null &&
      secretWordHint.isNotEmpty) {
    hint = secretWordHint;
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
