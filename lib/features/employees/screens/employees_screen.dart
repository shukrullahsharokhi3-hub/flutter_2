import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/employee.dart';

enum _EmployeeStatusFilter { all, active, inactive }

/// Employee records are held in memory for this demo session only.
class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final _searchController = TextEditingController();
  _EmployeeStatusFilter _statusFilter = _EmployeeStatusFilter.all;
  final List<Employee> _employees = [
    Employee(employeeId: 'EMP-001', fullName: 'Nadia Farzan', position: 'Pattern Maker', department: 'Design', phone: '+93 700 000 101', email: 'nadia.farzan@example.test', active: true, hireDate: DateTime(2021, 3, 15)),
    Employee(employeeId: 'EMP-002', fullName: 'Samiullah Noor', position: 'Production Supervisor', department: 'Production', phone: '+93 700 000 102', email: 'samiullah.noor@example.test', active: true, hireDate: DateTime(2020, 8, 2)),
    Employee(employeeId: 'EMP-003', fullName: 'Laila Hashimi', position: 'Quality Inspector', department: 'Quality', phone: '+93 700 000 103', email: 'laila.hashimi@example.test', active: true, hireDate: DateTime(2022, 1, 10)),
    Employee(employeeId: 'EMP-004', fullName: 'Omid Rahman', position: 'Cutting Operator', department: 'Cutting', phone: '+93 700 000 104', email: 'omid.rahman@example.test', active: false, hireDate: DateTime(2019, 11, 4)),
    Employee(employeeId: 'EMP-005', fullName: 'Zahra Wali', position: 'Finance Clerk', department: 'Finance', phone: '+93 700 000 105', email: 'zahra.wali@example.test', active: true, hireDate: DateTime(2023, 6, 19)),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Employee> get _filteredEmployees {
    final query = _searchController.text.trim().toLowerCase();
    return _employees.where((employee) {
      final matchesQuery = query.isEmpty || [
        employee.fullName,
        employee.employeeId,
        employee.position,
        employee.department,
      ].any((value) => value.toLowerCase().contains(query));
      final matchesStatus = switch (_statusFilter) {
        _EmployeeStatusFilter.all => true,
        _EmployeeStatusFilter.active => employee.active,
        _EmployeeStatusFilter.inactive => !employee.active,
      };
      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final compact = MediaQuery.sizeOf(context).width < 700;
    final activeCount = _employees.where((employee) => employee.active).length;
    final inactiveCount = _employees.length - activeCount;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: Text(strings.employees),
        leading: IconButton(
          tooltip: strings.backToDashboard,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(compact ? 16 : 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(strings.employees, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text(strings.employeesDescription, style: const TextStyle(color: AppColors.secondaryText)),
                const SizedBox(height: 14),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                  onPressed: () => _editEmployee(),
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(strings.addEmployee),
                )),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: _summary(strings.totalEmployees, _employees.length, Icons.groups_outlined)),
                  const SizedBox(width: 8),
                  Expanded(child: _summary(strings.active, activeCount, Icons.verified_outlined)),
                  const SizedBox(width: 8),
                  Expanded(child: _summary(strings.inactive, inactiveCount, Icons.person_off_outlined)),
                ]),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: strings.searchEmployees,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isEmpty ? null : IconButton(
                      tooltip: strings.clearSearch,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () { _searchController.clear(); setState(() {}); },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<_EmployeeStatusFilter>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: _EmployeeStatusFilter.all, label: Text(strings.allStatuses)),
                    ButtonSegment(value: _EmployeeStatusFilter.active, label: Text(strings.active)),
                    ButtonSegment(value: _EmployeeStatusFilter.inactive, label: Text(strings.inactive)),
                  ],
                  selected: {_statusFilter},
                  onSelectionChanged: (selection) => setState(() => _statusFilter = selection.first),
                ),
                const SizedBox(height: 14),
                if (_filteredEmployees.isEmpty)
                  _emptyState(strings.noMatchingEmployees)
                else
                  ..._filteredEmployees.map(_employeeCard),
                const SizedBox(height: 8),
                Text(strings.employeesDemoNotice, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summary(String label, int count, IconData icon) => Container(
    constraints: const BoxConstraints(minHeight: 78),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
    child: Column(children: [
      Icon(icon, size: 19, color: Theme.of(context).colorScheme.primary),
      const SizedBox(height: 4),
      Text('$count', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
      Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.secondaryText, fontSize: 11)),
    ]),
  );

  Widget _employeeCard(Employee employee) {
    final strings = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.border)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primaryContainer, foregroundColor: Theme.of(context).colorScheme.primary, child: const Icon(Icons.badge_outlined)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(employee.fullName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Text(employee.employeeId, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
            ])),
            _statusPill(employee.active),
            PopupMenuButton<String>(
              tooltip: strings.employeeActions,
              onSelected: (action) {
                if (action == 'view') _viewEmployee(employee);
                if (action == 'edit') _editEmployee(employee);
                if (action == 'delete') _confirmDelete(employee);
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'view', child: Text(strings.viewDetails)),
                PopupMenuItem(value: 'edit', child: Text(strings.edit)),
                PopupMenuItem(value: 'delete', child: Text(strings.delete)),
              ],
            ),
          ]),
          const SizedBox(height: 10),
          _detail(Icons.work_outline_rounded, employee.position),
          _detail(Icons.apartment_rounded, employee.department),
          _detail(Icons.phone_outlined, employee.phone),
          if (employee.email.isNotEmpty) _detail(Icons.mail_outline_rounded, employee.email),
        ]),
      ),
    );
  }

  Widget _detail(IconData icon, String value) => Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Row(children: [Icon(icon, size: 16, color: AppColors.secondaryText), const SizedBox(width: 8), Expanded(child: Text(value, style: const TextStyle(color: AppColors.secondaryText, fontSize: 13))) ]),
  );

  Widget _statusPill(bool active) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(color: active ? AppColors.successBackground : AppColors.inactiveBackground, borderRadius: BorderRadius.circular(18)),
      child: Text(active ? strings.active : strings.inactive, style: TextStyle(color: active ? AppColors.success : AppColors.secondaryText, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _emptyState(String message) => Container(
    padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 16),
    decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
    child: Column(children: [const Icon(Icons.badge_outlined, size: 36, color: AppColors.secondaryText), const SizedBox(height: 8), Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.secondaryText))]),
  );

  Future<void> _viewEmployee(Employee employee) async {
    final strings = AppLocalizations.of(context)!;
    await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
      title: Text(employee.fullName),
      content: SizedBox(
        width: (MediaQuery.sizeOf(context).width - 72).clamp(0.0, 400.0),
        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _info(strings.employeeIdLabel, employee.employeeId),
          _info(strings.positionLabel, employee.position),
          _info(strings.departmentLabel, employee.department),
          _info(strings.phoneLabel, employee.phone),
          _info(strings.emailLabel, employee.email),
          _info(strings.statusLabel, employee.active ? strings.active : strings.inactive),
          _info(strings.hireDateLabel, _formatDate(employee.hireDate)),
        ])),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(strings.close))],
    ));
  }

  Widget _info(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)), const SizedBox(height: 2), Text(value.isEmpty ? AppLocalizations.of(context)!.notProvided : value)]),
  );

  String _formatDate(DateTime date) => DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(date);

  Future<void> _editEmployee([Employee? employee]) async {
    final result = await showDialog<Employee>(context: context, builder: (_) => _EmployeeFormDialog(employee: employee));
    if (result == null || !mounted) return;
    setState(() {
      if (employee == null) {
        _employees.add(result);
      } else {
        final index = _employees.indexOf(employee);
        if (index >= 0) _employees[index] = result;
      }
    });
  }

  Future<void> _confirmDelete(Employee employee) async {
    final strings = AppLocalizations.of(context)!;
    final shouldDelete = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
      title: Text(strings.deleteEmployeeQuestion),
      content: Text(strings.deleteEmployeePrompt),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(strings.cancel)),
        TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(strings.delete, style: const TextStyle(color: AppColors.error))),
      ],
    ));
    if (shouldDelete == true && mounted) setState(() => _employees.remove(employee));
  }
}

class _EmployeeFormDialog extends StatefulWidget {
  const _EmployeeFormDialog({this.employee});
  final Employee? employee;

  @override
  State<_EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends State<_EmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _id;
  late final TextEditingController _name;
  late final TextEditingController _position;
  late final TextEditingController _department;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late DateTime _hireDate;
  late bool _active;

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    _id = TextEditingController(text: employee?.employeeId ?? '');
    _name = TextEditingController(text: employee?.fullName ?? '');
    _position = TextEditingController(text: employee?.position ?? '');
    _department = TextEditingController(text: employee?.department ?? '');
    _phone = TextEditingController(text: employee?.phone ?? '');
    _email = TextEditingController(text: employee?.email ?? '');
    _hireDate = employee?.hireDate ?? DateTime.now();
    _active = employee?.active ?? true;
  }

  @override
  void dispose() {
    _id.dispose(); _name.dispose(); _position.dispose(); _department.dispose(); _phone.dispose(); _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.employee == null ? strings.addEmployee : strings.editEmployee),
      content: SizedBox(
        width: (MediaQuery.sizeOf(context).width - 64).clamp(0.0, 440.0),
        child: SingleChildScrollView(child: Form(key: _formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [
          _field(_id, strings.employeeIdLabel, strings.employeeIdRequired),
          _field(_name, strings.fullNameLabel, strings.employeeNameRequired),
          _field(_position, strings.positionLabel, strings.positionRequired),
          _field(_department, strings.departmentLabel, strings.departmentRequired),
          _field(_phone, strings.phoneLabel, strings.phoneRequired),
          _field(_email, strings.emailLabel, null, keyboardType: TextInputType.emailAddress, validator: (value) {
            final email = value?.trim() ?? '';
            if (email.isNotEmpty && !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) return strings.validEmail;
            return null;
          }),
          const SizedBox(height: 8),
          Align(alignment: AlignmentDirectional.centerStart, child: Text(strings.hireDateLabel, style: Theme.of(context).textTheme.labelLarge)),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: () async {
              final selected = await showDatePicker(context: context, initialDate: _hireDate, firstDate: DateTime(1980), lastDate: DateTime(2100));
              if (selected != null && mounted) setState(() => _hireDate = selected);
            },
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(_formatDate(_hireDate)),
          ),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(strings.statusLabel), subtitle: Text(_active ? strings.active : strings.inactive), value: _active, onChanged: (value) => setState(() => _active = value)),
        ]))),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(strings.cancel)),
        ElevatedButton(onPressed: _save, child: Text(strings.saveChanges)),
      ],
    );
  }

  Widget _field(TextEditingController controller, String label, String? requiredMessage, {TextInputType? keyboardType, String? Function(String?)? validator}) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextFormField(controller: controller, keyboardType: keyboardType, decoration: InputDecoration(labelText: label), validator: validator ?? (value) => requiredMessage != null && (value == null || value.trim().isEmpty) ? requiredMessage : null),
  );

  String _formatDate(DateTime date) => DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(date);

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, Employee(
      employeeId: _id.text.trim(), fullName: _name.text.trim(), position: _position.text.trim(),
      department: _department.text.trim(), phone: _phone.text.trim(), email: _email.text.trim(),
      active: _active, hireDate: _hireDate,
    ));
  }
}
