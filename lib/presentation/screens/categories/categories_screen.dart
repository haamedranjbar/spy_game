import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/core/constants/app_colors.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/core/utils/category_icon.dart';
import 'package:spy_game/core/utils/category_name.dart';
import 'package:spy_game/data/models/word_category.dart';
import 'package:spy_game/presentation/providers/category_provider.dart';
import 'package:spy_game/presentation/providers/game_provider.dart';
import 'package:spy_game/presentation/screens/categories/categories_provider.dart';
import 'package:spy_game/presentation/screens/player_setup/player_setup_provider.dart';
import 'package:spy_game/presentation/widgets/category_card.dart';
import 'package:spy_game/presentation/widgets/create_custom_card.dart';
import 'package:spy_game/presentation/widgets/family_mode_banner.dart';
import 'package:spy_game/presentation/widgets/gradient_button.dart';
import 'package:spy_game/presentation/widgets/segmented_tab.dart';

/// صفحه انتخاب دسته‌بندی — Classic / Family
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(categoriesProvider);
    final gameState = ref.watch(gameProvider);
    final categoriesAsync = ref.watch(
      categoriesByTypeProvider(uiState.categoryType),
    );
    final accentColor = uiState.modeIndex == 0
        ? AppColors.accentClassic
        : AppColors.accentFamily;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('categories.title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SegmentedTab(
                selectedIndex: uiState.modeIndex,
                onChanged: ref
                    .read(categoriesProvider.notifier)
                    .setModeIndex,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: categoriesAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accentDefault,
                  ),
                ),
                error: (_, __) => Center(
                  child: Text('error.database_init'.tr()),
                ),
                data: (categories) => _CategoryGrid(
                  categories: categories,
                  selectedIds: gameState.selectedCategoryIds,
                  accentColor: accentColor,
                  isFamilyMode: uiState.modeIndex == 1,
                  showColorImages: gameState.showColorImages,
                  onShowColorImagesChanged: (value) => ref
                      .read(gameProvider.notifier)
                      .setShowColorImages(value),
                  onCategoryTap: (category) {
                    if (category.isPremium) {
                      _showLockedSnackBar(context);
                      return;
                    }
                    ref
                        .read(categoriesProvider.notifier)
                        .toggleCategory(category, isGoldenUser: false);
                  },
                  onCreateCustom: () =>
                      context.push(AppRoutes.customCategory),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GradientButton(
                label: 'categories.continue'.tr(),
                icon: Icons.arrow_forward_rounded,
                gradientColors: uiState.modeIndex == 0
                    ? AppColors.gradientPurple
                    : AppColors.gradientFamily,
                enabled: gameState.selectedCategoryIds.isNotEmpty,
                isLoading: uiState.isLoadingNext,
                onPressed: gameState.selectedCategoryIds.isEmpty
                    ? null
                    : () {
                        ref
                            .read(playerSetupProvider.notifier)
                            .syncDefaultsToGameIfEmpty();
                        context.push(AppRoutes.gameConfig);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLockedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('categories.locked_premium'.tr()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.categories,
    required this.selectedIds,
    required this.accentColor,
    required this.isFamilyMode,
    required this.showColorImages,
    required this.onShowColorImagesChanged,
    required this.onCategoryTap,
    required this.onCreateCustom,
  });

  final List<WordCategory> categories;
  final List<int> selectedIds;
  final Color accentColor;
  final bool isFamilyMode;
  final bool showColorImages;
  final ValueChanged<bool> onShowColorImagesChanged;
  final ValueChanged<WordCategory> onCategoryTap;
  final VoidCallback onCreateCustom;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (isFamilyMode)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: FamilyModeBanner(
                showColorImages: showColorImages,
                onShowColorImagesChanged: onShowColorImagesChanged,
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == categories.length) {
                  return CreateCustomCard(onTap: onCreateCustom);
                }

                final category = categories[index];
                return CategoryCard(
                  name: localizedCategoryName(
                    category,
                    context.locale,
                  ),
                  wordCount: category.wordCount,
                  isPremium: category.isPremium,
                  isUnlockedByAd: category.isUnlockedByAd,
                  isSelected: selectedIds.contains(category.id),
                  accentColor: accentColor,
                  icon: categoryIconFromName(category.iconName),
                  onTap: () => onCategoryTap(category),
                );
              },
              childCount: categories.length + 1,
            ),
          ),
        ),
      ],
    );
  }
}
