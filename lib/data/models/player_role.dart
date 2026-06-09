/// نقش بازیکن در یک دور بازی — فقط در حافظه (نه Isar)
enum GameRole {
  citizen,
  spy,
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
      };

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
