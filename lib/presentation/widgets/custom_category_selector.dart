import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';

/// آیتم دسته سفارشی در selector
class CustomCategorySelectorItem {
  const CustomCategorySelectorItem({
    required this.id,
    required this.name,
    required this.wordCount,
  });

  final int id;
  final String name;
  final int wordCount;
}

/// انتخابگر دسته سفارشی ذخیره‌شده — مشابه GroupSelector
class CustomCategorySelector extends StatelessWidget {
  const CustomCategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onChanged,
    this.onCreateNew,
    this.onDelete,
  });

  final List<CustomCategorySelectorItem> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onChanged;
  final VoidCallback? onCreateNew;
  final VoidCallback? onDelete;

  static const Color _accent = AppColors.accentCustomCategory;

  CustomCategorySelectorItem? get _selectedCategory {
    if (selectedCategoryId == null) return null;
    for (final category in categories) {
      if (category.id == selectedCategoryId) return category;
    }
    return null;
  }

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<int?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => _CategoryPickerSheet(
        categories: categories,
        selectedCategoryId: selectedCategoryId,
        showCreateNew: onCreateNew != null,
      ),
    );

    if (result == null) return;
    if (result == -1) {
      onCreateNew?.call();
    } else {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedCategory;

    return AppCard(
      borderColor: _accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'custom_category.saved_categories'.tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () => _openPicker(context),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _accent.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.folder_special_outlined,
                              color: _accent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selected?.name ??
                                      'custom_category.select_category'.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: selected != null
                                            ? AppColors.textPrimary
                                            : AppColors.textMuted,
                                        fontWeight: selected != null
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (selected != null)
                                  Text(
                                    'category.word_count'.tr(
                                      args: [selected.wordCount.toString()],
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.expand_more_rounded,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                Material(
                  color: AppColors.accentDanger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.delete_outline,
                        color: AppColors.accentDanger,
                        semanticLabel: 'custom_category.delete_category'.tr(),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryPickerSheet extends StatelessWidget {
  const _CategoryPickerSheet({
    required this.categories,
    required this.selectedCategoryId,
    required this.showCreateNew,
  });

  final List<CustomCategorySelectorItem> categories;
  final int? selectedCategoryId;
  final bool showCreateNew;

  static const Color _accent = AppColors.accentCustomCategory;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.folder_special_outlined,
                    color: _accent,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'custom_category.saved_categories'.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.45,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                itemCount: categories.length + (showCreateNew ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  if (showCreateNew && index == 0) {
                    return _PickerTile(
                      title: 'custom_category.new_category'.tr(),
                      subtitle: 'custom_category.new_category_hint'.tr(),
                      icon: Icons.add_circle_outline,
                      onTap: () => Navigator.pop(context, -1),
                    );
                  }

                  final categoryIndex = showCreateNew ? index - 1 : index;
                  final category = categories[categoryIndex];
                  final isSelected = category.id == selectedCategoryId;
                  final initial = category.name.isNotEmpty
                      ? category.name.substring(0, 1).toUpperCase()
                      : '?';

                  return _PickerTile(
                    title: category.name,
                    subtitle: 'category.word_count'.tr(
                      args: [category.wordCount.toString()],
                    ),
                    avatarLabel: initial,
                    isSelected: isSelected,
                    onTap: () => Navigator.pop(context, category.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon,
    this.avatarLabel,
    this.isSelected = false,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData? icon;
  final String? avatarLabel;
  final bool isSelected;

  static const Color _accent = AppColors.accentCustomCategory;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? _accent.withValues(alpha: 0.12)
          : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? _accent : AppColors.cardBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              if (avatarLabel != null)
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _accent.withValues(alpha: 0.2),
                  child: Text(
                    avatarLabel!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _accent,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                )
              else
                Icon(icon, color: _accent, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: _accent,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
