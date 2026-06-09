import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';

/// انتخابگر گروه ذخیره‌شده — باز شدن از پایین با لیست جذاب
class GroupSelector extends StatelessWidget {
  const GroupSelector({
    super.key,
    required this.groups,
    required this.selectedGroupId,
    required this.onChanged,
    this.onCreateNew,
    this.onDelete,
  });

  final List<GroupSelectorItem> groups;
  final int? selectedGroupId;
  final ValueChanged<int?> onChanged;
  final VoidCallback? onCreateNew;
  final VoidCallback? onDelete;

  GroupSelectorItem? get _selectedGroup {
    if (selectedGroupId == null) return null;
    for (final group in groups) {
      if (group.id == selectedGroupId) return group;
    }
    return null;
  }

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<int?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => _GroupPickerSheet(
        groups: groups,
        selectedGroupId: selectedGroupId,
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
    final selected = _selectedGroup;

    return AppCard(
      borderColor: AppColors.accentDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'player_setup.saved_groups'.tr(),
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
                              color: AppColors.accentDefault
                                  .withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.groups_outlined,
                              color: AppColors.accentDefault,
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
                                      'player_setup.select_group'.tr(),
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
                                    'player_setup.players_count'.tr(
                                      args: [
                                        selected.playerCount.toString(),
                                      ],
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
                        semanticLabel: 'player_setup.delete_group'.tr(),
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

class _GroupPickerSheet extends StatelessWidget {
  const _GroupPickerSheet({
    required this.groups,
    required this.selectedGroupId,
    required this.showCreateNew,
  });

  final List<GroupSelectorItem> groups;
  final int? selectedGroupId;
  final bool showCreateNew;

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
                    color: AppColors.accentDefault,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'player_setup.saved_groups'.tr(),
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
                itemCount: groups.length + (showCreateNew ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  if (showCreateNew && index == 0) {
                    return _PickerTile(
                      title: 'player_setup.new_group'.tr(),
                      subtitle: 'player_setup.new_group_hint'.tr(),
                      icon: Icons.add_circle_outline,
                      accentColor: AppColors.accentDefault,
                      onTap: () => Navigator.pop(context, -1),
                    );
                  }

                  final groupIndex = showCreateNew ? index - 1 : index;
                  final group = groups[groupIndex];
                  final isSelected = group.id == selectedGroupId;
                  final initial = group.name.isNotEmpty
                      ? group.name.substring(0, 1).toUpperCase()
                      : '?';

                  return _PickerTile(
                    title: group.name,
                    subtitle: 'player_setup.players_count'.tr(
                      args: [group.playerCount.toString()],
                    ),
                    icon: null,
                    avatarLabel: initial,
                    accentColor: AppColors.accentDefault,
                    isSelected: isSelected,
                    onTap: () => Navigator.pop(context, group.id),
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
    required this.accentColor,
    this.icon,
    this.avatarLabel,
    this.isSelected = false,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accentColor;
  final IconData? icon;
  final String? avatarLabel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? accentColor.withValues(alpha: 0.12)
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
              color: isSelected ? accentColor : AppColors.cardBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              if (avatarLabel != null)
                CircleAvatar(
                  radius: 18,
                  backgroundColor: accentColor.withValues(alpha: 0.2),
                  child: Text(
                    avatarLabel!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                )
              else
                Icon(icon, color: accentColor, size: 28),
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
                  color: AppColors.accentDefault,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// مدل ساده برای آیتم گروه در selector
class GroupSelectorItem {
  const GroupSelectorItem({
    required this.id,
    required this.name,
    this.playerCount = 0,
  });

  final int id;
  final String name;
  final int playerCount;
}
