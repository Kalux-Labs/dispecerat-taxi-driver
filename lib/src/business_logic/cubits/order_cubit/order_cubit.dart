// ignore_for_file: unused_import

import 'dart:async';

import 'package:driver/src/business_logic/cubits/app_session_cubit.dart';
import 'package:driver/src/models/order.dart';
import 'package:driver/src/repositories/database_repository.dart';
import 'package:driver/src/repositories/firestore_repository.dart';
import 'package:driver/src/services/google_places_service.dart';
import 'package:driver/src/utils/enums/order_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_cubit_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final FirestoreRepository _firestoreRepository;
  final GooglePlacesService _googlePlacesService;
  final AppSessionCubit _appSessionCubit;

  Timer? _timer;

  OrderCubit(
      {required FirestoreRepository firestoreRepository,
      required GooglePlacesService googlePlacesService,
      required AppSessionCubit appSessionCubit})
      : _appSessionCubit = appSessionCubit,
        _googlePlacesService = googlePlacesService,
        _firestoreRepository = firestoreRepository,
        super(OrderWaiting()) {
    // _listenForDriverChanges();
  }

  Future<void> acceptOrder() async {
    if (state is OrderReceived) {
      _timer?.cancel();
      final order = (state as OrderReceived).order;
      await _firestoreRepository.acceptOrder(
          order.id, _appSessionCubit.state!.id);
      emit(OrderAccepted((state as OrderReceived).order));
    }
    // emit(OrderWaiting());
  }

  void expireOrder() {
    emit(OrderExpired());
  }

  Future<void> completeOrder() async {
    if (state is OrderAccepted) {
      final order = (state as OrderAccepted).order;
      await _firestoreRepository.completeOrder(
          order.id, _appSessionCubit.state!.id);
      emit(OrderFinished());
    }
  }

  void listenForDriverChanges() {
    if (_appSessionCubit.state?.id != null) {
      _firestoreRepository
          .getDriverStream(_appSessionCubit.state!.id)
          .listen((driver) {
        if (driver.orderId != null && driver.orderId!.isNotEmpty) {
          _fetchOrderDetails(driver.orderId!);
        } else {
          emit(OrderWaiting());
        }
      });
    }
  }

  Future<void> _fetchOrderDetails(String orderId) async {
    final order = await _firestoreRepository.getOrder(orderId);
    if (order != null) {
      final place = await _googlePlacesService.getPlace(order.placeId);

      if (order.status == OrderStatus.accepted) {
        emit(OrderAccepted(order.copyWith(place: place)));
      } else if (order.status == OrderStatus.assigned) {
        _starTimer();
        emit(OrderReceived(order.copyWith(place: place)));
      }
    } else {
      emit(OrderError("Comanda nu exista"));
    }
  }

  void _starTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 10), _expireOrder);
  }

  void _expireOrder() {
    //POST request to expire order;
    emit(OrderExpired());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
