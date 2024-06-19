import 'package:driver/src/utils/enums/order_status.dart';

extension OrderStatusExtension on String? {
  OrderStatus toOrderStatus(){
    switch(this) {
      case 'pending':
        return OrderStatus.pending;
      case 'accepted':
        return OrderStatus.accepted;
      case 'declined':
        return OrderStatus.declined;
      default:
        return OrderStatus.declined;
    }
  }
}