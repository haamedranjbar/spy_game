import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/presentation/screens/player_setup/player_setup_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/group_selector.dart';
import 'package:spy_game/presentation/widgets/outlined_action_button.dart';

/// صفحه ورود اسامی بازیکنان
class PlayerSetupScreen extends ConsumerWidget {
  const PlayerSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(playerSetupProvider);
    final notifier = ref.read(playerSetupProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('player_setup.title'.tr()),
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
                  _SavedGroupsSection(
                    groups: setupState.groups,
                    selectedGroupId: setupState.selectedGroupId,
                    isSaving: setupState.isSaving,
                    onGroupChanged: notifier.selectGroup,
                    onCreateNew: notifier.createNewGroup,
                    onDelete: setupState.selectedGroupId != null
                        ? () => _confirmDeleteGroup(context, ref)
                        : null,
                    onSave: () => _showSaveGroupDialog(context, ref),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'player_setup.edit_names'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    setupState.playerNames.length,
                    (index) => _EditablePlayerTile(
                      // کلید پایدار — تغییر نام نباید ویجت را از نو بسازد
                      key: ValueKey('player_$index'),
                      name: setupState.playerNames[index],
                      index: index + 1,
                      onNameChanged: (value) =>
                          notifier.updatePlayerName(index, value),
                      onRemove: setupState.playerCount > GameConfig.minPlayers
                          ? () => notifier.removePlayerAt(index)
                          : null,
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
                      label: 'player_setup.add_player'.tr(),
                      onPressed: setupState.playerCount < GameConfig.maxPlayers
                          ? notifier.addPlayer
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RemoveActionButton(
                      label: 'player_setup.remove_player'.tr(),
                      onPressed: setupState.playerCount > GameConfig.minPlayers
                          ? notifier.removePlayer
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GradientButton(
                label: 'common.done'.tr(),
                icon: Icons.check_rounded,
                enabled: setupState.canContinue,
                onPressed: setupState.canContinue
                    ? () {
                        notifier.applyToGame();
                        context.pop();
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSaveGroupDialog(BuildContext context, WidgetRef ref) async {
    final setupState = ref.read(playerSetupProvider);
    final notifier = ref.read(playerSetupProvider.notifier);
    final controller = TextEditingController(
      text: setupState.selectedGroupId != null
          ? setupState.groups
              .where((g) => g.id == setupState.selectedGroupId)
              .map((g) => g.name)
              .firstOrNull
          : '',
    );

    var showNameError = false;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('player_setup.save_group'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                onChanged: (_) {
                  if (showNameError) {
                    setDialogState(() => showNameError = false);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'player_setup.group_name'.tr(),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  errorText: showNameError
                      ? 'player_setup.group_name_required'.tr()
                      : null,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text('common.cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) {
                  setDialogState(() => showNameError = true);
                  return;
                }
                Navigator.pop(dialogContext, true);
              },
              child: Text('common.save'.tr()),
            ),
          ],
        ),
      ),
    );

    if (saved == true && context.mounted) {
      final success =
          await notifier.saveCurrentGroup(controller.text.trim());
      controller.dispose();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'player_setup.group_saved'.tr()
                : 'error.save_failed'.tr(),
          ),
        ),
      );
    } else {
      controller.dispose();
    }
  }

  Future<void> _confirmDeleteGroup(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('player_setup.delete_group'.tr()),
        content: Text('player_setup.delete_group_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'common.confirm'.tr(),
              style: const TextStyle(color: AppColors.accentDanger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success =
          await ref.read(playerSetupProvider.notifier).deleteSelectedGroup();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'player_setup.group_deleted'.tr()
                : 'error.delete_failed'.tr(),
          ),
        ),
      );
    }
  }
}

/// بخش بارگذاری و ذخیره گروه‌های اسامی — همیشه در بالای صفحه نمایش داده می‌شود
class _SavedGroupsSection extends StatelessWidget {
  const _SavedGroupsSection({
    required this.groups,
    required this.selectedGroupId,
    required this.isSaving,
    required this.onGroupChanged,
    required this.onCreateNew,
    required this.onSave,
    this.onDelete,
  });

  final List<GroupSelectorItem> groups;
  final int? selectedGroupId;
  final bool isSaving;
  final ValueChanged<int?> onGroupChanged;
  final VoidCallback onCreateNew;
  final VoidCallback onSave;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (groups.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GroupSelector(
            groups: groups,
            selectedGroupId: selectedGroupId,
            onChanged: onGroupChanged,
            onCreateNew: onCreateNew,
            onDelete: onDelete,
          ),
          const SizedBox(height: 12),
          OutlinedActionButton(
            label: 'player_setup.save_group'.tr(),
            icon: Icons.save_outlined,
            color: AppColors.accentDefault,
            onPressed: isSaving ? null : onSave,
          ),
        ],
      );
    }

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
          const SizedBox(height: 8),
          Text(
            'player_setup.no_saved_groups'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          OutlinedActionButton(
            label: 'player_setup.save_group'.tr(),
            icon: Icons.save_outlined,
            color: AppColors.accentDefault,
            onPressed: isSaving ? null : onSave,
          ),
        ],
      ),
    );
  }
}

class _EditablePlayerTile extends StatefulWidget {
  const _EditablePlayerTile({
    super.key,
    required this.name,
    required this.index,
    required this.onNameChanged,
    this.onRemove,
  });

  final String name;
  final int index;
  final ValueChanged<String> onNameChanged;
  final VoidCallback? onRemove;

  @override
  State<_EditablePlayerTile> createState() => _EditablePlayerTileState();
}

class _EditablePlayerTileState extends State<_EditablePlayerTile> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
  }

  @override
  void didUpdateWidget(covariant _EditablePlayerTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name && _controller.text != widget.name) {
      _controller.text = widget.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.name.isNotEmpty
        ? widget.name.substring(0, 1).toUpperCase()
        : '?';

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
            backgroundColor: AppColors.accentDefault.withValues(alpha: 0.25),
            child: Text(
              initial,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.accentDefault,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onNameChanged,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.start,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(
              '#${widget.index}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
          ),
          if (widget.onRemove != null) ...[
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
