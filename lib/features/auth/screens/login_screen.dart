import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/widgets/factory_logo.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Collects the credentials the future backend sign-in flow will need.
///
/// No credentials are sent or saved yet. A valid submission only explains
/// that authentication is waiting for the backend API.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool _passwordIsVisible = false;
  bool _hasSubmittedValidForm = false;

  @override
  void dispose() {
    // Controllers and focus nodes hold resources, so release them with the page.
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  /// Validates the form before opening the development dashboard preview.
  void _handleSignIn() {
    // Normalize the username before validation and before a future API call.
    _usernameController.text = _usernameController.text.trim();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    setState(() => _hasSubmittedValidForm = true);

    // Temporary UI preview only: this is NOT real authentication. Replace
    // this navigation with API-based authentication when the backend is ready.
    Navigator.pushNamed(context, RouteNames.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.signIn)),
      // The scroll view lets the form move above the keyboard on short screens.
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 32 : 24,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  // Limit line length on desktop and tablet browser windows.
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          Center(
                            child: FactoryLogo(
                              size: 76,
                              // White logo marks contrast with the brand fill.
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              accentColor:
                                  Theme.of(context).colorScheme.primaryContainer,
                              accentIconColor: AppColors.white,
                              iconColor: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            AppLocalizations.of(context)!.appName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.mainText,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.factoryName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.secondaryText),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            AppLocalizations.of(context)!.welcomeBack,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppColors.mainText,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.signInHint,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.secondaryText),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _usernameController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            autofillHints: const [AutofillHints.username],
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.username,
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty) {
                                return AppLocalizations.of(context)!.pleaseEnterUsername;
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: !_passwordIsVisible,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.password,
                              prefixIcon: const Icon(Icons.lock_outline),
                              // Keep the visibility control readable on white.
                              suffixIconColor: AppColors.mainText,
                              suffixIcon: IconButton(
                                tooltip: _passwordIsVisible
                                    ? AppLocalizations.of(context)!.hidePassword
                                    : AppLocalizations.of(context)!.showPassword,
                                onPressed: () {
                                  setState(() {
                                    _passwordIsVisible = !_passwordIsVisible;
                                  });
                                },
                                icon: Icon(
                                  _passwordIsVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if ((value ?? '').isEmpty) {
                                return AppLocalizations.of(context)!.pleaseEnterPassword;
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _handleSignIn(),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _handleSignIn,
                              child: Text(AppLocalizations.of(context)!.signIn),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _BackendStatus(
                            hasValidSubmission: _hasSubmittedValidForm,
                          ),
                          const SizedBox(height: 12),
                          // Temporary UI-only navigation for reviewing the
                          // dashboard before real authentication is available.
                          TextButton.icon(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              RouteNames.dashboard,
                            ),
                            icon: const Icon(Icons.dashboard_outlined),
                            label: Text(AppLocalizations.of(context)!.previewDashboard),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.mainText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Explains the current backend limitation without suggesting login succeeded.
class _BackendStatus extends StatelessWidget {
  const _BackendStatus({required this.hasValidSubmission});

  final bool hasValidSubmission;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final message = hasValidSubmission
        ? strings.backendValid
        : strings.backendPending;
    const statusIcon = Icon(
      Icons.info_outline,
      color: AppColors.mainText,
      size: 20,
    );
    final statusMessage = Text(
      message,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.mainText,
            height: 1.4,
          ),
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.2),
            ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Stack the status content when the card is too narrow for its row.
          if (constraints.maxWidth < 240) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                statusIcon,
                const SizedBox(height: 8),
                statusMessage,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              statusIcon,
              const SizedBox(width: 10),
              Expanded(child: statusMessage),
            ],
          );
        },
      ),
    );
  }
}
