import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Customer changes live only in this screen's state for the current session.
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _searchController = TextEditingController();
  final List<Customer> _customers = [
    Customer(
        name: 'Amina Rahimi',
        phone: '+93 700 123 456',
        company: 'Kabul Fashion House',
        email: 'amina@kabulfashion.af',
        address: 'Shahr-e-Naw, Kabul'),
    Customer(
        name: 'Farid Ahmad',
        phone: '+93 790 234 567',
        company: 'Herat Textile Group',
        email: 'farid@herattextile.af',
        address: 'Herat, Afghanistan'),
    Customer(
        name: 'Laila Safi',
        phone: '+93 780 345 678',
        company: 'Safi Uniforms',
        address: 'Mazar-e-Sharif, Afghanistan'),
    Customer(
        name: 'Omar Khan',
        phone: '+93 770 456 789',
        company: 'North Star Apparel',
        email: 'omar@northstar.af',
        address: 'Kandahar, Afghanistan',
        active: false),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Search stays local and checks each contact detail as the user types.
  List<Customer> get _filteredCustomers {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _customers;
    return _customers
        .where((customer) =>
            customer.name.toLowerCase().contains(query) ||
            customer.phone.toLowerCase().contains(query) ||
            customer.company.toLowerCase().contains(query) ||
            customer.email.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // This screen fills the available window, so read its responsive breakpoint
    // during build instead of constructing the scrollable table from layout.
    final compact = MediaQuery.sizeOf(context).width < 700;
    final customers = _filteredCustomers;

    return Scaffold(
      // Use the shared white page surface from the approved palette.
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.customers),
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
                  Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(AppLocalizations.of(context)!.customers,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 5),
                          Text(
                              AppLocalizations.of(context)!.manageCustomers,
                              style: TextStyle(color: AppColors.secondaryText)),
                        ])),
                    if (!compact) _addButton(),
                  ]),
                  if (compact) ...[const SizedBox(height: 16), _addButton()],
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(
                        child: _summaryCard(AppLocalizations.of(context)!.totalCustomers,
                            '${_customers.length}', Icons.groups_outlined)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _summaryCard(
                            AppLocalizations.of(context)!.activeCustomers,
                            '${_customers.where((c) => c.active).length}',
                            Icons.verified_outlined)),
                  ]),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchCustomers,
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
                  ),
                  const SizedBox(height: 16),
                  if (_customers.isEmpty)
                    _emptyState(AppLocalizations.of(context)!.noCustomers,
                        AppLocalizations.of(context)!.addFirstCustomer)
                  else if (customers.isEmpty)
                    _emptyState(AppLocalizations.of(context)!.searchNoCustomers,
                        AppLocalizations.of(context)!.searchCustomerHint)
                  else if (compact)
                    ...customers.map(_customerCard)
                  else
                    _customerTable(customers),
                  const SizedBox(height: 16),
                  Text(
                      AppLocalizations.of(context)!.localSessionData,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.secondaryText, fontSize: 12)),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _addButton() => ElevatedButton.icon(
        onPressed: () => _editCustomer(),
        icon: const Icon(Icons.add_rounded), label: Text(AppLocalizations.of(context)!.addCustomer),
        // The shared theme sets an infinite minimum width; this button sits beside
        // Expanded in the wide header Row, so keep its minimum width finite.
        style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
      );

  Widget _summaryCard(String label, String value, IconData icon) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border)),
        child: Row(children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(11)),
              // Purple icons reinforce the brand on a soft purple tile.
              child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 21)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainText)),
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.secondaryText)),
              ])),
        ]),
      );

  Widget _customerTable(List<Customer> customers) => Container(
        decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                // Fill the card on wide screens and retain horizontal scrolling
                // when the columns need more room than a narrow viewport.
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primaryContainer,
                ),
                // The soft purple header keeps table labels distinct.
                headingTextStyle: const TextStyle(
                    color: AppColors.mainText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
                columns: [
                  DataColumn(label: Text(AppLocalizations.of(context)!.customerColumn)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.phoneColumn)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.companyColumn)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.addressColumn)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.emailColumn)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.statusColumn)),
                  DataColumn(label: Text(AppLocalizations.of(context)!.actionsColumn))
                ],
                rows: customers
                    .map((customer) => DataRow(cells: [
                          DataCell(Text(customer.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600))),
                          DataCell(Text(customer.phone)),
                          DataCell(Text(customer.company)),
                          DataCell(Text(customer.address.isEmpty
                              ? '—'
                              : customer.address)),
                          DataCell(Text(
                              customer.email.isEmpty ? '—' : customer.email)),
                          DataCell(_status(customer.active)),
                          DataCell(_actions(customer)),
                        ]))
                    .toList(),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _customerCard(Customer customer) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(customer.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.mainText))),
                _status(customer.active),
                _actions(customer),
              ]),
              const SizedBox(height: 12),
              _detail(Icons.phone_outlined, customer.phone),
              _detail(Icons.business_outlined, customer.company),
              if (customer.address.isNotEmpty)
                _detail(Icons.location_on_outlined, customer.address),
              if (customer.email.isNotEmpty)
                _detail(Icons.mail_outline_rounded, customer.email),
            ])),
      );

  Widget _detail(IconData icon, String value) => Padding(
        padding: const EdgeInsets.only(top: 7),
        child: Row(children: [
          Icon(icon, size: 16, color: AppColors.mainText),
          const SizedBox(width: 8),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      color: AppColors.secondaryText, fontSize: 13)))
        ]),
      );

  Widget _status(bool active) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: active
                ? AppColors.successBackground
                : AppColors.inactiveBackground,
            borderRadius: BorderRadius.circular(20)),
        child: Text(active ? AppLocalizations.of(context)!.active : AppLocalizations.of(context)!.inactive,
            style: TextStyle(
                color: active ? AppColors.success : AppColors.secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      );

  Widget _actions(Customer customer) => PopupMenuButton<String>(
        tooltip: AppLocalizations.of(context)!.customerActions,
        icon: const Icon(Icons.more_vert_rounded,
            color: AppColors.secondaryText, size: 20),
        onSelected: (action) {
          if (action == 'view') {
            _viewCustomer(customer);
          } else if (action == 'edit') {
            _editCustomer(customer);
          } else {
            _confirmDelete(customer);
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(value: 'view', child: Text(AppLocalizations.of(context)!.viewDetails)),
          PopupMenuItem(value: 'edit', child: Text(AppLocalizations.of(context)!.edit)),
          PopupMenuItem(value: 'delete', child: Text(AppLocalizations.of(context)!.delete))
        ],
      );

  // Show all stored details and allow editing directly from the view dialog.
  Future<void> _viewCustomer(Customer customer) async {
    final shouldEdit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(customer.name),
        content: SizedBox(
          // Keep the detail dialog within phone width and allow short screens to scroll.
          width: (MediaQuery.sizeOf(context).width - 80)
              .clamp(0.0, 420.0)
              .toDouble(),
          child: SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _customerInfo(AppLocalizations.of(context)!.companyColumn, customer.company),
              _customerInfo(AppLocalizations.of(context)!.phoneColumn, customer.phone),
              _customerInfo(AppLocalizations.of(context)!.emailColumn, customer.email),
              _customerInfo(AppLocalizations.of(context)!.addressColumn, customer.address),
              _customerInfo(AppLocalizations.of(context)!.statusColumn, customer.active ? AppLocalizations.of(context)!.active : AppLocalizations.of(context)!.inactive),
            ],
          )),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppLocalizations.of(context)!.close),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppLocalizations.of(context)!.editCustomer),
          ),
        ],
      ),
    );
    if (shouldEdit == true && mounted) _editCustomer(customer);
  }

  Widget _customerInfo(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.secondaryText, fontSize: 12)),
            const SizedBox(height: 3),
            Text(value.isEmpty ? AppLocalizations.of(context)!.notProvided : value,
                style: const TextStyle(color: AppColors.mainText)),
          ],
        ),
      );

  Widget _emptyState(String title, String message) => Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
        decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border)),
        child: Column(children: [
          const Icon(Icons.groups_outlined,
              size: 42, color: AppColors.mainText),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  color: AppColors.mainText,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          const SizedBox(height: 5),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.secondaryText))
        ]),
      );

  Future<void> _editCustomer([Customer? customer]) async {
    final result = await showDialog<Customer>(
        context: context,
        builder: (_) => _CustomerFormDialog(customer: customer));
    if (result == null || !mounted) return;
    setState(() {
      if (customer == null) {
        _customers.add(result);
      } else {
        final index = _customers.indexOf(customer);
        if (index >= 0) _customers[index] = result;
      }
    });
  }

  Future<void> _confirmDelete(Customer customer) async {
    final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.deleteCustomerQuestion),
              content: Text(AppLocalizations.of(context)!.deleteCustomerPrompt),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(AppLocalizations.of(context)!.cancel)),
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(AppLocalizations.of(context)!.delete,
                        style: TextStyle(color: AppColors.error)))
              ],
            ));
    if (shouldDelete == true && mounted)
      setState(() => _customers.remove(customer));
  }
}

class Customer {
  Customer(
      {required this.name,
      required this.phone,
      required this.company,
      this.email = '',
      this.address = '',
      this.active = true});
  final String name;
  final String phone;
  final String company;
  final String email;
  final String address;
  final bool active;
}

class _CustomerFormDialog extends StatefulWidget {
  const _CustomerFormDialog({this.customer});
  final Customer? customer;

  @override
  State<_CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<_CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _company;
  late final TextEditingController _email;
  late final TextEditingController _address;

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _name = TextEditingController(text: customer?.name ?? '');
    _phone = TextEditingController(text: customer?.phone ?? '');
    _company = TextEditingController(text: customer?.company ?? '');
    _email = TextEditingController(text: customer?.email ?? '');
    _address = TextEditingController(text: customer?.address ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _company.dispose();
    _email.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.customer == null
            ? AppLocalizations.of(context)!.addCustomerTitle
            : AppLocalizations.of(context)!.editCustomerTitle),
        content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _field(_name, AppLocalizations.of(context)!.fullNameRequired,
                    requiredMessage: AppLocalizations.of(context)!.customerNameRequired),
                _field(_phone, AppLocalizations.of(context)!.phoneRequiredLabel,
                    requiredMessage: AppLocalizations.of(context)!.phoneRequired),
                _field(_company, AppLocalizations.of(context)!.companyName),
                _field(_email, AppLocalizations.of(context)!.emailAddress,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isNotEmpty &&
                      !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email))
                    return AppLocalizations.of(context)!.validEmail;
                  return null;
                }),
                _field(_address, AppLocalizations.of(context)!.address, maxLines: 2),
              ]),
            ))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel)),
          ElevatedButton(
              onPressed: _save,
              child: Text(
                  widget.customer == null
                      ? AppLocalizations.of(context)!.addCustomer
                      : AppLocalizations.of(context)!.saveChanges)),
        ],
      );

  Widget _field(TextEditingController controller, String label,
          {String? requiredMessage,
          TextInputType? keyboardType,
          int maxLines = 1,
          String? Function(String?)? validator}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(labelText: label),
            // Required values and optional email are validated with actionable messages.
            validator: validator ??
                (requiredMessage == null
                    ? null
                    : (value) => value == null || value.trim().isEmpty
                        ? requiredMessage
                        : null)),
      );

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
        context,
        Customer(
            name: _name.text.trim(),
            phone: _phone.text.trim(),
            company: _company.text.trim(),
            email: _email.text.trim(),
            address: _address.text.trim(),
            active: widget.customer?.active ?? true));
  }
}
