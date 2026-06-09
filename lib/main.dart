import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spy_game/core/router/router.dart';
import 'package:spy_game/core/theme/app_theme.dart';
import 'package:spy_game/presentation/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // راه‌اندازی easy_localization
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('fa'),
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('fa'),
      startLocale: const Locale('fa'),
      child: const ProviderScope(
        child: SpyGameApp(),
      ),
    ),
  );
}

/// ریشه اپلیکیشن
class SpyGameApp extends ConsumerWidget {
  const SpyGameApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // بارگذاری تنظیمات در شروع اپ
    ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'app.name'.tr(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routerConfig: appRouter,
    );
  }
}
