import 'package:driver/src/utils/enums/order_status.dart';

extension OrderStatusExtension on String? {
  OrderStatus toOrderStatus() {
    switch (this) {
      case 'pending':
        return OrderStatus.pending;
      case 'assigned':
        return OrderStatus.assigned;
      case 'accepted':
        return OrderStatus.accepted;
      case 'no_driver_found':
        return OrderStatus.noDriverFound;
      case 'expired':
        return OrderStatus.expired;
      case 'completed':
        return OrderStatus.completed;
      default:
        return OrderStatus.pending;
    }
  }
}
