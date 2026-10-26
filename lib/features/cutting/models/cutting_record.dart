/// Statuses used by the local Cutting screen demo only.
///
/// These values do not define backend statuses or production transitions.
enum CuttingStatus { pending, inProgress, completed }

/// Small in-memory Cutting record for the first UI version.
///
/// [orderNumber] reuses the order references already present in this app.
/// [description] is free text because the Cutting business fields are not yet
/// defined. The date and status support listing and filtering in the demo.
class CuttingRecord {
  const CuttingRecord({
    required this.orderNumber,
    required this.description,
    required this.date,
    required this.status,
  });

  final String orderNumber;
  final String description;
  final DateTime date;
  final CuttingStatus status;
}
