import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'locale_controller.dart';
import '../../l10n/generated/app_localizations.dart';

/// Dashboard header control backed by the app-wide locale controller.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({required this.controller, super.key});

  final LocaleController controller;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
        tooltip: AppLocalizations.of(context)!.changeLanguage,
        // Match the selector's compact header button to the dashboard actions.
        style: IconButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: AppColors.cardBackground,
          side: const BorderSide(color: AppColors.border),
        ),
        icon: const Icon(Icons.language_rounded),
        onSelected: (language) => controller.setLocale(
          Locale(language, language == 'fa' ? 'AF' : null),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'en',
            child: Text(AppLocalizations.of(context)!.languageEnglish),
          ),
          PopupMenuItem(
            value: 'fa',
            child: Text(AppLocalizations.of(context)!.languageDari),
          ),
        ],
      );
}
