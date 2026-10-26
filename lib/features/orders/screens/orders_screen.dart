import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _searchController = TextEditingController();
  OrderStatus? _statusFilter;
  final List<Order> _orders = [
    Order(
      number: 'GF-24018',
      customerName: 'Amina Rahimi',
      orderDate: DateTime(2026, 9, 12),
      deliveryDate: DateTime(2026, 10, 12),
      totalAmount: 4850,
      status: OrderStatus.completed,
    ),
    Order(
      number: 'GF-24021',
      customerName: 'Farid Ahmad',
      orderDate: DateTime(2026, 9, 22),
      deliveryDate: DateTime(2026, 10, 22),
      totalAmount: 7320.50,
      status: OrderStatus.inProgress,
    ),
    Order(
      number: 'GF-24025',
      customerName: 'Laila Safi',
      orderDate: DateTime(2026, 10, 1),
      deliveryDate: DateTime(2026, 11, 1),
      totalAmount: 2960,
      status: OrderStatus.pending,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Order> get _filteredOrders {
    final query = _searchController.text.trim().toLowerCase();
    return _orders
        .where((order) =>
            (query.isEmpty ||
                order.number.toLowerCase().contains(query) ||
                order.customerName.toLowerCase().contains(query)) &&
            (_statusFilter == null || order.status == _statusFilter))
        .toList();
  }

  // Counts always reflect the full local list, regardless of active filters.
  int _countFor(OrderStatus status) =>
      _orders.where((order) => order.status == status).length;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;
    final orders = _filteredOrders;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orders),
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.orders,
                            style: TextStyle(
                              color: AppColors.mainText,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.ordersDescription,
                            style: TextStyle(color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    if (!compact) _addOrderButton(),
                  ],
                ),
                if (compact) ...[
                  const SizedBox(height: 16),
                  _addOrderButton(),
                ],
                const SizedBox(height: 20),
                _summaryCards(compact),
                const SizedBox(height: 18),
                _filterControls(compact),
                const SizedBox(height: 16),
                if (orders.isEmpty)
                  _emptyState()
                else if (compact)
                  ...orders.map(_orderCard)
                else
                  _ordersTable(orders),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.localSessionData,
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

  Widget _addOrderButton() => ElevatedButton.icon(
        onPressed: _addOrder,
        icon: const Icon(Icons.add_rounded),
        label: Text(AppLocalizations.of(context)!.addOrder),
        // The shared theme uses Size.fromHeight, whose width is infinite.
        // This button sits beside Expanded in a Row on wide screens, so give
        // it a finite minimum width and let its parent size it when compact.
        style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
      );

  Widget _summaryCards(bool compact) => LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = compact
              ? (constraints.maxWidth - 12) / 2
              : (constraints.maxWidth - 12 * 3) / 4;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: cardWidth,
                child: _summaryCard(
                    AppLocalizations.of(context)!.totalOrders, '${_orders.length}', Icons.receipt_long),
              ),
              SizedBox(
                width: cardWidth,
                child: _summaryCard(AppLocalizations.of(context)!.inProgress,
                    '${_countFor(OrderStatus.inProgress)}', Icons.sync),
              ),
              SizedBox(
                width: cardWidth,
                child: _summaryCard(AppLocalizations.of(context)!.completed,
                    '${_countFor(OrderStatus.completed)}', Icons.check_circle),
              ),
              SizedBox(
                width: cardWidth,
                child: _summaryCard(AppLocalizations.of(context)!.pending,
                    '${_countFor(OrderStatus.pending)}', Icons.schedule),
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
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
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
        hintText: AppLocalizations.of(context)!.searchOrders,
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
    final statusFilter = DropdownButtonFormField<OrderStatus?>(
      initialValue: _statusFilter,
      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.filterByStatus),
      items: [
        DropdownMenuItem<OrderStatus?>(
            value: null, child: Text(AppLocalizations.of(context)!.allStatuses)),
        ...OrderStatus.values.map(
          (status) => DropdownMenuItem<OrderStatus?>(
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

  Widget _ordersTable(List<Order> orders) => Container(
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
                // Dark heading text remains readable on the purple header fill.
                color: AppColors.mainText,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              columns: [
                DataColumn(label: Text(AppLocalizations.of(context)!.orderNumberColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.customerColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.orderDateColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.deliveryDateColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.statusColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.totalAmountColumn)),
                DataColumn(label: Text(AppLocalizations.of(context)!.actionsColumn)),
              ],
              rows: orders
                  .map(
                    (order) => DataRow(
                      cells: [
                        DataCell(Text(order.number)),
                        DataCell(Text(order.customerName)),
                        DataCell(Text(_formatDate(order.orderDate))),
                        DataCell(Text(_formatDate(order.deliveryDate))),
                        DataCell(_statusBadge(order.status)),
                        DataCell(Text(_formatAmount(order.totalAmount))),
                        DataCell(_orderActions(order)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );

  Widget _orderCard(Order order) => Card(
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
                      order.number,
                      style: const TextStyle(
                        color: AppColors.mainText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _statusBadge(order.status),
                  _orderActions(order),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                order.customerName,
                style: const TextStyle(color: AppColors.secondaryText),
              ),
              const Divider(height: 24),
              _detailRow(AppLocalizations.of(context)!.orderDate, _formatDate(order.orderDate)),
              const SizedBox(height: 8),
              _detailRow(AppLocalizations.of(context)!.deliveryDate, _formatDate(order.deliveryDate)),
              const SizedBox(height: 8),
              _detailRow(AppLocalizations.of(context)!.totalAmount, _formatAmount(order.totalAmount)),
            ],
          ),
        ),
      );

  Widget _detailRow(String label, String value) => LayoutBuilder(
        builder: (context, constraints) {
          // Stack long values on narrow cards and dialogs to prevent row overflow.
          if (constraints.maxWidth < 280) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.secondaryText)),
                Text(value, style: const TextStyle(
                  color: AppColors.mainText, fontWeight: FontWeight.w600,
                )),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(color: AppColors.secondaryText))),
              Flexible(child: Text(value, textAlign: TextAlign.end, style: const TextStyle(
                color: AppColors.mainText, fontWeight: FontWeight.w600,
              ))),
            ],
          );
        },
      );

  Widget _orderActions(Order order) => PopupMenuButton<String>(
        tooltip: AppLocalizations.of(context)!.orderActions,
        icon: const Icon(Icons.more_vert_rounded,
            color: AppColors.secondaryText, size: 20),
        onSelected: (action) {
          if (action == 'view') {
            _viewOrder(order);
          } else if (action == 'edit') {
            _editOrder(order);
          } else {
            _deleteOrder(order);
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(value: 'view', child: Text(AppLocalizations.of(context)!.viewDetails)),
          PopupMenuItem(value: 'edit', child: Text(AppLocalizations.of(context)!.edit)),
          PopupMenuItem(value: 'delete', child: Text(AppLocalizations.of(context)!.delete)),
        ],
      );

  Future<void> _viewOrder(Order order) async {
    final shouldEdit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(order.number),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(AppLocalizations.of(context)!.customerColumn, order.customerName),
            const SizedBox(height: 10),
            _detailRow(AppLocalizations.of(context)!.orderDate, _formatDate(order.orderDate)),
            const SizedBox(height: 10),
            _detailRow(AppLocalizations.of(context)!.deliveryDate, _formatDate(order.deliveryDate)),
            const SizedBox(height: 10),
            _detailRow(AppLocalizations.of(context)!.totalAmount, _formatAmount(order.totalAmount)),
            const SizedBox(height: 10),
            _detailRow(AppLocalizations.of(context)!.statusColumn, _statusLabel(context, order.status)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppLocalizations.of(context)!.close),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppLocalizations.of(context)!.editOrder),
          ),
        ],
      ),
    );
    if (shouldEdit == true && mounted) _editOrder(order);
  }

  Future<void> _editOrder(Order order) async {
    final updatedOrder = await showDialog<Order>(
      context: context,
      builder: (_) => _AddOrderDialog(order: order),
    );
    if (updatedOrder == null || !mounted) return;
    setState(() {
      final index = _orders.indexOf(order);
      if (index >= 0) _orders[index] = updatedOrder;
    });
  }

  Future<void> _deleteOrder(Order order) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteOrderQuestion),
        content: Text(AppLocalizations.of(context)!.deleteOrderPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppLocalizations.of(context)!.delete,
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (shouldDelete == true && mounted) {
      setState(() => _orders.remove(order));
    }
  }

  Widget _statusBadge(OrderStatus status) {
    final (foreground, background) = switch (status) {
      OrderStatus.pending => (AppColors.warning, AppColors.warningBackground),
      OrderStatus.inProgress => (
          AppColors.mainText,
          Theme.of(context).colorScheme.tertiaryContainer,
        ),
      OrderStatus.completed => (AppColors.success, AppColors.successBackground),
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
            Icon(Icons.receipt_long_outlined,
                size: 42, color: AppColors.mainText),
            SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noMatchingOrders,
              style: TextStyle(
                color: AppColors.mainText,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Text(
              AppLocalizations.of(context)!.noOrdersHint,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ],
        ),
      );

  Future<void> _addOrder() async {
    final order = await showDialog<Order>(
      context: context,
      builder: (_) => const _AddOrderDialog(),
    );
    if (order == null || !mounted) return;
    setState(() => _orders.insert(0, order));
  }
}

class _AddOrderDialog extends StatefulWidget {
  const _AddOrderDialog({this.order});

  final Order? order;

  @override
  State<_AddOrderDialog> createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<_AddOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _customerController = TextEditingController();
  final _amountController = TextEditingController();
  late DateTime _orderDate;
  late DateTime _deliveryDate;
  OrderStatus _status = OrderStatus.pending;

  @override
  void initState() {
    super.initState();
    final order = widget.order;
    _numberController.text = order?.number ?? '';
    _customerController.text = order?.customerName ?? '';
    _amountController.text = order?.totalAmount.toString() ?? '';
    _orderDate = order?.orderDate ?? _dateOnly(DateTime.now());
    _deliveryDate = order?.deliveryDate ??
        _dateOnly(DateTime.now()).add(const Duration(days: 30));
    _status = order?.status ?? OrderStatus.pending;
  }

  @override
  void dispose() {
    _numberController.dispose();
    _customerController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialogWidth =
        (MediaQuery.sizeOf(context).width - 48).clamp(0.0, 520.0).toDouble();

    return AlertDialog(
      title: Text(widget.order == null
          ? AppLocalizations.of(context)!.addOrder
          : AppLocalizations.of(context)!.editOrder),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.orderNumber),
                  validator: _requiredField,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _customerController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.customerName),
                  validator: _requiredField,
                ),
                const SizedBox(height: 14),
                _dateField(
                  label: AppLocalizations.of(context)!.orderDate,
                  value: _orderDate,
                  onPressed: () => _selectDate(isDeliveryDate: false),
                ),
                const SizedBox(height: 12),
                _dateField(
                  label: AppLocalizations.of(context)!.deliveryDate,
                  value: _deliveryDate,
                  onPressed: () => _selectDate(isDeliveryDate: true),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.totalAmount,
                    prefixText: '\$ ',
                  ),
                  validator: (value) {
                    final text = (value ?? '').trim();
                    if (text.isEmpty) return AppLocalizations.of(context)!.enterTotalAmount;
                    final amount = double.tryParse(text);
                    if (amount == null) return AppLocalizations.of(context)!.validAmount;
                    if (!amount.isFinite) return AppLocalizations.of(context)!.validAmount;
                    if (amount < 0) return AppLocalizations.of(context)!.negativeAmount;
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<OrderStatus>(
                  initialValue: _status,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.orderStatus),
                  items: OrderStatus.values
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(_statusLabel(context, status)),
                        ),
                      )
                      .toList(),
                  onChanged: (status) {
                    if (status != null) setState(() => _status = status);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(widget.order == null
              ? AppLocalizations.of(context)!.addOrder
              : AppLocalizations.of(context)!.saveChanges),
        ),
      ],
    );
  }

  Widget _dateField({
    required String label,
    required DateTime value,
    required VoidCallback onPressed,
  }) =>
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.calendar_today_outlined, size: 18),
        label: Text('$label: ${_formatDate(value)}'),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          minimumSize: const Size(0, 48),
        ),
      );

  Future<void> _selectDate({required bool isDeliveryDate}) async {
    final currentDate = isDeliveryDate ? _deliveryDate : _orderDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isDeliveryDate) {
        _deliveryDate = picked;
      } else {
        _orderDate = picked;
      }
    });
  }

  String? _requiredField(String? value) =>
      (value == null || value.trim().isEmpty)
          ? AppLocalizations.of(context)!.fieldRequired
          : null;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_deliveryDate.isBefore(_orderDate)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.deliveryDateError),
      ));
      return;
    }
    Navigator.of(context).pop(
      Order(
        number: _numberController.text.trim(),
        customerName: _customerController.text.trim(),
        orderDate: _orderDate,
        deliveryDate: _deliveryDate,
        totalAmount: double.parse(_amountController.text.trim()),
        status: _status,
      ),
    );
  }
}

String _statusLabel(BuildContext context, OrderStatus status) => switch (status) {
      OrderStatus.pending => AppLocalizations.of(context)!.pending,
      OrderStatus.inProgress => AppLocalizations.of(context)!.inProgress,
      OrderStatus.completed => AppLocalizations.of(context)!.completed,
    };

String _formatDate(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

String _formatAmount(double amount) => '\$${amount.toStringAsFixed(2)}';
