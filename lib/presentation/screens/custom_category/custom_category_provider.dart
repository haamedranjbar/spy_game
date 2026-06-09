import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/utils/app_logger.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/data/repositories/category_repository.dart';
import 'package:spy_game/presentation/providers/category_provider.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/providers/isar_provider.dart';
import 'package:spy_game/presentation/widgets/custom_category_selector.dart';

part 'custom_category_provider.g.dart';

/// نتیجه تلاش ذخیره دسته سفارشی
enum CustomCategorySaveResult {
  success,
  updated,
  missingName,
  missingWords,
  failed,
}

/// State صفحه ساخت/ویرایش دسته سفارشی
class CustomCategoryState {
  const CustomCategoryState({
    this.name = '',
    this.type = CategoryType.classic,
    this.words = const ['', ''],
    this.isSaving = false,
    this.selectedCategoryId,
    this.savedCategories = const [],
    this.loadedCategoryType,
  });

  final String name;
  final CategoryType type;
  final List<String> words;
  final bool isSaving;
  final int? selectedCategoryId;
  final List<CustomCategorySelectorItem> savedCategories;
  final CategoryType? loadedCategoryType;

  bool get isEditing => selectedCategoryId != null;

  int get validWordCount =>
      words.where((word) => word.trim().isNotEmpty).length;

  bool get canSave =>
      name.trim().isNotEmpty &&
      validWordCount >= GameConfig.minCustomCategoryWords;

  CustomCategoryState copyWith({
    String? name,
    CategoryType? type,
    List<String>? words,
    bool? isSaving,
    int? selectedCategoryId,
    List<CustomCategorySelectorItem>? savedCategories,
    CategoryType? loadedCategoryType,
    bool clearSelectedCategory = false,
    bool clearLoadedCategoryType = false,
  }) {
    return CustomCategoryState(
      name: name ?? this.name,
      type: type ?? this.type,
      words: words ?? this.words,
      isSaving: isSaving ?? this.isSaving,
      selectedCategoryId: clearSelectedCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      savedCategories: savedCategories ?? this.savedCategories,
      loadedCategoryType: clearLoadedCategoryType
          ? null
          : (loadedCategoryType ?? this.loadedCategoryType),
    );
  }
}

@riverpod
class CustomCategoryNotifier extends _$CustomCategoryNotifier {
  final CategoryRepository _repository = const CategoryRepository();

  @override
  CustomCategoryState build() {
    _loadSavedCategories();
    final gameMode = ref.read(gameProvider).gameMode;
    return CustomCategoryState(type: gameMode);
  }

  /// بارگذاری دسته‌های سفارشی ذخیره‌شده
  Future<void> _loadSavedCategories() async {
    try {
      final isar = await ref.read(isarProvider.future);
      final categories = await _repository.getCustomCategories(isar: isar);
      final items = categories
          .map(
            (category) => CustomCategorySelectorItem(
              id: category.id,
              name: category.name,
              wordCount: category.wordCount,
            ),
          )
          .toList();

      if (!ref.mounted) return;
      state = state.copyWith(savedCategories: items);
    } catch (e, stackTrace) {
      appLogger.e('Failed to load custom categories', e, stackTrace);
    }
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
    if (state.words.length <= GameConfig.minCustomCategoryWords) return;
    final words = List<String>.from(state.words)..removeAt(index);
    state = state.copyWith(words: words);
  }

  /// انتخاب دسته برای ویرایش
  Future<void> selectCategory(int? categoryId) async {
    if (categoryId == null) {
      state = state.copyWith(clearSelectedCategory: true);
      return;
    }

    try {
      final isar = await ref.read(isarProvider.future);
      final category = await isar.wordCategorys.get(categoryId);
      if (category == null || category.isDefault || !ref.mounted) return;

      final words = await _repository.getWordsForCategory(
        isar: isar,
        categoryId: categoryId,
      );
      final editableWords = _normalizeWordsForForm(words);

      state = state.copyWith(
        selectedCategoryId: categoryId,
        name: category.name,
        type: category.type,
        words: editableWords,
        loadedCategoryType: category.type,
      );
    } catch (e, stackTrace) {
      appLogger.e('Failed to select custom category', e, stackTrace);
    }
  }

  /// شروع ساخت دسته جدید
  void createNewCategory() {
    final gameMode = ref.read(gameProvider).gameMode;
    state = CustomCategoryState(
      type: gameMode,
      savedCategories: state.savedCategories,
    );
  }

  /// حذف دسته انتخاب‌شده
  Future<bool> deleteSelectedCategory() async {
    final categoryId = state.selectedCategoryId;
    if (categoryId == null) return false;

    try {
      final isar = await ref.read(isarProvider.future);
      final category = await isar.wordCategorys.get(categoryId);
      final categoryType = category?.type;
      final success = await _repository.deleteCustomCategory(
        isar: isar,
        categoryId: categoryId,
      );

      if (success && ref.mounted) {
        ref.read(gameProvider.notifier).removeCategoryFromSelection(categoryId);
        if (categoryType != null) {
          ref.invalidate(categoriesByTypeProvider(categoryType));
        }
        createNewCategory();
        await _loadSavedCategories();
      }

      return success;
    } catch (e, stackTrace) {
      appLogger.e('Failed to delete custom category', e, stackTrace);
      return false;
    }
  }

  /// ذخیره یا به‌روزرسانی دسته سفارشی در Isar
  Future<({CustomCategorySaveResult result, WordCategory? category})> save() async {
    if (state.name.trim().isEmpty) {
      return (result: CustomCategorySaveResult.missingName, category: null);
    }
    if (state.validWordCount < GameConfig.minCustomCategoryWords) {
      return (result: CustomCategorySaveResult.missingWords, category: null);
    }

    state = state.copyWith(isSaving: true);
    try {
      final isar = await ref.read(isarProvider.future);
      final bool isEditing = state.isEditing;
      final previousType = state.loadedCategoryType;

      final WordCategory? category;
      if (isEditing) {
        category = await _repository.updateCustomCategory(
          isar: isar,
          categoryId: state.selectedCategoryId!,
          name: state.name,
          type: state.type,
          words: state.words,
        );
      } else {
        category = await _repository.createCustomCategory(
          isar: isar,
          name: state.name,
          type: state.type,
          words: state.words,
        );
      }

      if (category != null) {
        _invalidateCategoryLists(previousType, state.type);
        ref.read(gameProvider.notifier).syncGameMode(state.type);

        final game = ref.read(gameProvider);
        if (!game.selectedCategoryIds.contains(category.id)) {
          ref.read(gameProvider.notifier).toggleCategory(category.id);
        }

        if (isEditing) {
          state = state.copyWith(
            selectedCategoryId: category.id,
            loadedCategoryType: category.type,
          );
          await _loadSavedCategories();
          return (result: CustomCategorySaveResult.updated, category: category);
        }

        await _loadSavedCategories();
        return (result: CustomCategorySaveResult.success, category: category);
      }

      return (result: CustomCategorySaveResult.failed, category: null);
    } catch (e, stackTrace) {
      appLogger.e('Failed to save custom category', e, stackTrace);
      return (result: CustomCategorySaveResult.failed, category: null);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }

  void _invalidateCategoryLists(CategoryType? previousType, CategoryType currentType) {
    ref.invalidate(categoriesByTypeProvider(currentType));
    if (previousType != null && previousType != currentType) {
      ref.invalidate(categoriesByTypeProvider(previousType));
    }
  }

  List<String> _normalizeWordsForForm(List<String> words) {
    if (words.length >= GameConfig.minCustomCategoryWords) {
      return List<String>.from(words);
    }

    return [
      ...words,
      ...List.filled(
        GameConfig.minCustomCategoryWords - words.length,
        '',
      ),
    ];
  }
}
