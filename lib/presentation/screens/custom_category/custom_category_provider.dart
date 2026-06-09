import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/data/repositories/category_repository.dart';
import 'package:spy_game/presentation/providers/category_provider.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/providers/isar_provider.dart';

part 'custom_category_provider.g.dart';

/// State صفحه ساخت دسته سفارشی
class CustomCategoryState {
  const CustomCategoryState({
    this.name = '',
    this.type = CategoryType.classic,
    this.words = const [''],
    this.isSaving = false,
  });

  final String name;
  final CategoryType type;
  final List<String> words;
  final bool isSaving;

  int get validWordCount =>
      words.where((w) => w.trim().isNotEmpty).length;

  bool get canSave => name.trim().isNotEmpty && validWordCount >= 3;

  CustomCategoryState copyWith({
    String? name,
    CategoryType? type,
    List<String>? words,
    bool? isSaving,
  }) {
    return CustomCategoryState(
      name: name ?? this.name,
      type: type ?? this.type,
      words: words ?? this.words,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

@riverpod
class CustomCategoryNotifier extends _$CustomCategoryNotifier {
  final CategoryRepository _repository = const CategoryRepository();

  @override
  CustomCategoryState build() {
    final gameMode = ref.read(gameProvider).gameMode;
    return CustomCategoryState(type: gameMode);
  }

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setType(CategoryType type) {
    state = state.copyWith(type: type);
  }

  void updateWord(int index, String value) {
    if (index < 0 || index >= state.words.length) return;
    final words = List<String>.from(state.words);
    words[index] = value;
    state = state.copyWith(words: words);
  }

  void addWord() {
    state = state.copyWith(words: [...state.words, '']);
  }

  void removeWord(int index) {
    if (state.words.length <= 1) return;
    final words = List<String>.from(state.words)..removeAt(index);
    state = state.copyWith(words: words);
  }

  /// ذخیره دسته سفارشی در Isar
  Future<WordCategory?> save() async {
    if (!state.canSave) return null;

    state = state.copyWith(isSaving: true);
    try {
      final isar = await ref.read(isarProvider.future);
      final category = await _repository.createCustomCategory(
        isar: isar,
        name: state.name,
        type: state.type,
        words: state.words,
      );

      if (category != null) {
        ref.invalidate(categoriesByTypeProvider(state.type));
        final game = ref.read(gameProvider);
        if (game.gameMode == state.type &&
            !game.selectedCategoryIds.contains(category.id)) {
          ref.read(gameProvider.notifier).toggleCategory(category.id);
        }
      }

      return category;
    } catch (e, stackTrace) {
      appLogger.e('Failed to save custom category', e, stackTrace);
      return null;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }
}
