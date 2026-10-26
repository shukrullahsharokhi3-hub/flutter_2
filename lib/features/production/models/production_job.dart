/// Current production stage for a local factory job.
enum ProductionStage { cutting, sewing, finishing, qualityControl }

/// Demo workflow status used by the Production page until backend data is ready.
enum ProductionStatus { inProgress, completed, pending, delayed }

/// A garment order's planned and produced units at its current production stage.
class ProductionJob {
  const ProductionJob({
    required this.orderId,
    required this.product,
    required this.plannedQuantity,
    required this.producedQuantity,
    required this.stage,
    required this.status,
  });

  final String orderId;
  final String product;
  final int plannedQuantity;
  final int producedQuantity;
  final ProductionStage stage;
  final ProductionStatus status;
}
