part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderWaiting extends OrderState {}

class OrderReceived extends OrderState {
  final Order order;
  OrderReceived(this.order);

  @override
  List<Object> get props => [order];
}

class OrderAccepted extends OrderState {
  final Order order;
  OrderAccepted(this.order);

  @override
  List<Object> get props => [order];
}

class OrderFinished extends OrderState {}

class OrderExpired extends OrderState {}

class OrderError extends OrderState {
  final String error;
  OrderError(this.error);
  @override
  List<Object> get props => [error];
}
