import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/production_job.dart';

/// Production overview backed by sample jobs while the service is unavailable.
class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  final _searchController = TextEditingController();
  ProductionStatus? _statusFilter;

  // Sample jobs cover every garment stage and workflow status for the preview.
  static const _jobs = <ProductionJob>[
    ProductionJob(
      orderId: 'GF-24018',
      product: 'Classic Cotton Shirt',
      plannedQuantity: 2400,
      producedQuantity: 2400,
      stage: ProductionStage.qualityControl,
      status: ProductionStatus.completed,
    ),
    ProductionJob(
      orderId: 'GF-24021',
      product: 'Denim Work Jacket',
      plannedQuantity: 1800,
      producedQuantity: 1260,
      stage: ProductionStage.sewing,
      status: ProductionStatus.inProgress,
    ),
    ProductionJob(
      orderId: 'GF-24025',
      product: 'Uniform Trousers',
      plannedQuantity: 3200,
      producedQuantity: 950,
      stage: ProductionStage.cutting,
      status: ProductionStatus.inProgress,
    ),
    ProductionJob(
      orderId: 'GF-24029',
      product: 'Knit Polo Shirt',
      plannedQuantity: 1200,
      producedQuantity: 0,
      stage: ProductionStage.cutting,
      status: ProductionStatus.pending,
    ),
    ProductionJob(
      orderId: 'GF-24032',
      product: 'Lightweight Hoodie',
      plannedQuantity: 900,
      producedQuantity: 720,
      stage: ProductionStage.finishing,
      status: ProductionStatus.delayed,
    ),
  ];

  List<ProductionJob> get _filteredJobs {
    final query = _searchController.text.trim().toLowerCase();
    // Apply text and status filters together, keeping the summary counts global.
    return _jobs.where((job) {
      final matchesQuery = query.isEmpty ||
          job.orderId.toLowerCase().contains(query) ||
          job.product.toLowerCase().contains(query);
      final matchesStatus = _statusFilter == null || job.status == _statusFilter;
      return matchesQuery && matchesStatus;
    }).toList();
  }

  int _countFor(ProductionStatus status) =>
      _jobs.where((job) => job.status == status).length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;
    final jobs = _filteredJobs;
    final pendingOrDelayed = _countFor(ProductionStatus.pending) +
        _countFor(ProductionStatus.delayed);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.production),
        leading: IconButton(
          tooltip: AppLocalizations.of(context)!.backToDashboard,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(compact ? 16 : 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.production,
                  style: TextStyle(
                    color: AppColors.mainText,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of(context)!.productionDescription,
                  style: TextStyle(color: AppColors.secondaryText),
                ),
                const SizedBox(height: 20),
                _summaryCards(compact, pendingOrDelayed),
                const SizedBox(height: 18),
                _filterControls(compact),
                const SizedBox(height: 16),
                if (jobs.isEmpty)
                  _emptyState()
                else if (compact)
                  ...jobs.map(_jobCard)
                else
                  _jobTable(jobs),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.productionNotLive,
                  textAlign: TextAlign.center,
                  style: TextStyle(
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

  Widget _summaryCards(bool compact, int pendingOrDelayed) => LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = compact
              ? (constraints.maxWidth - 12) / 2
              : (constraints.maxWidth - 36) / 4;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: cardWidth,
                child: _summaryCard(AppLocalizations.of(context)!.totalProductionJobs, '${_jobs.length}',
                    Icons.precision_manufacturing_outlined),
              ),
              SizedBox(
                width: cardWidth,
                child: _summaryCard(AppLocalizations.of(context)!.inProgress,
                    '${_countFor(ProductionStatus.inProgress)}', Icons.sync),
              ),
              SizedBox(
                width: cardWidth,
                child: _summaryCard(AppLocalizations.of(context)!.completed,
                    '${_countFor(ProductionStatus.completed)}', Icons.check_circle_outline),
              ),
              SizedBox(
                width: cardWidth,
                child: _summaryCard(AppLocalizations.of(context)!.pendingDelayed, '$pendingOrDelayed',
                    Icons.schedule_outlined),
              ),
            ],
          );
        },
      );

  Widget _summaryCard(String label, String value, IconData icon) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: const TextStyle(
                          color: AppColors.mainText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  Text(label,
                      style: const TextStyle(
                          color: AppColors.secondaryText, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _filterControls(bool compact) {
    final search = TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.searchProduction,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                tooltip: AppLocalizations.of(context)!.clearSearch,
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
      ),
    );
    final statusFilter = DropdownButtonFormField<ProductionStatus?>(
      initialValue: _statusFilter,
      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.filterByStatus),
      items: [
        DropdownMenuItem<ProductionStatus?>(
            value: null, child: Text(AppLocalizations.of(context)!.allStatuses)),
        ...ProductionStatus.values.map(
          (status) => DropdownMenuItem<ProductionStatus?>(
            value: status,
            child: Text(_statusLabel(context, status)),
          ),
        ),
      ],
      onChanged: (status) => setState(() => _statusFilter = status),
    );
    if (compact) {
      return Column(
        children: [search, const SizedBox(height: 12), statusFilter],
      );
    }
    return Row(
      children: [
        Expanded(child: search),
        const SizedBox(width: 12),
        SizedBox(width: 220, child: statusFilter),
      ],
    );
  }

  Widget _jobTable(List<ProductionJob> jobs) => Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primaryContainer,
              ),
              headingTextStyle: const TextStyle(
                color: AppColors.mainText,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              columns: [
                DataColumn(label: Text(AppLocalizations.of(context)!.orderIdColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.productColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.plannedQuantityColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.producedQuantityColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.stageColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.statusColumn)),
              ],
              rows: jobs
                  .map(
                    (job) => DataRow(
                      cells: [
                        DataCell(Text(job.orderId)),
                        DataCell(Text(job.product)),
                        DataCell(Text(_formatQuantity(job.plannedQuantity))),
                        DataCell(Text(_formatQuantity(job.producedQuantity))),
                        DataCell(_stageBadge(job.stage)),
                        DataCell(_statusBadge(job.status)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );

  Widget _jobCard(ProductionJob job) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.orderId,
                      style: const TextStyle(
                        color: AppColors.mainText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _statusBadge(job.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(job.product,
                  style: const TextStyle(color: AppColors.secondaryText)),
              const Divider(height: 22),
              _detailRow(AppLocalizations.of(context)!.plannedQuantity, _formatQuantity(job.plannedQuantity)),
              const SizedBox(height: 8),
              _detailRow(AppLocalizations.of(context)!.producedQuantity, _formatQuantity(job.producedQuantity)),
              const SizedBox(height: 8),
              _detailRow(AppLocalizations.of(context)!.productionStage, _stageLabel(context, job.stage)),
            ],
          ),
        ),
      );

  Widget _detailRow(String label, String value) => LayoutBuilder(
        builder: (context, constraints) {
          // Keep quantity and stage values inside compact job cards.
          if (constraints.maxWidth < 280) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.secondaryText)),
                Text(value, style: const TextStyle(color: AppColors.mainText, fontWeight: FontWeight.w600)),
              ],
            );
          }
          return Row(children: [
            Expanded(child: Text(label, style: const TextStyle(color: AppColors.secondaryText))),
            Flexible(child: Text(value, textAlign: TextAlign.end, style: const TextStyle(color: AppColors.mainText, fontWeight: FontWeight.w600))),
          ]);
        },
      );

  Widget _stageBadge(ProductionStage stage) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _stageLabel(context, stage),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _statusBadge(ProductionStatus status) {
    final (foreground, background) = switch (status) {
      ProductionStatus.inProgress => (
          AppColors.mainText,
          Theme.of(context).colorScheme.tertiaryContainer,
        ),
      ProductionStatus.completed => (AppColors.success, AppColors.successBackground),
      ProductionStatus.pending => (
          AppColors.mainText,
          Theme.of(context).colorScheme.primaryContainer,
        ),
      ProductionStatus.delayed => (AppColors.warning, AppColors.warningBackground),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _statusLabel(context, status),
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _emptyState() => Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(Icons.precision_manufacturing_outlined,
                size: 42, color: AppColors.mainText),
            SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noJobs,
              style: TextStyle(
                color: AppColors.mainText,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Text(
              AppLocalizations.of(context)!.noJobsHint,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ],
        ),
      );
}

String _stageLabel(BuildContext context, ProductionStage stage) => switch (stage) {
      ProductionStage.cutting => AppLocalizations.of(context)!.cutting,
      ProductionStage.sewing => AppLocalizations.of(context)!.sewing,
      ProductionStage.finishing => AppLocalizations.of(context)!.finishing,
      ProductionStage.qualityControl => AppLocalizations.of(context)!.qualityControl,
    };

String _statusLabel(BuildContext context, ProductionStatus status) => switch (status) {
      ProductionStatus.inProgress => AppLocalizations.of(context)!.inProgress,
      ProductionStatus.completed => AppLocalizations.of(context)!.completed,
      ProductionStatus.pending => AppLocalizations.of(context)!.pending,
      ProductionStatus.delayed => AppLocalizations.of(context)!.delayed,
    };

String _formatQuantity(int quantity) => quantity.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
