import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_selector.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/routing/route_names.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Shows the Cutting workspace while its backend contract is being prepared.
class CuttingScreen extends StatefulWidget {
  const CuttingScreen({required this.localeController, super.key});

  final LocaleController localeController;

  @override
  State<CuttingScreen> createState() => _CuttingScreenState();
}

class _CuttingScreenState extends State<CuttingScreen> {
  // There is no confirmed endpoint yet, so this screen deliberately has no
  // local records and never represents demo data as server data.
  final _searchController = TextEditingController();
  bool _notConnected = true;

  static const _pageBackground = Color(0xFFF3F6FA);
  static const _navy = Color(0xFF172334);
  static const _muted = Color(0xFF697586);
  static const _border = Color(0xFFDCE3EB);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            title: Text(strings.cutting),
            leading: IconButton(
              tooltip: strings.backToDashboard,
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            actions: compact
                ? [
                    LanguageSelector(controller: widget.localeController),
                    IconButton(
                      tooltip: strings.logout,
                      onPressed: _logout,
                      icon: const Icon(Icons.logout_rounded),
                    ),
                    const SizedBox(width: 4),
                  ]
                : [
                    _userIdentity(strings),
                    const SizedBox(width: 10),
                    LanguageSelector(controller: widget.localeController),
                    const SizedBox(width: 4),
                    TextButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: Text(strings.logout),
                    ),
                    const SizedBox(width: 12),
                  ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(compact ? 16 : 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (compact) ...[
                      _userIdentity(strings, compact: true),
                      const SizedBox(height: 20),
                    ],
                    _pageHeading(strings, compact),
                    const SizedBox(height: 20),
                    _filterPanel(strings, compact),
                    const SizedBox(height: 18),
                    if (_notConnected) _connectionState(strings, compact),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Keeps the user's identity in the app bar on wide layouts and below it on
  /// phone layouts so the title, language control, and logout never collide.
  Widget _userIdentity(AppLocalizations strings, {bool compact = false}) {
    final identity = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            'M-Ali',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _navy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF0F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            strings.managerRole,
            style: const TextStyle(
              color: _navy,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );

    if (compact) {
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: identity,
      );
    }
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8),
      child: identity,
    );
  }

  /// Adds the small operations eyebrow and keeps Refresh visible but inactive
  /// until a real Cutting data source is configured.
  Widget _pageHeading(AppLocalizations strings, bool compact) => Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 12,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: compact ? 340 : 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.factoryOperations.toUpperCase(),
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  strings.cutting,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  strings.cuttingSubtitle,
                  style: const TextStyle(color: _muted, height: 1.35),
                ),
              ],
            ),
          ),
          Tooltip(
            message: strings.cuttingNotConnectedExplanation,
            child: compact
                ? IconButton.outlined(
                    onPressed: null,
                    tooltip: strings.refresh,
                    icon: const Icon(Icons.refresh_rounded),
                  )
                : OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(strings.refresh),
                  ),
          ),
        ],
      );

  /// Controls stay visible for the intended workflow, but remain disabled
  /// because no records or valid filter choices can be loaded yet.
  Widget _filterPanel(AppLocalizations strings, bool compact) => Container(
        padding: EdgeInsets.all(compact ? 14 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A172334),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 440;
                final search = TextField(
                  controller: _searchController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: strings.searchCutting,
                    hintText: strings.searchCuttingPlaceholder,
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: _inputBorder(),
                    enabledBorder: _inputBorder(),
                    disabledBorder: _inputBorder(),
                  ),
                );
                final status = _filterDropdown(
                  label: strings.cuttingStatusLabel,
                  value: strings.allStatuses,
                );
                final source = _filterDropdown(
                  label: strings.sourceLabel,
                  value: strings.allSources,
                );

                if (compact || narrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      search,
                      const SizedBox(height: 12),
                      if (narrow) ...[
                        status,
                        const SizedBox(height: 12),
                        source,
                      ] else
                        Row(children: [
                          Expanded(child: status),
                          const SizedBox(width: 10),
                          Expanded(child: source),
                        ]),
                    ],
                  );
                }
                return Row(children: [
                  Expanded(flex: 5, child: search),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: status),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: source),
                ]);
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 4,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Text(
                    strings.cuttingFiltersUnavailable,
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ),
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
                  label: Text(strings.clearFilters),
                ),
              ],
            ),
          ],
        ),
      );

  InputBorder _inputBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: _border),
      );

  Widget _filterDropdown({required String label, required String value}) =>
      DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF5F7FA),
          border: _inputBorder(),
          enabledBorder: _inputBorder(),
          disabledBorder: _inputBorder(),
        ),
        // Only the neutral placeholder is known. Status/source choices must
        // come from a confirmed backend contract before these are enabled.
        items: [DropdownMenuItem(value: value, child: Text(value))],
        onChanged: null,
      );

  /// Clear remains safe to use offline: it resets only local UI input and
  /// never changes the disconnected data state or sends a network request.
  void _clearFilters() {
    _searchController.clear();
    setState(() {});
  }

  /// Until an endpoint exists, Retry restores the explicit unavailable state
  /// instead of making a guessed request or implying that one was sent.
  void _retry() => setState(() => _notConnected = true);

  Widget _connectionState(AppLocalizations strings, bool compact) => Container(
        padding: EdgeInsets.all(compact ? 18 : 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08172334),
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_outlined,
                color: AppColors.error, size: 30),
            const SizedBox(height: 10),
            Text(
              strings.notConnected,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              strings.cuttingNotConnectedExplanation,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _navy, height: 1.4),
            ),
            const SizedBox(height: 4),
            Text(
              strings.cuttingNoRequestSent,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(strings.retry),
              style: FilledButton.styleFrom(
                backgroundColor: _navy,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );

  void _logout() => Navigator.of(context).pushNamed(RouteNames.login);
}
