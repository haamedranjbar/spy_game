import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';

/// dropdown انتخاب گروه ذخیره‌شده
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

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderColor: AppColors.accentDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'player_setup.saved_groups'.tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int?>(
                  initialValue: selectedGroupId,
                  decoration: InputDecoration(
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  dropdownColor: AppColors.surfaceLight,
                  hint: Text('player_setup.select_group'.tr()),
                  items: [
                    ...groups.map(
                      (group) => DropdownMenuItem<int?>(
                        value: group.id,
                        child: Text(group.name),
                      ),
                    ),
                    if (onCreateNew != null)
                      DropdownMenuItem<int?>(
                        value: -1,
                        child: Text('player_setup.new_group'.tr()),
                      ),
                  ],
                  onChanged: (value) {
                    if (value == -1) {
                      onCreateNew?.call();
                    } else {
                      onChanged(value);
                    }
                  },
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.accentDanger,
                  tooltip: 'player_setup.delete_group'.tr(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// مدل ساده برای آیتم گروه در selector
class GroupSelectorItem {
  const GroupSelectorItem({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
}
