part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class GetLoginStatus extends AuthenticationEvent {
  @override
  List<Object?> get props => <Object>[];
}

class LoginUser extends AuthenticationEvent{
  final String token;

  const LoginUser({required this.token});
  @override
  List<Object?> get props => <Object>[];
}
