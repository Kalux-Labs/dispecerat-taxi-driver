import 'package:driver/src/repositories/authentication_repository.dart';
import 'package:driver/src/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_cubit_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AuthInitial());

  void verifyPhoneNumber(String phoneNumber) {
    emit(AuthLoading());
    _authenticationRepository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("verificationCompleted");
        await signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
        emit(AuthError(
            e.message ?? 'Unknown error occurred', AuthErrorStatus.atLogin));
      },
      codeSent: (String verificationId, int? resendToken) {
        print("codeSent");
        emit(AuthCodeSent(verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout");
        AppRouter.scaffoldMessengerState.currentState!
            .showSnackBar(const SnackBar(content: Text("Codul a expirat")));
        emit(AuthCodeAutoRetrievalTimeout(verificationId));
      },
    );
  }

  Future<void> signInWithCredential(AuthCredential credential) async {
    try {
      emit(AuthLoading());
      print("AJUNS AICI ${credential}");
      User? user =
          await _authenticationRepository.signInWithCredential(credential);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthError('Failed to sign in', AuthErrorStatus.atLogin));
      }
    } catch (e) {
      emit(AuthError(e.toString(), AuthErrorStatus.atLogin));
    }
  }

  void checkUserStatus() {
    User? user = _authenticationRepository.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthInitial());
    }
  }

  void signInWithSmsCode(String verificationId, String smsCode) {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    signInWithCredential(credential);
  }
}
