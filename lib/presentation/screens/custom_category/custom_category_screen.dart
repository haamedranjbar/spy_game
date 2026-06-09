import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/presentation/screens/custom_category/custom_category_provider.dart';
import 'package:spy_game/presentation/widgets/app_card.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/outlined_action_button.dart';
import 'package:spy_game/presentation/widgets/segmented_tab.dart';

/// صفحه ساخت دسته‌بندی سفارشی
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
        title: Text('custom_category.title'.tr()),
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
                        TextField(
                          onChanged: notifier.setName,
                          style: Theme.of(context).textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'custom_category.name_hint'.tr(),
                            filled: true,
                            fillColor: AppColors.surfaceLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.cardBorder,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.cardBorder,
                              ),
                            ),
                          ),
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
                  const SizedBox(height: 12),
                  ...List.generate(
                    state.words.length,
                    (index) => _WordInputTile(
                      key: ValueKey('word_$index'),
                      initialValue: state.words[index],
                      index: index + 1,
                      canRemove: state.words.length > 1,
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
                enabled: state.canSave,
                isLoading: state.isSaving,
                onPressed: state.canSave
                    ? () async {
                        final category = await notifier.save();
                        if (!context.mounted) return;
                        if (category != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('custom_category.saved'.tr()),
                            ),
                          );
                          context.pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('error.save_failed'.tr()),
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
