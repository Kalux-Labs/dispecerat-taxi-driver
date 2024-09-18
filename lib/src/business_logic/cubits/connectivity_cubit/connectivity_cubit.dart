import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connectivity_cubit_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityCubit({required Connectivity connectivity}) : _connectivity = connectivity, super(ConnectivityInitial()) {
    _registerInternetConnectionListener();
  }

  Future<void> _registerInternetConnectionListener() async {
    if(state is ConnectivityInitial) {
      _connectivitySubscription ??= _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> event) async { 
        final List<ConnectivityResult> instantResult = await _connectivity.checkConnectivity();
        if(instantResult.contains(ConnectivityResult.none)) {
          emit(ConnectivityDisconnected());
        }  else {
          emit(ConnectivityConnected());
        }
      });
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
