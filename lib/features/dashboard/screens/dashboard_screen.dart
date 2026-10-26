import 'package:flutter/material.dart';
import 'dart:async';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_selector.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/widgets/factory_logo.dart';
import '../../../core/routing/route_names.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Dashboard UI with local sample values; it does not represent live factory data.
class DashboardScreen extends StatelessWidget {
  DashboardScreen({required this.localeController, super.key});

  final LocaleController localeController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const double _wideLayoutBreakpoint = 920;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
        // The active locale supplies purple for English and blue for Dari.
        final headerAccent = Theme.of(context).colorScheme.primary;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.pageBackground,
          appBar: isWide
              ? null
              : AppBar(
                  toolbarHeight: 60,
                  titleSpacing: 2,
                  foregroundColor: headerAccent,
                  title: Text(
                    AppLocalizations.of(context)!.dashboard,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: headerAccent),
                  ),
                  leading: IconButton(
                    tooltip: AppLocalizations.of(context)!.dashboardActions,
                    icon: const Icon(Icons.menu_rounded),
                    style: IconButton.styleFrom(
                      foregroundColor: headerAccent,
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  flexibleSpace: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          headerAccent,
                          Color.lerp(headerAccent, Colors.black, 0.16)!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  actions: [
                    _HeaderAction(
                      icon: Icons.notifications_none_rounded,
                      label: AppLocalizations.of(context)!.notifications,
                      foregroundColor: headerAccent,
                      onPressed: () => _showNotice(
                        context,
                        AppLocalizations.of(context)!.notificationsFuture,
                      ),
                    ),
                    _HeaderAction(
                      icon: Icons.account_circle_outlined,
                      label: AppLocalizations.of(context)!.profile,
                      foregroundColor: headerAccent,
                      onPressed: () => _showNotice(
                        context,
                        AppLocalizations.of(context)!.profileNotImplemented,
                      ),
                    ),
                    LanguageSelector(controller: localeController),
                    PopupMenuButton<String>(
                      tooltip: AppLocalizations.of(context)!.dashboardActions,
                      icon: const Icon(Icons.more_vert_rounded),
                      style: IconButton.styleFrom(
                        foregroundColor: headerAccent,
                      ),
                      onSelected: (action) {
                        if (action == 'notifications') {
                          _showNotice(
                            context,
                            AppLocalizations.of(context)!.notificationsFuture,
                          );
                        } else if (action == 'login') {
                          _returnToLogin(context);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'notifications',
                          child:
                              Text(AppLocalizations.of(context)!.notifications),
                        ),
                        PopupMenuItem(
                          value: 'login',
                          child:
                              Text(AppLocalizations.of(context)!.returnToLogin),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
          drawer: isWide
              ? null
              : Drawer(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: DashboardSidebar(
                    inDrawer: true,
                    onUnavailable: (label) => _showNotice(
                      context,
                      AppLocalizations.of(context)!.notImplemented,
                    ),
                  ),
                ),
          body: isWide
              ? Row(
                  children: [
                    DashboardSidebar(
                      onUnavailable: (label) => _showNotice(
                        context,
                        AppLocalizations.of(context)!.notImplemented,
                      ),
                    ),
                    Expanded(
                      child: _DashboardContent(
                        showHeader: true,
                        localeController: localeController,
                      ),
                    ),
                  ],
                )
              : _DashboardContent(
                  showHeader: false,
                  localeController: localeController,
                ),
          bottomNavigationBar: isWide
              ? null
              : SafeArea(
                  top: false,
                  child: NavigationBar(
                    selectedIndex: 0,
                    labelBehavior:
                        NavigationDestinationLabelBehavior.alwaysShow,
                    onDestinationSelected: (index) {
                      final route = [
                        RouteNames.dashboard,
                        RouteNames.orders,
                        RouteNames.production,
                        RouteNames.customers,
                      ][index];
                      if (route != RouteNames.dashboard) {
                        Navigator.of(context).pushReplacementNamed(route);
                      }
                    },
                    destinations: [
                      NavigationDestination(
                        icon: const Icon(Icons.home_outlined),
                        selectedIcon: const Icon(Icons.home_rounded),
                        label: AppLocalizations.of(context)!.dashboard,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.receipt_long_outlined),
                        selectedIcon: const Icon(Icons.receipt_long_rounded),
                        label: AppLocalizations.of(context)!.orders,
                      ),
                      NavigationDestination(
                        icon:
                            const Icon(Icons.precision_manufacturing_outlined),
                        selectedIcon:
                            const Icon(Icons.precision_manufacturing_rounded),
                        label: AppLocalizations.of(context)!.production,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.groups_outlined),
                        selectedIcon: const Icon(Icons.groups_rounded),
                        label: AppLocalizations.of(context)!.customers,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  /// Routes unfinished menu actions to a clear message instead of a dead page.
  static void _showNotice(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Opens the existing Login route whether Dashboard was pushed or launched directly.
  static void _returnToLogin(BuildContext context) {
    Navigator.of(context).pushNamed(RouteNames.login);
  }
}

/// Shared sidebar content is used in a fixed desktop rail and a mobile drawer.
class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.onUnavailable,
    this.inDrawer = false,
    this.selectedRoute = RouteNames.dashboard,
    this.darkNavy = false,
  });

  final ValueChanged<String> onUnavailable;
  final bool inDrawer;
  final String selectedRoute;
  final bool darkNavy;

  static const _destinations = <_NavigationDestination>[
    _NavigationDestination('Dashboard', Icons.grid_view_rounded),
    _NavigationDestination('Reports', Icons.assessment_outlined),
    _NavigationDestination(
        'Production', Icons.precision_manufacturing_outlined),
    _NavigationDestination('Analytics', Icons.query_stats_outlined),
    _NavigationDestination('Orders', Icons.receipt_long_outlined),
    _NavigationDestination('Customers', Icons.groups_outlined),
    _NavigationDestination('Employees', Icons.badge_outlined),
    _NavigationDestination('Materials', Icons.inventory_2_outlined),
    _NavigationDestination('Cutting', Icons.content_cut_outlined),
    _NavigationDestination('Quality Checks', Icons.fact_check_outlined),
    _NavigationDestination('Finished Stock', Icons.checkroom_outlined),
    _NavigationDestination('Payroll', Icons.payments_outlined),
    _NavigationDestination('Profile', Icons.account_circle_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: inDrawer ? null : 252,
      color: darkNavy
          ? const Color(0xFF142337)
          : Theme.of(context).colorScheme.primaryContainer,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 18, 24),
              child: Row(
                children: [
                  FactoryLogo(
                    size: 42,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    accentColor: Theme.of(context).colorScheme.primaryContainer,
                    accentIconColor: Theme.of(context).colorScheme.primary,
                    iconColor: AppColors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.appName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color:
                                darkNavy ? AppColors.white : AppColors.mainText,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 0, 16, 10),
              child: Text(
                AppLocalizations.of(context)!.workspace,
                style: TextStyle(
                  // The light-purple sidebar uses readable dark text.
                  color: darkNavy ? Colors.white70 : AppColors.mainText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                itemCount: _destinations.length,
                itemBuilder: (context, index) {
                  final destination = _destinations[index];
                  final route = switch (destination.label) {
                    'Dashboard' => RouteNames.dashboard,
                    'Reports' => RouteNames.reports,
                    'Customers' => RouteNames.customers,
                    'Orders' => RouteNames.orders,
                    'Production' => RouteNames.production,
                    'Materials' => RouteNames.materials,
                    'Employees' => RouteNames.employees,
                    // The existing sidebar item now opens the Cutting screen.
                    'Cutting' => RouteNames.cutting,
                    _ => '',
                  };
                  final isSelected = route.isNotEmpty && route == selectedRoute;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _SidebarItem(
                      destination: destination,
                      selected: isSelected,
                      darkNavy: darkNavy,
                      onTap: () {
                        if (inDrawer) Navigator.of(context).pop();
                        if (route.isNotEmpty && !isSelected) {
                          Navigator.of(context).pushNamed(route);
                        } else if (!isSelected) {
                          onUnavailable(destination.label);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 10, 18, 20),
              child: Text(
                AppLocalizations.of(context)!.uiPreview,
                style: TextStyle(
                    color: darkNavy ? Colors.white70 : AppColors.mainText,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationDestination {
  const _NavigationDestination(this.label, this.icon);

  final String label;
  final IconData icon;
}

// Route identifiers stay in English for navigation logic; labels are localized.
String _destinationLabel(BuildContext context, String routeLabel) {
  final strings = AppLocalizations.of(context)!;
  return switch (routeLabel) {
    'Dashboard' => strings.dashboard,
    'Reports' => strings.reports,
    'Production' => strings.production,
    'Analytics' => strings.analytics,
    'Orders' => strings.orders,
    'Customers' => strings.customers,
    'Employees' => strings.employees,
    'Materials' => strings.materials,
    'Cutting' => strings.cutting,
    'Quality Checks' => strings.qualityChecks,
    'Finished Stock' => strings.finishedStock,
    'Payroll' => strings.payroll,
    'Profile' => strings.profile,
    _ => routeLabel,
  };
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.destination,
    required this.selected,
    required this.onTap,
    this.darkNavy = false,
  });

  final _NavigationDestination destination;
  final bool selected;
  final VoidCallback onTap;
  final bool darkNavy;

  @override
  Widget build(BuildContext context) {
    final isDari = Localizations.localeOf(context).languageCode == 'fa';
    final selectedBackground = darkNavy
        ? const Color(0xFF29415E)
        : isDari
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.primary;
    final selectedForeground = darkNavy
        ? AppColors.white
        : isDari
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onPrimary;
    // Selected items use the locale's pale accent surface with readable text.
    final labelColor = selected
        ? selectedForeground
        : (darkNavy ? Colors.white70 : AppColors.mainText);
    final iconColor = selected
        ? selectedForeground
        : darkNavy
            ? Colors.white70
            : Theme.of(context).colorScheme.primary;

    return Material(
      color: selected ? selectedBackground : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              Icon(destination.icon, size: 19, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _destinationLabel(context, destination.label),
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (selected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: selectedForeground,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Provides the new Dashboard copy in both supported locales without changing
/// the app-wide generated localization tables for other screens.
String _dashboardCopy(BuildContext context, String english, String dari) =>
    Localizations.localeOf(context).languageCode == 'fa' ? dari : english;

class _DashboardContent extends StatefulWidget {
  const _DashboardContent({
    required this.showHeader,
    required this.localeController,
  });

  final bool showHeader;
  final LocaleController localeController;

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  final GlobalKey _monthlyProductionKey = GlobalKey();
  final GlobalKey _revenueTrendsKey = GlobalKey();

  void _scrollToChart(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null) return;

    // These destinations already exist in the Dashboard, so bring their cards
    // into view instead of adding duplicate pages or inventing new routes.
    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 620;
        // Use the actual phone viewport to keep cards roomy on narrow devices.
        final phoneWidth = MediaQuery.sizeOf(context).width;
        final horizontalPadding =
            compact ? (phoneWidth < 360 ? 12.0 : 16.0) : 28.0;
        final contentWidth = (constraints.maxWidth - horizontalPadding * 2)
            .clamp(0.0, 1440.0)
            .toDouble();

        return SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          // Keep the scrollable content clear of Android's gesture area.
          child: SafeArea(
            top: false,
            child: Center(
              // Give responsive children the full padded viewport width instead
              // of letting the centered content shrink to its intrinsic width.
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.showHeader) ...[
                      _DesktopHeader(controller: widget.localeController),
                      const SizedBox(height: 14),
                    ],
                    // Keep one destination carousel directly under the header.
                    _DashboardQuickLinks(
                      onOrderTracking: () =>
                          Navigator.of(context).pushNamed(RouteNames.orders),
                      onProductionCoordination: () => Navigator.of(context)
                          .pushNamed(RouteNames.production),
                      onMonthlyProduction: () =>
                          _scrollToChart(_monthlyProductionKey),
                      onRevenueTrends: () => _scrollToChart(_revenueTrendsKey),
                    ),
                    SizedBox(height: compact ? 12 : 18),
                    _SummaryGrid(compact: compact),
                    SizedBox(height: compact ? 14 : 20),
                    _ChartsSection(
                      productionChartKey: _monthlyProductionKey,
                      revenueChartKey: _revenueTrendsKey,
                    ),
                    SizedBox(height: compact ? 16 : 20),
                    const _ProductionSection(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// One swipeable carousel keeps the four common Dashboard destinations together.
class _DashboardQuickLinks extends StatefulWidget {
  const _DashboardQuickLinks({
    required this.onOrderTracking,
    required this.onProductionCoordination,
    required this.onMonthlyProduction,
    required this.onRevenueTrends,
  });

  final VoidCallback onOrderTracking;
  final VoidCallback onProductionCoordination;
  final VoidCallback onMonthlyProduction;
  final VoidCallback onRevenueTrends;

  @override
  State<_DashboardQuickLinks> createState() => _DashboardQuickLinksState();
}

class _DashboardQuickLinksState extends State<_DashboardQuickLinks> {
  // Fractional width leaves a preview of the next card on portrait phones.
  final PageController _pageController = PageController(viewportFraction: 0.87);
  static const _slideInterval = Duration(seconds: 2);
  static const _slideDuration = Duration(milliseconds: 450);
  Timer? _rotationTimer;
  final Set<int> _activePointers = <int>{};
  bool _pointerHovering = false;
  int _activePage = 0;

  @override
  void initState() {
    super.initState();
    _scheduleRotation();
  }

  void _scheduleRotation() {
    _rotationTimer?.cancel();
    if (_pointerHovering || _activePointers.isNotEmpty) return;
    _rotationTimer = Timer(_slideInterval, () {
      if (!mounted || !_pageController.hasClients) return;
      // The large item count lets the final card animate directly to the first.
      _pageController.nextPage(
        duration: _slideDuration,
        curve: Curves.easeInOut,
      );
      _scheduleRotation();
    });
  }

  void _pauseRotation() {
    _rotationTimer?.cancel();
    _rotationTimer = null;
  }

  void _resumeRotation() => _scheduleRotation();

  @override
  void dispose() {
    _rotationTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destinations = <_DashboardQuickLinkData>[
      _DashboardQuickLinkData(
        title: _dashboardCopy(context, 'Order Tracking', 'پیگیری سفارش‌ها'),
        description: _dashboardCopy(
          context,
          'Review orders and delivery schedules.',
          'سفارش‌ها و زمان‌بندی تحویل را بررسی کنید.',
        ),
        icon: Icons.receipt_long_outlined,
        onTap: widget.onOrderTracking,
      ),
      _DashboardQuickLinkData(
        title: _dashboardCopy(
          context,
          'Production Coordination',
          'هماهنگی تولید',
        ),
        description: _dashboardCopy(
          context,
          'Follow active work across the factory.',
          'کارهای فعال در کارخانه را پیگیری کنید.',
        ),
        icon: Icons.precision_manufacturing_outlined,
        onTap: widget.onProductionCoordination,
      ),
      _DashboardQuickLinkData(
        title: _dashboardCopy(context, 'Monthly Production', 'تولید ماهانه'),
        description: _dashboardCopy(
          context,
          'Explore garment output by month.',
          'مقدار تولید پوشاک را در هر ماه ببینید.',
        ),
        icon: Icons.bar_chart_rounded,
        onTap: widget.onMonthlyProduction,
      ),
      _DashboardQuickLinkData(
        title: _dashboardCopy(context, 'Revenue Trends', 'روند عواید'),
        description: _dashboardCopy(
          context,
          'See the revenue trend shown in this dashboard.',
          'روند عواید را در همین داشبورد ببینید.',
        ),
        icon: Icons.trending_up_rounded,
        onTap: widget.onRevenueTrends,
      ),
    ];

    return MouseRegion(
      onEnter: (_) {
        _pointerHovering = true;
        _pauseRotation();
      },
      onExit: (_) {
        _pointerHovering = false;
        _resumeRotation();
      },
      child: Listener(
        // Touch and drag interactions pause rotation until every pointer lifts.
        onPointerDown: (event) {
          _activePointers.add(event.pointer);
          _pauseRotation();
        },
        onPointerUp: (event) {
          _activePointers.remove(event.pointer);
          if (_activePointers.isEmpty) _resumeRotation();
        },
        onPointerCancel: (event) {
          _activePointers.remove(event.pointer);
          if (_activePointers.isEmpty) _resumeRotation();
        },
        child: Column(
          children: [
            SizedBox(
              height: 166,
              child: PageView.builder(
                controller: _pageController,
                padEnds: false,
                // Repeating pages make the transition from card four to one smooth.
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: _DashboardQuickLink(
                    data: destinations[index % destinations.length],
                  ),
                ),
                onPageChanged: (page) {
                  if (!mounted) return;
                  setState(() => _activePage = page % destinations.length);
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 0; index < destinations.length; index++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: index == _activePage ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == _activePage
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardQuickLinkData {
  const _DashboardQuickLinkData({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
}

class _DashboardQuickLink extends StatelessWidget {
  const _DashboardQuickLink({required this.data});

  final _DashboardQuickLinkData data;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.mainText.withValues(alpha: 0.035),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(data.icon, color: colors.primary, size: 27),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.mainText,
                        fontSize: 14,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 11,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        onPressed: data.onTap,
                        style: TextButton.styleFrom(
                          minimumSize: const Size(48, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          foregroundColor: colors.primary,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(_dashboardCopy(
                            context, 'Learn More', 'بیشتر بدانید')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.controller});

  final LocaleController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.dashboard,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.mainText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.productionPerformance,
                style: TextStyle(color: AppColors.secondaryText),
              ),
            ],
          ),
        ),
        const _PreviewChip(),
        const SizedBox(width: 12),
        _HeaderAction(
          icon: Icons.notifications_none_rounded,
          label: AppLocalizations.of(context)!.notifications,
          onPressed: () => DashboardScreen._showNotice(
            context,
            AppLocalizations.of(context)!.notificationsFuture,
          ),
        ),
        const SizedBox(width: 4),
        _HeaderAction(
          icon: Icons.account_circle_outlined,
          label: AppLocalizations.of(context)!.profile,
          onPressed: () => DashboardScreen._showNotice(
            context,
            AppLocalizations.of(context)!.profileNotImplemented,
          ),
        ),
        const SizedBox(width: 4),
        LanguageSelector(controller: controller),
        _HeaderAction(
          icon: Icons.login_rounded,
          label: AppLocalizations.of(context)!.returnToLogin,
          onPressed: () => DashboardScreen._returnToLogin(context),
        ),
      ],
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        AppLocalizations.of(context)!.demoData,
        style: TextStyle(
          color: AppColors.mainText,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        foregroundColor:
            foregroundColor ?? Theme.of(context).colorScheme.primary,
        backgroundColor: foregroundColor == null
            ? AppColors.cardBackground
            : Colors.white.withValues(alpha: 0.14),
        minimumSize: const Size(44, 44),
        side: foregroundColor == null
            ? const BorderSide(color: AppColors.border)
            : BorderSide.none,
      ),
      icon: Icon(icon, size: 21),
    );
  }
}

class _SummaryGrid extends StatefulWidget {
  const _SummaryGrid({required this.compact});

  final bool compact;

  static const _items = <_SummaryData>[
    _SummaryData(
      title: 'Total Orders',
      value: '248',
      change: '+12.8% this month',
      icon: Icons.receipt_long_outlined,
    ),
    _SummaryData(
      title: 'Production Output',
      value: '18,420 pcs',
      change: '+8.2% this month',
      icon: Icons.precision_manufacturing_outlined,
    ),
    _SummaryData(
      title: 'Revenue',
      value: '\$128,450',
      change: '+6.4% this month',
      icon: Icons.payments_outlined,
    ),
    _SummaryData(
      title: 'Overall Efficiency',
      value: '87.6%',
      change: '+2.1% this month',
      icon: Icons.speed_outlined,
    ),
  ];

  @override
  State<_SummaryGrid> createState() => _SummaryGridState();
}

class _SummaryGridState extends State<_SummaryGrid> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelPadding = widget.compact ? 14.0 : 20.0;
        final innerWidth = constraints.maxWidth - panelPadding * 2;
        // Phone cards stay in two columns; only unusually narrow windows stack.
        final columns =
            innerWidth < 250 ? 1 : (constraints.maxWidth >= 980 ? 4 : 2);
        final spacing = widget.compact ? 10.0 : 14.0;
        final width = (innerWidth - spacing * (columns - 1)) / columns;

        final strings = AppLocalizations.of(context)!;
        return Container(
          padding: EdgeInsets.all(panelPadding),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(22),
              bottom: Radius.circular(18),
            ),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.mainText.withValues(alpha: 0.035),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _dashboardCopy(
                            context,
                            'My Business Metrics',
                            'شاخص‌های کسب‌وکار من',
                          ),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.mainText,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.factory_outlined,
                      size: 17, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      strings.appName,
                      style: const TextStyle(
                        color: AppColors.mainText,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => DashboardScreen._showNotice(
                      context,
                      _dashboardCopy(
                        context,
                        'Full metrics are not available yet.',
                        'جزئیات کامل شاخص‌ها هنوز در دسترس نیست.',
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: const Size(48, 40),
                    ),
                    child: Text(
                      _dashboardCopy(
                          context, 'See Full Metrics', 'دیدن همه شاخص‌ها'),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  '${_dashboardCopy(context, 'Reporting period', 'دوره گزارش')}: '
                  '${strings.apr} – ${strings.sep}',
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ),
              if (_expanded) ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _SummaryGrid._items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    mainAxisExtent:
                        widget.compact ? (width < 132 ? 142 : 126) : 144,
                  ),
                  itemBuilder: (context, index) => _SummaryCard(
                    data: _SummaryGrid._items[index],
                    compact: widget.compact,
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => DashboardScreen._showNotice(
                    context,
                    _dashboardCopy(
                      context,
                      'Dashboard customization is not available yet.',
                      'سفارشی‌سازی داشبورد هنوز در دسترس نیست.',
                    ),
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: Text(_dashboardCopy(
                    context,
                    'Customize your dashboard view',
                    'سفارشی‌سازی نمای داشبورد',
                  )),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    minimumSize: const Size.fromHeight(44),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SummaryData {
  const _SummaryData({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
  });

  final String title;
  final String value;
  final String change;
  final IconData icon;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data, this.compact = false});

  final _SummaryData data;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Trim card padding only on the narrowest phone layout.
      padding: EdgeInsets.all(compact ? 12 : 18),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        // A low-opacity shadow lifts metric cards slightly off the white page.
        boxShadow: [
          BoxShadow(
            color: AppColors.mainText.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _dashboardMetricTitle(context, data.title),
                  style: const TextStyle(
                    color: AppColors.mainText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: compact ? 32 : 38,
                height: compact ? 32 : 38,
                decoration: BoxDecoration(
                  // Metric tiles use the locale's pale accent surface.
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  data.icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 8 : 12),
          Text(
            _dashboardMetricValue(context, data.value),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.mainText,
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 19 : null,
                ),
          ),
          SizedBox(height: compact ? 4 : 7),
          Text(
            _dashboardMetricChange(context, data.change),
            style: const TextStyle(
              // Keep small metric text readable against white card surfaces.
              color: AppColors.mainText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartsSection extends StatelessWidget {
  const _ChartsSection({
    required this.productionChartKey,
    required this.revenueChartKey,
  });

  final GlobalKey productionChartKey;
  final GlobalKey revenueChartKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            children: [
              _ProductionChartCard(key: productionChartKey),
              const SizedBox(height: 16),
              _RevenueChartCard(key: revenueChartKey),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ProductionChartCard(key: productionChartKey)),
            const SizedBox(width: 16),
            Expanded(child: _RevenueChartCard(key: revenueChartKey)),
          ],
        );
      },
    );
  }
}

/// Monthly garment output is drawn with Canvas, avoiding a chart dependency.
class _ProductionChartCard extends StatelessWidget {
  const _ProductionChartCard({super.key});

  static const _months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];
  static const List<double> _values = [54, 66, 61, 78, 72, 92];

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: AppLocalizations.of(context)!.monthlyProduction,
      subtitle: AppLocalizations.of(context)!.unitsThousands,
      child: Column(
        children: [
          SizedBox(
            height: 170,
            width: double.infinity,
            child: CustomPaint(
              painter: _BarChartPainter(
                _values,
                seriesColor: Theme.of(context).colorScheme.secondary,
                latestColor: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final month in _months)
                Text(
                  _monthLabel(context, month),
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Revenue values use the same lightweight custom drawing approach as bars.
class _RevenueChartCard extends StatelessWidget {
  const _RevenueChartCard({super.key});

  static const _months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];
  static const List<double> _values = [42, 57, 51, 74, 69, 88];

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: AppLocalizations.of(context)!.revenueTrend,
      subtitle: AppLocalizations.of(context)!.revenueThousandsUsd,
      child: Column(
        children: [
          SizedBox(
            height: 170,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(
                _values,
                seriesColor: Theme.of(context).colorScheme.secondary,
                latestColor: Theme.of(context).colorScheme.tertiaryContainer,
                centerColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final month in _months)
                Text(
                  _monthLabel(context, month),
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.mainText,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  const _BarChartPainter(
    this.values, {
    required this.seriesColor,
    required this.latestColor,
  });

  final List<double> values;
  final Color seriesColor;
  final Color latestColor;

  @override
  void paint(Canvas canvas, Size size) {
    const horizontalInset = 8.0;
    const verticalInset = 10.0;
    final chartWidth = size.width - horizontalInset * 2;
    final chartHeight = size.height - verticalInset * 2;
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    for (var row = 0; row < 4; row++) {
      final y = verticalInset + chartHeight * row / 3;
      canvas.drawLine(
        Offset(horizontalInset, y),
        Offset(size.width - horizontalInset, y),
        gridPaint,
      );
    }

    final maxValue =
        values.reduce((first, next) => first > next ? first : next);
    final slotWidth = chartWidth / values.length;
    final barWidth = slotWidth * 0.48;
    for (var index = 0; index < values.length; index++) {
      // Keep chart colors synchronized with the active locale palette.
      final barPaint = Paint()
        ..color = index == values.length - 1 ? latestColor : seriesColor
        ..style = PaintingStyle.fill;
      final barHeight = chartHeight * values[index] / maxValue;
      final left =
          horizontalInset + slotWidth * index + (slotWidth - barWidth) / 2;
      final top = verticalInset + chartHeight - barHeight;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, barWidth, barHeight),
          const Radius.circular(5),
        ),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.seriesColor != seriesColor ||
      oldDelegate.latestColor != latestColor;
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter(
    this.values, {
    required this.seriesColor,
    required this.latestColor,
    required this.centerColor,
  });

  final List<double> values;
  final Color seriesColor;
  final Color latestColor;
  final Color centerColor;

  @override
  void paint(Canvas canvas, Size size) {
    const horizontalInset = 8.0;
    const verticalInset = 14.0;
    final chartWidth = size.width - horizontalInset * 2;
    final chartHeight = size.height - verticalInset * 2;
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    for (var row = 0; row < 4; row++) {
      final y = verticalInset + chartHeight * row / 3;
      canvas.drawLine(
        Offset(horizontalInset, y),
        Offset(size.width - horizontalInset, y),
        gridPaint,
      );
    }

    final maxValue =
        values.reduce((first, next) => first > next ? first : next);
    final points = <Offset>[];
    for (var index = 0; index < values.length; index++) {
      final x = horizontalInset + chartWidth * index / (values.length - 1);
      final y = verticalInset + chartHeight * (1 - values[index] / maxValue);
      points.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = seriesColor
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    final centerPaint = Paint()..color = centerColor;
    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final pointPaint = Paint()
        ..color = index == points.length - 1 ? latestColor : seriesColor;
      canvas.drawCircle(point, 5, pointPaint);
      canvas.drawCircle(point, 2.2, centerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.seriesColor != seriesColor ||
      oldDelegate.latestColor != latestColor ||
      oldDelegate.centerColor != centerColor;
}

class _ProductionSection extends StatelessWidget {
  const _ProductionSection();

  static const _orders = <_ProductionOrder>[
    _ProductionOrder('GF-24018', 'Classic Cotton Shirt', 2400, 92, 'Completed'),
    _ProductionOrder('GF-24021', 'Denim Work Jacket', 1800, 84, 'In Progress'),
    _ProductionOrder('GF-24025', 'Uniform Trousers', 3200, 79, 'In Progress'),
    _ProductionOrder('GF-24029', 'Knit Polo Shirt', 1200, 0, 'Pending'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.recentProductionInsights,
                  style: TextStyle(
                    color: AppColors.mainText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(Icons.more_horiz, color: AppColors.secondaryText),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 820) {
                return Column(
                  children: [
                    for (var index = 0; index < _orders.length; index++)
                      _ProductionOrderTile(
                        order: _orders[index],
                        showDivider: index != _orders.length - 1,
                      ),
                  ],
                );
              }
              return _ProductionTable(orders: _orders);
            },
          ),
        ],
      ),
    );
  }
}

class _ProductionOrder {
  const _ProductionOrder(
    this.id,
    this.product,
    this.units,
    this.efficiency,
    this.status,
  );

  final String id;
  final String product;
  final int units;
  final int efficiency;
  final String status;
}

class _ProductionTable extends StatelessWidget {
  const _ProductionTable({required this.orders});

  final List<_ProductionOrder> orders;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      horizontalMargin: 0,
      columnSpacing: 22,
      headingRowHeight: 42,
      dataRowMinHeight: 56,
      dataRowMaxHeight: 64,
      headingTextStyle: const TextStyle(
        color: AppColors.secondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      columns: [
        DataColumn(label: Text(AppLocalizations.of(context)!.orderIdColumn)),
        DataColumn(label: Text(AppLocalizations.of(context)!.productColumn)),
        DataColumn(
            label: Text(AppLocalizations.of(context)!.unitsColumn),
            numeric: true),
        DataColumn(
            label: Text(AppLocalizations.of(context)!.efficiencyColumn),
            numeric: true),
        DataColumn(label: Text(AppLocalizations.of(context)!.statusColumn)),
      ],
      rows: [
        for (final order in orders)
          DataRow(
            cells: [
              DataCell(Text(order.id)),
              DataCell(Text(order.product)),
              DataCell(Text(_formatUnits(order.units))),
              DataCell(
                  Text(order.efficiency == 0 ? 'â€”' : '${order.efficiency}%')),
              DataCell(_StatusPill(status: order.status)),
            ],
          ),
      ],
    );
  }
}

class _ProductionOrderTile extends StatelessWidget {
  const _ProductionOrderTile({
    required this.order,
    required this.showDivider,
  });

  final _ProductionOrder order;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.product,
                      style: const TextStyle(
                        color: AppColors.mainText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _StatusPill(status: order.status),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                '${order.id}  â€¢  ${_formatUnits(order.units)} ${AppLocalizations.of(context)!.unitsLabel}  â€¢  '
                '${order.efficiency == 0 ? AppLocalizations.of(context)!.efficiencyPending : '${order.efficiency}% ${AppLocalizations.of(context)!.percentEfficiency}'}',
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.border),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final Color foreground;
    final Color background;
    switch (status) {
      case 'Completed':
        foreground = AppColors.success;
        background = AppColors.successBackground;
        break;
      case 'In Progress':
        foreground = AppColors.mainText;
        background = Theme.of(context).colorScheme.tertiaryContainer;
        break;
      default:
        foreground = AppColors.warning;
        background = AppColors.warningBackground;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _dashboardStatusLabel(context, status),
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _formatUnits(int units) => units.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );

String _dashboardMetricTitle(BuildContext context, String value) {
  final strings = AppLocalizations.of(context)!;
  return switch (value) {
    'Total Orders' => strings.totalOrdersMetric,
    'Production Output' => strings.productionOutput,
    'Revenue' => strings.revenue,
    'Overall Efficiency' => strings.overallEfficiency,
    _ => value,
  };
}

String _dashboardMetricValue(BuildContext context, String value) {
  if (value == '18,420 pcs') {
    return '18,420 ${AppLocalizations.of(context)!.unitsLabel}';
  }
  return value;
}

String _dashboardMetricChange(BuildContext context, String value) {
  final strings = AppLocalizations.of(context)!;
  return switch (value) {
    '+12.8% this month' => strings.ordersChange,
    '+8.2% this month' => strings.productionChange,
    '+6.4% this month' => strings.revenueChange,
    '+2.1% this month' => strings.efficiencyChange,
    _ => value,
  };
}

String _monthLabel(BuildContext context, String value) {
  final strings = AppLocalizations.of(context)!;
  return switch (value) {
    'Apr' => strings.apr,
    'May' => strings.may,
    'Jun' => strings.jun,
    'Jul' => strings.jul,
    'Aug' => strings.aug,
    'Sep' => strings.sep,
    _ => value,
  };
}

String _dashboardStatusLabel(BuildContext context, String value) {
  final strings = AppLocalizations.of(context)!;
  return switch (value) {
    'Completed' => strings.completed,
    'In Progress' => strings.inProgress,
    'Pending' => strings.pending,
    _ => value,
  };
}
