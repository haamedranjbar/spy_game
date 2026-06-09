import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spy_game/presentation/screens/home/home_screen.dart';
import 'package:spy_game/presentation/screens/splash/splash_screen.dart';

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
