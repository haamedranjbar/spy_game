import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/presentation/screens/custom_category/custom_category_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/app_snackbar.dart';
import 'package:spy_game/presentation/widgets/custom_category_selector.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/outlined_action_button.dart';
import 'package:spy_game/presentation/widgets/segmented_tab.dart';

/// صفحه ساخت و ویرایش دسته‌بندی سفارشی
class CustomCategoryScreen extends ConsumerWidget {
  const CustomCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customCategoryProvider);
    final notifier = ref.read(customCategoryProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          state.isEditing
              ? 'custom_category.edit_title'.tr()
              : 'custom_category.title'.tr(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _SavedCategoriesSection(
                    categories: state.savedCategories,
                    selectedCategoryId: state.selectedCategoryId,
                    onCategoryChanged: notifier.selectCategory,
                    onCreateNew: notifier.createNewCategory,
                    onDelete: state.selectedCategoryId != null
                        ? () => _confirmDeleteCategory(context, ref)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'custom_category.name'.tr(),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        _NameInputTile(
                          key: ValueKey('name_${state.selectedCategoryId}'),
                          initialValue: state.name,
                          onChanged: notifier.setName,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SegmentedTab(
                    selectedIndex: state.type == CategoryType.classic ? 0 : 1,
                    onChanged: (index) => notifier.setType(
                      index == 0
                          ? CategoryType.classic
                          : CategoryType.family,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'custom_category.words'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'custom_category.min_words'.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'custom_category.words_progress'.tr(
                      namedArgs: {
                        'current': state.validWordCount.toString(),
                        'min': GameConfig.minCustomCategoryWords.toString(),
                      },
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: state.canSave
                              ? AppColors.accentCustomCategory
                              : AppColors.textMuted,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    state.words.length,
                    (index) => _WordInputTile(
                      key: ValueKey(
                        'word_${state.selectedCategoryId}_$index',
                      ),
                      initialValue: state.words[index],
                      index: index + 1,
                      canRemove: state.words.length >
                          GameConfig.minCustomCategoryWords,
                      onChanged: (value) => notifier.updateWord(index, value),
                      onRemove: () => notifier.removeWord(index),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AddActionButton(
                    label: 'custom_category.add_word'.tr(),
                    onPressed: notifier.addWord,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GradientButton(
                label: 'common.save'.tr(),
                icon: Icons.save_outlined,
                enabled: !state.isSaving,
                isLoading: state.isSaving,
                onPressed: state.isSaving
                    ? null
                    : () => _onSavePressed(context, notifier),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ذخیره دسته و نمایش پیام مناسب بر اساس نتیجه
  Future<void> _onSavePressed(
    BuildContext context,
    CustomCategoryNotifier notifier,
  ) async {
    final saveResult = await notifier.save();
    if (!context.mounted) return;

    switch (saveResult.result) {
      case CustomCategorySaveResult.success:
        AppSnackBar.success(context, 'custom_category.saved'.tr());
        context.pop();
      case CustomCategorySaveResult.updated:
        AppSnackBar.success(context, 'custom_category.updated'.tr());
      case CustomCategorySaveResult.missingName:
        AppSnackBar.warning(context, 'custom_category.name_required'.tr());
      case CustomCategorySaveResult.missingWords:
        AppSnackBar.warning(
          context,
          'custom_category.words_required'.tr(
            namedArgs: {
              'min': GameConfig.minCustomCategoryWords.toString(),
            },
          ),
        );
      case CustomCategorySaveResult.failed:
        AppSnackBar.error(context, 'error.save_failed'.tr());
    }
  }

  Future<void> _confirmDeleteCategory(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('custom_category.delete_category'.tr()),
        content: Text('custom_category.delete_category_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'common.confirm'.tr(),
              style: Theme.of(dialogContext).textTheme.labelLarge?.copyWith(
                    color: AppColors.accentDanger,
                  ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success =
          await ref.read(customCategoryProvider.notifier).deleteSelectedCategory();
      if (!context.mounted) return;
      if (success) {
        AppSnackBar.success(context, 'custom_category.deleted'.tr());
      } else {
        AppSnackBar.error(context, 'error.delete_failed'.tr());
      }
    }
  }
}

/// بخش انتخاب دسته‌های ذخیره‌شده — مشابه گروه‌های نامی
class _SavedCategoriesSection extends StatelessWidget {
  const _SavedCategoriesSection({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    required this.onCreateNew,
    this.onDelete,
  });

  final List<CustomCategorySelectorItem> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategoryChanged;
  final VoidCallback onCreateNew;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (categories.isNotEmpty) {
      return CustomCategorySelector(
        categories: categories,
        selectedCategoryId: selectedCategoryId,
        onChanged: onCategoryChanged,
        onCreateNew: onCreateNew,
        onDelete: onDelete,
      );
    }

    return AppCard(
      borderColor: AppColors.accentCustomCategory,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'custom_category.saved_categories'.tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'custom_category.no_saved_categories'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _NameInputTile extends StatefulWidget {
  const _NameInputTile({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<_NameInputTile> createState() => _NameInputTileState();
}

class _NameInputTileState extends State<_NameInputTile> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _NameInputTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: 'custom_category.name_hint'.tr(),
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
    );
  }
}

class _WordInputTile extends StatefulWidget {
  const _WordInputTile({
    super.key,
    required this.initialValue,
    required this.index,
    required this.onChanged,
    required this.onRemove,
    this.canRemove = true,
  });

  final String initialValue;
  final int index;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;
  final bool canRemove;

  @override
  State<_WordInputTile> createState() => _WordInputTileState();
}

class _WordInputTileState extends State<_WordInputTile> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _WordInputTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Text(
            '${widget.index}.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'custom_category.word_hint'.tr(),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (widget.canRemove)
            IconButton(
              onPressed: widget.onRemove,
              icon: const Icon(Icons.close, size: 20),
              color: AppColors.accentDanger,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
