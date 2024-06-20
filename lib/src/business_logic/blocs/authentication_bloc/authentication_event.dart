part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class GetLoginStatus extends AuthenticationEvent {
  @override
  List<Object?> get props => <Object>[];
}

class LoginUser extends AuthenticationEvent{
  final String phone;

  const LoginUser({required this.phone});
  @override
  List<Object?> get props => <Object>[];
}
