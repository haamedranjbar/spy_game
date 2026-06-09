import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';

part 'categories_provider.g.dart';

/// State محلی صفحه انتخاب دسته
class CategoriesUiState {
  const CategoriesUiState({
    this.modeIndex = 0,
    this.isLoadingNext = false,
  });

  final int modeIndex;
  final bool isLoadingNext;

  CategoryType get categoryType =>
      modeIndex == 0 ? CategoryType.classic : CategoryType.family;

  CategoriesUiState copyWith({
    int? modeIndex,
    bool? isLoadingNext,
  }) {
    return CategoriesUiState(
      modeIndex: modeIndex ?? this.modeIndex,
      isLoadingNext: isLoadingNext ?? this.isLoadingNext,
    );
  }
}

@riverpod
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  CategoriesUiState build() {
    final game = ref.watch(gameProvider);
    final modeIndex = game.gameMode == CategoryType.family ? 1 : 0;
    return CategoriesUiState(modeIndex: modeIndex);
  }

  /// تغییر تب Classic / Family
  void setModeIndex(int index) {
    final mode =
        index == 0 ? CategoryType.classic : CategoryType.family;
    ref.read(gameProvider.notifier).setGameMode(mode);
    state = state.copyWith(modeIndex: index);
  }

  /// انتخاب دسته — فقط دسته‌های قابل بازی
  void toggleCategory(WordCategory category, {required bool isGoldenUser}) {
    if (category.isPremium && !isGoldenUser) return;
    ref.read(gameProvider.notifier).toggleCategory(category.id);
  }

  void setLoadingNext(bool value) {
    state = state.copyWith(isLoadingNext: value);
  }
}
