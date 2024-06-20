part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  loading,
  authenticated,
  unauthenticated,
  error,
  initial
}

enum AuthenticationError { atLogin, atFetchingLoginStatus, atSignOut }

class AuthenticationState extends Equatable {
  final bool isLoggedIn;
  final AuthenticationStatus authenticationStatus;
  final AuthenticationError? authenticationError;
  final Driver? driver;

  const AuthenticationState(
      {required this.authenticationStatus,
      this.isLoggedIn = false,
      this.authenticationError,
      this.driver});

  @override
  List<Object?> get props =>
      <Object?>[authenticationStatus, isLoggedIn, authenticationError];

  AuthenticationState copyWith(
      {AuthenticationStatus? authenticationStatus,
      bool? isLoggedIn,
      AuthenticationError? authenticationError,
      Driver? driver}) {
    return AuthenticationState(
        authenticationStatus: authenticationStatus ?? this.authenticationStatus,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        authenticationError: authenticationError ?? this.authenticationError,
        driver: driver ?? this.driver);
  }

  @override
  String toString() {
    return 'AuthenticationState{isLoggedIn: $isLoggedIn, authStatus: ${authenticationStatus.name}. driver: ${driver}, errorCase: $authenticationError';
  }
}
