import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      _connectivitySubscription ??= _connectivity.onConnectivityChanged.listen((event) async { 
        final List<ConnectivityResult> instantResult = await _connectivity.checkConnectivity();
        if(instantResult.contains(ConnectivityResult.none)) {
          emit(ConnectivityDisconnected());
        }  else {
          emit(ConnectivityConnected());
        }
      });
    }
  }

  Future<bool> _isInternetConnectionAvailable() async {
    try {
      final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      return !result.contains(ConnectivityResult.none);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
