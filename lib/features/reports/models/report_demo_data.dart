/// Isolated report presentation data until a report service is connected.
///
/// The month snapshot matches the current Orders and Production demo records:
/// three orders, 5,330 produced units, four customers, and $15,130.50 in value.
enum ReportPeriod { week, month, year }

class ReportSnapshot {
  const ReportSnapshot({
    required this.totalOrders,
    required this.productionOutput,
    required this.totalCustomers,
    required this.revenue,
    required this.pendingOrders,
    required this.inProgressOrders,
    required this.completedOrders,
    required this.productionByStage,
    required this.revenueTrend,
  });

  final int totalOrders;
  final int productionOutput;
  final int totalCustomers;
  final double revenue;
  final int pendingOrders;
  final int inProgressOrders;
  final int completedOrders;
  final List<int> productionByStage;
  final List<double> revenueTrend;

  int get orderStatusTotal =>
      pendingOrders + inProgressOrders + completedOrders;

  /// Return internally consistent, deterministic sample data for each period.
  factory ReportSnapshot.forPeriod(ReportPeriod period) => switch (period) {
        ReportPeriod.week => const ReportSnapshot(
            totalOrders: 2,
            productionOutput: 1840,
            totalCustomers: 4,
            revenue: 5420,
            pendingOrders: 0,
            inProgressOrders: 1,
            completedOrders: 1,
            productionByStage: [700, 450, 380, 310],
            revenueTrend: [600, 780, 900, 850, 1000, 1290],
          ),
        ReportPeriod.month => const ReportSnapshot(
            totalOrders: 3,
            productionOutput: 5330,
            totalCustomers: 4,
            revenue: 15130.5,
            pendingOrders: 1,
            inProgressOrders: 1,
            completedOrders: 1,
            // Stage totals aggregate the five jobs currently shown in Production.
            productionByStage: [950, 1260, 720, 2400],
            // Values add to the three sample order amounts shown in Orders.
            revenueTrend: [1800, 2200, 1900, 2500, 3600, 3130.5],
          ),
        ReportPeriod.year => const ReportSnapshot(
            totalOrders: 18,
            productionOutput: 48600,
            totalCustomers: 4,
            revenue: 216400,
            pendingOrders: 4,
            inProgressOrders: 9,
            completedOrders: 5,
            productionByStage: [10800, 12600, 11400, 13800],
            revenueTrend: [30000, 33000, 35000, 37000, 39000, 42400],
          ),
      };
}
