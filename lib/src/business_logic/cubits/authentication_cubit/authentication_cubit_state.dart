part of 'authentication_cubit.dart';

abstract class AuthenticationState {}

class AuthInitial extends AuthenticationState {}

class AuthLoading extends AuthenticationState {}

class AuthCodeSent extends AuthenticationState {
  final String verificationId;
  AuthCodeSent(this.verificationId);
}

class AuthCodeAutoRetrievalTimeout extends AuthenticationState {
  final String verificationId;
  AuthCodeAutoRetrievalTimeout(this.verificationId);
}

class AuthSuccess extends AuthenticationState {
  final User user;
  AuthSuccess(this.user);
}

enum AuthErrorStatus { atLogin, atFetchingAuthStatus, atSignOut }

class AuthError extends AuthenticationState {
  final String message;
  final AuthErrorStatus errorStatus;
  AuthError(this.message, this.errorStatus);
}
