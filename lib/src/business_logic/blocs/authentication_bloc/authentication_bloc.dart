import 'package:driver/src/models/driver.dart';
import 'package:driver/src/repositories/authentication_repository.dart';
import 'package:driver/src/repositories/secure_storage_repository.dart';
import 'package:driver/src/router/app_router.dart';
import 'package:driver/src/utils/secure_storage_keys.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository,
      required SecureStorageRepository secureStorageRepository})
      : _authenticationRepository = authenticationRepository,
        _secureStorageRepository = secureStorageRepository,
        super(const AuthenticationState(
            authenticationStatus: AuthenticationStatus.initial)) {
    on<GetLoginStatus>(_onGetLoginStatus);
    on<LoginUser>(_onLoginUser);
  }

  final AuthenticationRepository _authenticationRepository;
  final SecureStorageRepository _secureStorageRepository;

  Future<void> _onGetLoginStatus(
      GetLoginStatus event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.loading));

    final id = await _secureStorageRepository.readData(SecureStorageKeys.id);
    try {
      if (id != null) {
        final driver = await _authenticationRepository.getDriverById(id);
        if (driver != null) {
          emit(state.copyWith(
              authenticationStatus: AuthenticationStatus.authenticated,
              driver: driver));
        } else {
          emit(state.copyWith(
              authenticationStatus: AuthenticationStatus.unauthenticated));
        }
      } else {
        emit(state.copyWith(
            authenticationStatus: AuthenticationStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(
          authenticationStatus: AuthenticationStatus.error,
          authenticationError: AuthenticationError.atFetchingLoginStatus));
    }
  }

  Future<void> _onLoginUser(
      LoginUser event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.loading));

    try {
      final driver =
          await _authenticationRepository.getDriverByPhone(event.phone);
      if (driver != null) {
        _secureStorageRepository.saveData(SecureStorageKeys.phone, event.phone);
        _secureStorageRepository.saveData(SecureStorageKeys.id, driver.id);
        emit(state.copyWith(
            authenticationStatus: AuthenticationStatus.authenticated,
            driver: driver));
      } else {
        AppRouter.scaffoldMessengerState.currentState!.showSnackBar(
            const SnackBar(
                content: Text("Numarul de telefon nu a fost gasit.")));
        emit(state.copyWith(
            authenticationStatus: AuthenticationStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(
          authenticationStatus: AuthenticationStatus.error,
          authenticationError: AuthenticationError.atLogin));
    }
  }
}
