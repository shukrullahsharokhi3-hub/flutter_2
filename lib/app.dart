import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localization/locale_controller.dart';
import 'core/routing/app_router.dart';
import 'core/routing/route_names.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';

class GFMSApp extends StatefulWidget {
  const GFMSApp({super.key});

  @override
  State<GFMSApp> createState() => _GFMSAppState();
}

class _GFMSAppState extends State<GFMSApp> {
  final _localeController = LocaleController();

  @override
  void initState() {
    super.initState();
    _localeController.load();
  }

  @override
  void dispose() {
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _localeController,
        builder: (context, _) => MaterialApp(
          title: 'GFMS',
          debugShowCheckedModeBanner: false,
          // The same locale state switches both translations/direction and palette.
          theme: AppTheme.forLocale(_localeController.locale),
          locale: _localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: RouteNames.splash,
          onGenerateRoute: (settings) => AppRouter.onGenerateRoute(
            settings,
            localeController: _localeController,
          ),
        ),
      );
}
