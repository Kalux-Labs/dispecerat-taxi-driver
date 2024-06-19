import 'package:driver/src/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState(
            authenticationStatus: AuthenticationStatus.initial)) {
    on<GetLoginStatus>(_onGetLoginStatus);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onGetLoginStatus(
      GetLoginStatus event, Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.loading));

    await Future.delayed(const Duration(seconds: 4));
    emit(state.copyWith(authenticationStatus: AuthenticationStatus.unauthenticated));
    //do something
  }
}
