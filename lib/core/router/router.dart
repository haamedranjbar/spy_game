import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/presentation/screens/about/about_screen.dart';
import 'package:spy_game/presentation/screens/categories/categories_screen.dart';
import 'package:spy_game/presentation/screens/custom_category/custom_category_screen.dart';
import 'package:spy_game/presentation/screens/game_config/game_config_screen.dart';
import 'package:spy_game/presentation/screens/home/home_screen.dart';
import 'package:spy_game/presentation/screens/investigation/investigation_screen.dart';
import 'package:spy_game/presentation/screens/player_setup/player_setup_screen.dart';
import 'package:spy_game/presentation/screens/result/result_screen.dart';
import 'package:spy_game/presentation/screens/rules/rules_screen.dart';
import 'package:spy_game/presentation/screens/settings/settings_screen.dart';
import 'package:spy_game/presentation/screens/splash/splash_screen.dart';
import 'package:spy_game/presentation/screens/timer/timer_screen.dart';
import 'package:spy_game/presentation/screens/voting/voting_screen.dart';
import 'package:spy_game/presentation/screens/word_reveal/word_reveal_screen.dart';

/// مسیرهای اپلیکیشن
abstract final class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String categories = '/categories';
  static const String rules = '/rules';
  static const String about = '/about';
  static const String iap = '/iap';
  static const String playerSetup = '/player-setup';
  static const String gameConfig = '/game-config';
  static const String wordReveal = '/word-reveal';
  static const String timer = '/timer';
  static const String investigation = '/investigation';
  static const String voting = '/voting';
  static const String result = '/result';
  static const String customCategory = '/custom-category';

  /// مسیر تنظیم بازیکنان در شروع بازی جدید
  static const String playerSetupNewGame = '$playerSetup?next=categories';
}

/// پیکربندی go_router
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const SplashScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.rules,
      name: 'rules',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const RulesScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.about,
      name: 'about',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const AboutScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.categories,
      name: 'categories',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const CategoriesScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.playerSetup,
      name: 'playerSetup',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const PlayerSetupScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.gameConfig,
      name: 'gameConfig',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const GameConfigScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.customCategory,
      name: 'customCategory',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const CustomCategoryScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.wordReveal,
      name: 'wordReveal',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const WordRevealScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.timer,
      name: 'timer',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const TimerScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.investigation,
      name: 'investigation',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const InvestigationScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.voting,
      name: 'voting',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const VotingScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.result,
      name: 'result',
      pageBuilder: (context, state) => _fadePage(
        state: state,
        child: const ResultScreen(),
      ),
    ),
  ],
);

/// انیمیشن fade بین صفحات
CustomTransitionPage<void> _fadePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
