import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/constants/game_config.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/presentation/screens/player_setup/player_setup_provider.dart';
import 'package:spy_game/presentation/widgets/counter_card.dart';
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
                  if (setupState.groups.isNotEmpty)
                    GroupSelector(
                      groups: setupState.groups,
                      selectedGroupId: setupState.selectedGroupId,
                      onChanged: notifier.selectGroup,
                      onCreateNew: notifier.createNewGroup,
                    ),
                  if (setupState.groups.isNotEmpty) const SizedBox(height: 16),
                  CounterCard(
                    title: 'player_setup.players'.tr(),
                    value: setupState.playerCount,
                    icon: Icons.people_outline,
                    accentColor: AppColors.accentDefault,
                    minValue: GameConfig.minPlayers,
                    maxValue: GameConfig.maxPlayers,
                    onIncrement: notifier.addPlayer,
                    onDecrement: notifier.removePlayer,
                  ),
                  const SizedBox(height: 20),
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
                      key: ValueKey('player_${setupState.playerNames[index]}_$index'),
                      name: setupState.playerNames[index],
                      index: index + 1,
                      onNameChanged: (value) =>
                          notifier.updatePlayerName(index, value),
                      onRemove: setupState.playerCount > GameConfig.minPlayers
                          ? () => notifier.removePlayerAt(index)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AddActionButton(
                          label: 'player_setup.add_player'.tr(),
                          onPressed: setupState.playerCount <
                                  GameConfig.maxPlayers
                              ? notifier.addPlayer
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RemoveActionButton(
                          label: 'player_setup.remove_player'.tr(),
                          onPressed: setupState.playerCount >
                                  GameConfig.minPlayers
                              ? notifier.removePlayer
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GradientButton(
                label: 'player_setup.start'.tr(),
                icon: Icons.play_arrow_rounded,
                enabled: setupState.canContinue,
                isLoading: setupState.isStarting,
                onPressed: setupState.canContinue
                    ? () async {
                        final started = await notifier.startGame();
                        if (!context.mounted) return;
                        if (started) {
                          context.go(AppRoutes.wordReveal);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('error.start_game'.tr()),
                            ),
                          );
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.accentDefault.withValues(alpha: 0.25),
            child: Text(
              initial,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.accentDefault,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onNameChanged,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Text(
            '#${widget.index}',
            style: Theme.of(context).textTheme.bodySmall,
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
