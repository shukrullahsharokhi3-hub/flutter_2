enum OrderStatus { pending, inProgress, completed }

class Order {
  const Order({
    required this.number,
    required this.customerName,
    required this.orderDate,
    required this.deliveryDate,
    required this.totalAmount,
    required this.status,
  });

  final String number;
  final String customerName;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final double totalAmount;
  final OrderStatus status;
}
