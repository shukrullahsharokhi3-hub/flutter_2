import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/widgets/factory_logo.dart';
import '../../../l10n/generated/app_localizations.dart';

/// The first screen shown by the app while the product is starting.
///
/// This screen is presentation-only: it does not call a server or navigate
/// automatically. The user chooses when to continue to the login screen.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // LayoutBuilder makes the composition adapt to both narrow phones and
        // wide browser windows without hard-coding device-specific sizes.
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            final horizontalPadding = isWide ? 48.0 : 24.0;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  const Spacer(),
                  Center(
                    child: ConstrainedBox(
                      // A maximum width keeps text and branding balanced on
                      // large screens instead of stretching across the page.
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FactoryLogo(
                            size: 112,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            accentColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            accentIconColor: AppColors.mainText,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            AppLocalizations.of(context)!.appName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: isWide ? 34 : 30,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.7,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(context)!.factoryName,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.mutedText,
                                      height: 1.45,
                                    ),
                          ),
                          const SizedBox(height: 22),
                          Container(
                            width: 42,
                            height: 3,
                            decoration: BoxDecoration(
                              // Follow the active theme's pale accent on both locales.
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: SizedBox(
                      width: isWide ? 220 : double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RouteNames.login,
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: Text(AppLocalizations.of(context)!.continueLabel),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
