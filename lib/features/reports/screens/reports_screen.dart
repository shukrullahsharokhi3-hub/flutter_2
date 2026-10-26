import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/report_demo_data.dart';

/// Mobile-first report overview using isolated sample values until reports API data exists.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportPeriod _period = ReportPeriod.month;
  int _refreshVersion = 0;

  ReportSnapshot get _report => ReportSnapshot.forPeriod(_period);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final report = _report;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: Text(strings.reports),
        leading: IconButton(
          tooltip: strings.backToDashboard,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            tooltip: strings.refresh,
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              // Animate a fresh presentation while keeping the demo data deterministic.
              setState(() => _refreshVersion++);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text(strings.reportsRefreshed)));
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  strings.reports,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  strings.reportsDescription,
                  style: const TextStyle(color: AppColors.secondaryText),
                ),
                const SizedBox(height: 14),
                _DemoNotice(text: strings.reportsDemoNotice),
                const SizedBox(height: 16),
                DropdownButtonFormField<ReportPeriod>(
                  initialValue: _period,
                  decoration: InputDecoration(
                    labelText: strings.reportingPeriod,
                    prefixIcon: const Icon(Icons.date_range_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  items: ReportPeriod.values
                      .map(
                        (period) => DropdownMenuItem(
                          value: period,
                          child: Text(_periodLabel(strings, period)),
                        ),
                      )
                      .toList(),
                  onChanged: (period) {
                    if (period != null) setState(() => _period = period);
                  },
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: Column(
                    key: ValueKey((_period, _refreshVersion)),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SummaryCards(report: report),
                      const SizedBox(height: 18),
                      _SectionHeading(title: strings.reportInsights),
                      const SizedBox(height: 10),
                      _ReportPanel(
                        title: strings.orderStatus,
                        child: _OrderStatusChart(report: report),
                      ),
                      const SizedBox(height: 12),
                      _ReportPanel(
                        title: strings.productionOutput,
                        child: _ProductionStageChart(report: report),
                      ),
                      const SizedBox(height: 12),
                      _ReportPanel(
                        title: strings.revenueTrend,
                        child: _RevenueTrendChart(report: report),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _SectionHeading(title: strings.reportCategories),
                const SizedBox(height: 10),
                _ReportCategoryList(
                  report: report,
                  onSelected: (category) => _showCategoryDetails(
                    context,
                    category,
                    report,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  strings.reportsDemoNotice,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _periodLabel(AppLocalizations strings, ReportPeriod period) =>
      switch (period) {
        ReportPeriod.week => strings.periodThisWeek,
        ReportPeriod.month => strings.periodThisMonth,
        ReportPeriod.year => strings.periodThisYear,
      };

  void _showCategoryDetails(
    BuildContext context,
    _ReportCategory category,
    ReportSnapshot report,
  ) {
    final strings = AppLocalizations.of(context)!;
    final details = switch (category) {
      _ReportCategory.orders => [
          _DetailRow(strings.totalOrders, '${report.totalOrders}'),
          _DetailRow(strings.pending, '${report.pendingOrders}'),
          _DetailRow(strings.inProgress, '${report.inProgressOrders}'),
          _DetailRow(strings.completed, '${report.completedOrders}'),
        ],
      _ReportCategory.production => [
          _DetailRow(strings.productionOutput,
              _formatUnits(context, report.productionOutput, strings)),
          _DetailRow(strings.cutting,
              _formatUnits(context, report.productionByStage[0], strings)),
          _DetailRow(strings.sewing,
              _formatUnits(context, report.productionByStage[1], strings)),
          _DetailRow(strings.finishing,
              _formatUnits(context, report.productionByStage[2], strings)),
          _DetailRow(strings.qualityControl,
              _formatUnits(context, report.productionByStage[3], strings)),
        ],
      _ReportCategory.customers => [
          _DetailRow(strings.totalCustomers, '${report.totalCustomers}'),
          _DetailRow(strings.activeCustomers, '3'),
        ],
      _ReportCategory.revenue => [
          _DetailRow(strings.revenue, _formatCurrency(context, report.revenue)),
          _DetailRow(
            strings.averageOrderValue,
            _formatCurrency(context, report.revenue / report.totalOrders),
          ),
        ],
    };

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                category.label(strings),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                '${_periodLabel(strings, _period)} · ${strings.demoData}',
                style: const TextStyle(color: AppColors.secondaryText),
              ),
              const SizedBox(height: 16),
              for (final detail in details)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(child: Text(detail.label)),
                      const SizedBox(width: 12),
                      Text(
                        detail.value,
                        style: const TextStyle(fontWeight: FontWeight.w700),
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

enum _ReportCategory { orders, production, customers, revenue }

extension on _ReportCategory {
  String label(AppLocalizations strings) => switch (this) {
        _ReportCategory.orders => strings.orderReports,
        _ReportCategory.production => strings.productionReports,
        _ReportCategory.customers => strings.customerReports,
        _ReportCategory.revenue => strings.revenueReports,
      };

  IconData get icon => switch (this) {
        _ReportCategory.orders => Icons.receipt_long_outlined,
        _ReportCategory.production => Icons.precision_manufacturing_outlined,
        _ReportCategory.customers => Icons.groups_outlined,
        _ReportCategory.revenue => Icons.trending_up_rounded,
      };
}

class _DetailRow {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: accent, size: 20),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.report});

  final ReportSnapshot report;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 760 ? 4 : 2;
          const spacing = 10.0;
          final width =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          final strings = AppLocalizations.of(context)!;
          final cards = [
            _SummaryCardData(
              strings.totalOrdersMetric,
              _formatNumber(context, report.totalOrders),
              Icons.receipt_long_outlined,
            ),
            _SummaryCardData(
              strings.productionOutput,
              _formatNumber(context, report.productionOutput),
              Icons.precision_manufacturing_outlined,
            ),
            _SummaryCardData(
              strings.totalCustomers,
              _formatNumber(context, report.totalCustomers),
              Icons.groups_outlined,
            ),
            _SummaryCardData(
              strings.revenue,
              _formatCurrency(context, report.revenue),
              Icons.payments_outlined,
            ),
          ];

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final card in cards)
                SizedBox(
                  width: width,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 112),
                    padding: const EdgeInsets.all(12),
                    decoration: _panelDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          card.icon,
                          color: Theme.of(context).colorScheme.primary,
                          size: 21,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          card.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        Text(
                          card.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      );
}

class _SummaryCardData {
  const _SummaryCardData(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      );
}

class _ReportPanel extends StatelessWidget {
  const _ReportPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: _panelDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      );
}

class _OrderStatusChart extends StatelessWidget {
  const _OrderStatusChart({required this.report});

  final ReportSnapshot report;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final total = report.orderStatusTotal;
    final items = [
      (strings.pending, report.pendingOrders, AppColors.warning),
      (strings.inProgress, report.inProgressOrders, colors.primary),
      (strings.completed, report.completedOrders, AppColors.success),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 12,
            child: Row(
              children: [
                for (final item in items)
                  if (item.$2 > 0)
                    Expanded(
                      flex: item.$2,
                      child: ColoredBox(color: item.$3),
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            for (final item in items)
              _LegendItem(
                color: item.$3,
                label: '${item.$1} (${total == 0 ? 0 : item.$2})',
              ),
          ],
        ),
      ],
    );
  }
}

class _ProductionStageChart extends StatelessWidget {
  const _ProductionStageChart({required this.report});

  final ReportSnapshot report;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final labels = [
      strings.cutting,
      strings.sewing,
      strings.finishing,
      strings.qualityControl,
    ];
    final maxValue = report.productionByStage.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 132,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < labels.length; index++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Text(
                      intl.NumberFormat.compact(
                        locale: Localizations.localeOf(context).toString(),
                      ).format(report.productionByStage[index]),
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor:
                              report.productionByStage[index] / maxValue,
                          widthFactor: 0.62,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labels[index],
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, height: 1.1),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RevenueTrendChart extends StatelessWidget {
  const _RevenueTrendChart({required this.report});

  final ReportSnapshot report;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _formatCurrency(context, report.revenue),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 118,
          width: double.infinity,
          child: CustomPaint(
            painter: _RevenueTrendPainter(
              values: report.revenueTrend,
              color: primary,
              gridColor: AppColors.border,
              textDirection: Directionality.of(context),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context)!.reportTrendCaption,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

/// Paint the revenue trend with Flutter canvas so no chart package is needed.
class _RevenueTrendPainter extends CustomPainter {
  const _RevenueTrendPainter({
    required this.values,
    required this.color,
    required this.gridColor,
    required this.textDirection,
  });

  final List<double> values;
  final Color color;
  final Color gridColor;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 8.0;
    final chart = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var row = 0; row < 3; row++) {
      final y = chart.top + chart.height * row / 2;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = (maxValue - minValue).abs();
    final points = <Offset>[];
    for (var index = 0; index < values.length; index++) {
      final visualIndex = textDirection == TextDirection.rtl
          ? values.length - index - 1
          : index;
      final x = chart.left + chart.width * visualIndex / (values.length - 1);
      final normalized = range == 0 ? 0.5 : (values[index] - minValue) / range;
      final y = chart.bottom - normalized * chart.height;
      points.add(Offset(x, y));
    }

    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      line.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
    final pointPaint = Paint()..color = color;
    for (final point in points) {
      canvas.drawCircle(point, 3.5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(_RevenueTrendPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.color != color ||
      oldDelegate.gridColor != gridColor ||
      oldDelegate.textDirection != textDirection;
}

class _ReportCategoryList extends StatelessWidget {
  const _ReportCategoryList({required this.report, required this.onSelected});

  final ReportSnapshot report;
  final ValueChanged<_ReportCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final categories = [
      _ReportCategory.orders,
      _ReportCategory.production,
      _ReportCategory.customers,
      _ReportCategory.revenue,
    ];
    return Container(
      decoration: _panelDecoration(),
      // This transparent Material sits above the decorated panel, giving each
      // ListTile an ink surface while leaving the panel's border and shadow intact.
      child: Material(
        type: MaterialType.transparency,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var index = 0; index < categories.length; index++)
              Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsetsDirectional.only(
                      start: 14,
                      end: 8,
                    ),
                    leading: Icon(
                      categories[index].icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(categories[index].label(strings)),
                    subtitle: Text(
                      _categorySummary(
                        context,
                        strings,
                        categories[index],
                        report,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => onSelected(categories[index]),
                  ),
                  if (index != categories.length - 1)
                    const Divider(height: 1, indent: 56),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _categorySummary(
    BuildContext context,
    AppLocalizations strings,
    _ReportCategory category,
    ReportSnapshot report,
  ) =>
      switch (category) {
        _ReportCategory.orders =>
          '${strings.totalOrders}: ${report.totalOrders}',
        _ReportCategory.production =>
          '${strings.productionOutput}: ${_formatNumber(context, report.productionOutput)}',
        _ReportCategory.customers =>
          '${strings.totalCustomers}: ${report.totalCustomers}',
        _ReportCategory.revenue =>
          '${strings.revenue}: ${_formatCurrency(context, report.revenue)}',
      };
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      );
}

BoxDecoration _panelDecoration() => BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: AppColors.mainText.withValues(alpha: 0.025),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );

String _formatCurrency(BuildContext context, double value) =>
    intl.NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: '\$',
      decimalDigits: value % 1 == 0 ? 0 : 2,
    ).format(value);

String _formatNumber(BuildContext context, num value) =>
    intl.NumberFormat.decimalPattern(
      Localizations.localeOf(context).toString(),
    ).format(value);

String _formatUnits(
  BuildContext context,
  int value,
  AppLocalizations strings,
) =>
    '${_formatNumber(context, value)} ${strings.unitsLabel}';
