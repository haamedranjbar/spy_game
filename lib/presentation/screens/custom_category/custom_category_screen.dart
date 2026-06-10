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

/// صفحه ساخت و ویرایش دسته‌بندی سفارشی — مشابه تعریف گروه بازیکنان
class CustomCategoryScreen extends ConsumerWidget {
  const CustomCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customCategoryProvider);
    final notifier = ref.read(customCategoryProvider.notifier);
    final canSaveWords =
        state.validWordCount >= GameConfig.minCustomCategoryWords;

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
                    isSaving: state.isSaving,
                    onCategoryChanged: notifier.selectCategory,
                    onCreateNew: notifier.createNewCategory,
                    onSave: () => _onSavePressed(context, ref),
                    onDelete: state.selectedCategoryId != null
                        ? () => _confirmDeleteCategory(context, ref)
                        : null,
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
                    'custom_category.edit_words'.tr(),
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
                          color: canSaveWords
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: AddActionButton(
                      label: 'custom_category.add_word'.tr(),
                      onPressed: notifier.addWord,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RemoveActionButton(
                      label: 'custom_category.remove_word'.tr(),
                      onPressed: state.words.length >
                              GameConfig.minCustomCategoryWords
                          ? () => notifier.removeWord(state.words.length - 1)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GradientButton(
                label: 'common.save'.tr(),
                icon: Icons.save_outlined,
                enabled: canSaveWords && !state.isSaving,
                isLoading: state.isSaving,
                onPressed: canSaveWords && !state.isSaving
                    ? () => _onSavePressed(context, ref)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ذخیره — ابتدا نام در دیالوگ، سپس ثبت در دیتابیس
  Future<void> _onSavePressed(BuildContext context, WidgetRef ref) async {
    final state = ref.read(customCategoryProvider);
    final notifier = ref.read(customCategoryProvider.notifier);

    if (state.validWordCount < GameConfig.minCustomCategoryWords) {
      AppSnackBar.warning(
        context,
        'custom_category.words_required'.tr(
          namedArgs: {
            'min': GameConfig.minCustomCategoryWords.toString(),
          },
        ),
      );
      return;
    }

    final categoryName = await showDialog<String>(
      context: context,
      builder: (_) => _SaveCategoryDialog(initialName: state.name),
    );

    if (categoryName == null || !context.mounted) return;

    notifier.setName(categoryName);
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
    required this.isSaving,
    required this.onCategoryChanged,
    required this.onCreateNew,
    required this.onSave,
    this.onDelete,
  });

  final List<CustomCategorySelectorItem> categories;
  final int? selectedCategoryId;
  final bool isSaving;
  final ValueChanged<int?> onCategoryChanged;
  final VoidCallback onCreateNew;
  final VoidCallback onSave;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (categories.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomCategorySelector(
            categories: categories,
            selectedCategoryId: selectedCategoryId,
            onChanged: onCategoryChanged,
            onCreateNew: onCreateNew,
            onDelete: onDelete,
          ),
          const SizedBox(height: 12),
          OutlinedActionButton(
            label: 'custom_category.save_category'.tr(),
            icon: Icons.save_outlined,
            color: AppColors.accentCustomCategory,
            onPressed: isSaving ? null : onSave,
          ),
        ],
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
          const SizedBox(height: 12),
          OutlinedActionButton(
            label: 'custom_category.save_category'.tr(),
            icon: Icons.save_outlined,
            color: AppColors.accentCustomCategory,
            onPressed: isSaving ? null : onSave,
          ),
        ],
      ),
    );
  }
}

/// دیالوگ نام دسته — مشابه ذخیره گروه بازیکنان
class _SaveCategoryDialog extends StatefulWidget {
  const _SaveCategoryDialog({required this.initialName});

  final String initialName;

  @override
  State<_SaveCategoryDialog> createState() => _SaveCategoryDialogState();
}

class _SaveCategoryDialogState extends State<_SaveCategoryDialog> {
  late final TextEditingController _controller;
  bool _showNameError = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('custom_category.save_category'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            onChanged: (_) {
              if (_showNameError) {
                setState(() => _showNameError = false);
              }
            },
            decoration: InputDecoration(
              hintText: 'custom_category.name_hint'.tr(),
              filled: true,
              fillColor: AppColors.surfaceLight,
              errorText: _showNameError
                  ? 'custom_category.name_required'.tr()
                  : null,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        TextButton(
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isEmpty) {
              setState(() => _showNameError = true);
              return;
            }
            Navigator.pop(context, name);
          },
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }
}

/// کادر ورود کلمه — مشابه کادر نام بازیکن
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                AppColors.accentCustomCategory.withValues(alpha: 0.25),
            child: Text(
              '${widget.index}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.accentCustomCategory,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'custom_category.word_hint'.tr(),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
              ),
            ),
          ),
          if (widget.canRemove) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: widget.onRemove,
              icon: const Icon(Icons.close, size: 20),
              color: AppColors.accentDanger,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ],
      ),
    );
  }
}
