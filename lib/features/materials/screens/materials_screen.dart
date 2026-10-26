import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_selector.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/routing/route_names.dart';
import '../../../features/dashboard/screens/dashboard_screen.dart';
import '../../../l10n/generated/app_localizations.dart';

const _demoMaterials = <_MaterialRecord>[
  _MaterialRecord(
      code: 'FAB-001',
      name: 'Cotton Twill',
      type: 'Fabric',
      unit: 'Meter',
      description: 'Mid-weight cotton fabric'),
  _MaterialRecord(
      code: 'FAB-002',
      name: 'Polyester Lining',
      type: 'Fabric',
      unit: 'Meter',
      description: 'Black lining fabric'),
  _MaterialRecord(
      code: 'ACC-001',
      name: 'Sewing Thread',
      type: 'Accessory',
      unit: 'Piece',
      description: 'Polyester thread, assorted colors'),
  _MaterialRecord(
      code: 'ACC-002',
      name: 'Metal Button',
      type: 'Accessory',
      unit: 'Piece',
      description: 'Standard 4-hole button'),
  _MaterialRecord(
      code: 'RAW-001',
      name: 'Dye Powder',
      type: 'Other',
      unit: 'Kilogram',
      description: 'Textile dyeing material'),
];

/// Materials master screen. The demo repository is local until material API
/// endpoints are provided by the backend.
class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({required this.localeController, super.key});

  final LocaleController localeController;

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  final _searchController = TextEditingController();
  String? _typeFilter;
  String? _unitFilter;
  bool _loading = false;
  String? _error;

  // Isolated sample records make the screen usable without pretending the API exists.
  final List<_MaterialRecord> _materials = [..._demoMaterials];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_MaterialRecord> get _filteredMaterials {
    final query = _searchController.text.trim().toLowerCase();
    return _materials.where((material) {
      final matchesQuery = query.isEmpty ||
          material.code.toLowerCase().contains(query) ||
          material.name.toLowerCase().contains(query) ||
          material.description.toLowerCase().contains(query);
      return matchesQuery &&
          (_typeFilter == null || material.type == _typeFilter) &&
          (_unitFilter == null || material.unit == _unitFilter);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 980;
      return Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        appBar: wide
            ? null
            : AppBar(
                title: Text(strings.materials),
                actions: [
                  LanguageSelector(controller: widget.localeController),
                  IconButton(
                    tooltip: strings.logout,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(RouteNames.login),
                    icon: const Icon(Icons.logout_rounded),
                  ),
                ],
              ),
        drawer: wide
            ? null
            : Drawer(
                child: DashboardSidebar(
                  inDrawer: true,
                  selectedRoute: RouteNames.materials,
                  darkNavy: true,
                  onUnavailable: (_) => _showMessage(strings.notImplemented),
                ),
              ),
        body: wide
            ? Row(
                children: [
                  DashboardSidebar(
                    selectedRoute: RouteNames.materials,
                    darkNavy: true,
                    onUnavailable: (_) => _showMessage(strings.notImplemented),
                  ),
                  Expanded(
                      child: _pageContent(strings, constraints.maxWidth - 252)),
                ],
              )
            : _pageContent(strings, constraints.maxWidth),
      );
    });
  }

  Widget _pageContent(AppLocalizations strings, double width) {
    final compact = width < 680;
    final padding = compact ? 16.0 : 30.0;
    return Column(
      children: [
        if (width >= 980) _desktopHeader(strings),
        if (width < 980)
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.adminUser,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(strings.administratorRole,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.secondaryText)),
              ],
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _titleRow(strings, compact),
                    const SizedBox(height: 22),
                    _filters(strings, compact),
                    const SizedBox(height: 18),
                    _materialsTable(strings),
                    const SizedBox(height: 14),
                    Text(strings.materialsDemoNotice,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.secondaryText)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _desktopHeader(AppLocalizations strings) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE3E7ED)))),
      child: Row(children: [
        Expanded(
            child: Text(strings.materials,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700))),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(strings.adminUser,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(strings.administratorRole,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.secondaryText)),
            ]),
        const SizedBox(width: 12),
        LanguageSelector(controller: widget.localeController),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pushNamed(RouteNames.login),
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: Text(strings.logout),
        ),
      ]),
    );
  }

  Widget _titleRow(AppLocalizations strings, bool compact) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 14,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: compact ? 330 : 650),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(strings.materials,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF172334))),
            const SizedBox(height: 5),
            Text(strings.materialsDescription,
                style: const TextStyle(color: Color(0xFF697586))),
          ]),
        ),
        Wrap(spacing: 10, runSpacing: 8, children: [
          OutlinedButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(strings.refresh)),
          FilledButton.icon(
              onPressed: () => _openEditor(),
              icon: const Icon(Icons.add_rounded),
              label: Text(strings.newMaterial),
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF172334),
                  foregroundColor: Colors.white)),
        ]),
      ],
    );
  }

  Widget _filters(AppLocalizations strings, bool compact) {
    final typeOptions = <String, String>{
      'Fabric': strings.fabricMaterialType,
      'Accessory': strings.accessoryMaterialType,
      'Other': strings.otherMaterialType,
    };
    final unitOptions = <String, String>{
      'Meter': strings.meterUnit,
      'Kilogram': strings.kilogramUnit,
      'Piece': strings.pieceUnit,
      'Other': strings.otherMaterialUnit,
    };
    return _Panel(
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          SizedBox(
              width: compact ? double.infinity : 340,
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                    labelText: strings.searchMaterials,
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: const OutlineInputBorder()),
              )),
          _filterDropdown(
              label: strings.materialTypeFilter,
              value: _typeFilter,
              options: typeOptions,
              onChanged: (value) => setState(() => _typeFilter = value),
              width: compact ? double.infinity : 200),
          _filterDropdown(
              label: strings.defaultUnitFilter,
              value: _unitFilter,
              options: unitOptions,
              onChanged: (value) => setState(() => _unitFilter = value),
              width: compact ? double.infinity : 200),
          OutlinedButton.icon(
            onPressed: () => setState(() {
              _searchController.clear();
              _typeFilter = null;
              _unitFilter = null;
            }),
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(strings.reset),
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown(
      {required String label,
      required String? value,
      required Map<String, String> options,
      required ValueChanged<String?> onChanged,
      required double width}) {
    return SizedBox(
        width: width,
        child: DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
              labelText: label, border: const OutlineInputBorder()),
          items: [
            DropdownMenuItem<String>(
                value: null,
                child: Text(AppLocalizations.of(context)!.allStatuses)),
            ...options.entries.map((entry) =>
                DropdownMenuItem(value: entry.key, child: Text(entry.value)))
          ],
          onChanged: onChanged,
        ));
  }

  Widget _materialsTable(AppLocalizations strings) {
    if (_loading)
      return const _Panel(
          child: Padding(
              padding: EdgeInsets.all(42),
              child: Center(child: CircularProgressIndicator())));
    if (_error != null)
      return _Panel(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                Text(_error!),
                const SizedBox(height: 12),
                OutlinedButton(
                    onPressed: _refresh, child: Text(strings.refresh)),
              ])));
    final records = _filteredMaterials;
    if (records.isEmpty) {
      final noSourceRecords = _materials.isEmpty;
      return _Panel(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.inventory_2_outlined,
              size: 38, color: Color(0xFF667085)),
          const SizedBox(height: 12),
          Text(
              noSourceRecords
                  ? strings.noMaterials
                  : strings.noMatchingMaterials,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
              noSourceRecords
                  ? strings.materialsDescription
                  : strings.searchMaterials,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF667085))),
        ]),
      ));
    }
    return _Panel(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 52,
          dataRowMinHeight: 62,
          dataRowMaxHeight: 76,
          columns: [
            DataColumn(label: Text(strings.materialCodeColumn)),
            DataColumn(label: Text(strings.materialNameColumn)),
            DataColumn(label: Text(strings.materialTypeColumn)),
            DataColumn(label: Text(strings.defaultUnitColumn)),
            DataColumn(label: Text(strings.statusColumn)),
            DataColumn(label: Text(strings.descriptionColumn)),
            DataColumn(label: Text(strings.actionsColumn)),
          ],
          rows: records
              .map((record) => DataRow(cells: [
                    DataCell(Text(record.code,
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                    DataCell(Text(record.name)),
                    DataCell(Text(_typeLabel(strings, record.type))),
                    DataCell(Text(_unitLabel(strings, record.unit))),
                    DataCell(_StatusBadge(active: record.active)),
                    DataCell(SizedBox(
                        width: 230,
                        child: Text(record.description,
                            overflow: TextOverflow.ellipsis))),
                    DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                      _actionIcon(
                          strings.viewMaterial,
                          Icons.visibility_outlined,
                          () => _viewMaterial(record)),
                      _actionIcon(strings.editMaterial, Icons.edit_outlined,
                          () => _openEditor(record: record)),
                      _actionIcon(
                          record.active
                              ? strings.deactivateMaterial
                              : strings.activateMaterial,
                          record.active
                              ? Icons.block_outlined
                              : Icons.check_circle_outline,
                          () => _toggleActive(record)),
                      _actionIcon(strings.delete, Icons.delete_outline_rounded,
                          () => _confirmDelete(record),
                          destructive: true),
                    ])),
                  ]))
              .toList(),
        ),
      ),
    );
  }

  Widget _actionIcon(String tooltip, IconData icon, VoidCallback action,
          {bool destructive = false}) =>
      IconButton(
        tooltip: tooltip,
        onPressed: action,
        icon: Icon(icon,
            size: 20,
            color: destructive
                ? const Color(0xFFB42318)
                : const Color(0xFF536273)),
      );

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    // A short delay makes refresh feedback visible for this local demo data source.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _materials
          ..clear()
          ..addAll(_demoMaterials);
        _loading = false;
      });
    }
  }

  Future<void> _openEditor({_MaterialRecord? record}) async {
    final strings = AppLocalizations.of(context)!;
    final code = TextEditingController(text: record?.code ?? '');
    final name = TextEditingController(text: record?.name ?? '');
    final description = TextEditingController(text: record?.description ?? '');
    String type = record?.type ?? 'Fabric';
    String unit = record?.unit ?? 'Meter';
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<_MaterialRecord>(
      context: context,
      builder: (dialogContext) =>
          StatefulBuilder(builder: (context, updateDialog) {
        final width = MediaQuery.sizeOf(context).width;
        final typeLabels = {
          'Fabric': strings.fabricMaterialType,
          'Accessory': strings.accessoryMaterialType,
          'Other': strings.otherMaterialType
        };
        final unitLabels = {
          'Meter': strings.meterUnit,
          'Kilogram': strings.kilogramUnit,
          'Piece': strings.pieceUnit,
          'Other': strings.otherMaterialUnit
        };
        return AlertDialog(
          title: Text(record == null
              ? strings.createMaterialTitle
              : strings.editMaterialTitle),
          content: SizedBox(
            width: width < 560 ? width - 48 : 500,
            child: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(strings.materialDialogHint,
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 18),
                          TextFormField(
                              controller: code,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                  labelText: '${strings.materialCode} *'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty)
                                  return strings.materialCodeRequired;
                                final duplicate = _materials.any((item) =>
                                    item.code.toLowerCase() ==
                                        value.trim().toLowerCase() &&
                                    item != record);
                                return duplicate
                                    ? strings.duplicateMaterialCode
                                    : null;
                              }),
                          const SizedBox(height: 12),
                          TextFormField(
                              controller: name,
                              decoration: InputDecoration(
                                  labelText: '${strings.materialName} *'),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                      ? strings.materialNameRequired
                                      : null),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                              initialValue: type,
                              decoration: InputDecoration(
                                  labelText: strings.materialTypeLabel),
                              items: typeLabels.entries
                                  .map((item) => DropdownMenuItem(
                                      value: item.key, child: Text(item.value)))
                                  .toList(),
                              onChanged: (value) =>
                                  updateDialog(() => type = value ?? type)),
                          if (type == 'Fabric') ...[
                            const SizedBox(height: 8),
                            Text(strings.fabricRollHint,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: const Color(0xFF536273))),
                          ],
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                              initialValue: unit,
                              decoration: InputDecoration(
                                  labelText: strings.defaultUnitLabel),
                              items: unitLabels.entries
                                  .map((item) => DropdownMenuItem(
                                      value: item.key, child: Text(item.value)))
                                  .toList(),
                              onChanged: (value) =>
                                  updateDialog(() => unit = value ?? unit)),
                          const SizedBox(height: 12),
                          TextFormField(
                              controller: description,
                              minLines: 2,
                              maxLines: 4,
                              decoration: InputDecoration(
                                  labelText: strings.materialDescription)),
                        ]))),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(strings.cancel)),
            FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  Navigator.pop(
                      dialogContext,
                      _MaterialRecord(
                          code: code.text.trim(),
                          name: name.text.trim(),
                          type: type,
                          unit: unit,
                          description: description.text.trim(),
                          active: record?.active ?? true));
                },
                child: Text(strings.saveMaterial)),
          ],
        );
      }),
    );
    code.dispose();
    name.dispose();
    description.dispose();
    if (result == null || !mounted) return;
    setState(() {
      final index = record == null ? -1 : _materials.indexOf(record);
      if (index < 0) {
        _materials.add(result);
      } else {
        _materials[index] = result;
      }
    });
  }

  void _viewMaterial(_MaterialRecord record) {
    final strings = AppLocalizations.of(context)!;
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(record.name),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detail(strings.materialCode, record.code),
                    _detail(strings.materialTypeLabel,
                        _typeLabel(strings, record.type)),
                    _detail(strings.defaultUnitLabel,
                        _unitLabel(strings, record.unit)),
                    _detail(strings.statusColumn,
                        record.active ? strings.active : strings.inactive),
                    _detail(
                        strings.materialDescription,
                        record.description.isEmpty
                            ? strings.notProvided
                            : record.description),
                  ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(strings.close))
              ],
            ));
  }

  Widget _detail(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 8), child: Text('$label: $value'));

  void _toggleActive(_MaterialRecord record) => setState(() {
        final index = _materials.indexOf(record);
        if (index >= 0)
          _materials[index] = record.copyWith(active: !record.active);
      });

  Future<void> _confirmDelete(_MaterialRecord record) async {
    final strings = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(strings.deleteMaterialQuestion),
              content: Text(strings.deleteMaterialPrompt),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(strings.cancel)),
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFB42318)),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(strings.delete))
              ],
            ));
    if (confirmed == true && mounted) setState(() => _materials.remove(record));
  }

  void _showMessage(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}

String _typeLabel(AppLocalizations strings, String type) => switch (type) {
      'Fabric' => strings.fabricMaterialType,
      'Accessory' => strings.accessoryMaterialType,
      _ => strings.otherMaterialType,
    };

String _unitLabel(AppLocalizations strings, String unit) => switch (unit) {
      'Meter' => strings.meterUnit,
      'Kilogram' => strings.kilogramUnit,
      'Piece' => strings.pieceUnit,
      _ => strings.otherMaterialUnit,
    };

class _MaterialRecord {
  const _MaterialRecord(
      {required this.code,
      required this.name,
      required this.type,
      required this.unit,
      required this.description,
      this.active = true});
  final String code, name, type, unit, description;
  final bool active;
  _MaterialRecord copyWith({bool? active}) => _MaterialRecord(
      code: code,
      name: name,
      type: type,
      unit: unit,
      description: description,
      active: active ?? this.active);
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = const EdgeInsets.all(18)});
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE3E7ED)),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 12,
                  offset: Offset(0, 3))
            ]),
        child: child,
      );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.active});
  final bool active;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final color = active ? const Color(0xFF18794E) : const Color(0xFF667085);
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: active ? const Color(0xFFE8F5EE) : const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(20)),
        child: Text(active ? strings.active : strings.inactive,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600)));
  }
}
