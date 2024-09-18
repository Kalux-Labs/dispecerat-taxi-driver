part of 'notifications_cubit.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationnReady extends NotificationState {}

// class NotificationRecevied extends NotificationState {
//   final String payload;

//   NotificationRecevied(this.payload);

//   @override
//   List<Object> get props => [payload];
// }

class NotificationError extends NotificationState {
  final String error;

  NotificationError(this.error);

  @override
  List<Object> get props => <Object>[error];
}
