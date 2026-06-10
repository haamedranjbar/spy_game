/// نقش بازیکن در یک دور بازی — فقط در حافظه (نه Isar)
enum GameRole {
  citizen,
  spy,
  detective,
  infiltrator,
}

/// اطلاعات نقش یک بازیکن در دور جاری
class PlayerRole {
  const PlayerRole({
    required this.playerName,
    required this.role,
    this.word,
    this.isEliminated = false,
    this.votedFor,
  });

  final String playerName;
  final GameRole role;
  final String? word;
  final bool isEliminated;
  final String? votedFor;

  /// کلید ترجمه نقش برای easy_localization
  String get roleKey => switch (role) {
        GameRole.citizen => 'role.citizen',
        GameRole.spy => 'role.spy',
        GameRole.detective => 'role.detective',
        GameRole.infiltrator => 'role.infiltrator',
      };

  /// آیا این نقش جزو تیم جاسوس‌هاست؟
  bool get isSpyFaction =>
      role == GameRole.spy || role == GameRole.infiltrator;

  /// آیا این نقش جزو تیم شهروندهاست؟
  bool get isCitizenFaction =>
      role == GameRole.citizen || role == GameRole.detective;

  PlayerRole copyWith({
    String? playerName,
    GameRole? role,
    String? word,
    bool? isEliminated,
    String? votedFor,
  }) {
    return PlayerRole(
      playerName: playerName ?? this.playerName,
      role: role ?? this.role,
      word: word ?? this.word,
      isEliminated: isEliminated ?? this.isEliminated,
      votedFor: votedFor ?? this.votedFor,
    );
  }
}
