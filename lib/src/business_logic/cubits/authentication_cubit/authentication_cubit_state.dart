part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthenticationState {}

class AuthLoading extends AuthenticationState {}

class AuthCodeSent extends AuthenticationState {
  final String verificationId;
  AuthCodeSent(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

class AuthCodeAutoRetrievalTimeout extends AuthenticationState {
  final String verificationId;
  AuthCodeAutoRetrievalTimeout(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

class AuthSuccess extends AuthenticationState {
  final User user;
  AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

enum AuthErrorStatus { atLogin, atFetchingAuthStatus, atSignOut }

class AuthError extends AuthenticationState {
  final String message;
  final AuthErrorStatus errorStatus;
  AuthError(this.message, this.errorStatus);

  @override
  List<Object> get props => [message, errorStatus];
}
