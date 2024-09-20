import 'package:driver/src/models/driver.dart';
import 'package:driver/src/repositories/authentication_repository.dart';
import 'package:driver/src/repositories/firestore_repository.dart';
import 'package:driver/src/router/app_router.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_cubit_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final FirestoreRepository _firestoreRepository;

  AuthenticationCubit({
    required AuthenticationRepository authenticationRepository,
    required FirestoreRepository firestoreRepository,
  })  : _authenticationRepository = authenticationRepository,
        _firestoreRepository = firestoreRepository,
        super(AuthInitial());

  void verifyPhoneNumber(String phoneNumber) {
    emit(AuthLoading());
    _authenticationRepository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint(
          'FirebaseAuthException ${e.code} ${e.message} ${e.stackTrace}',
        );
        switch (e.code) {
          case 'invalid-phone-number':
            emit(
              AuthError(
                'Numarul de telefon este invalid.',
                AuthErrorStatus.atLogin,
              ),
            );
          case 'too-many-requests':
            emit(
              AuthError(
                'Prea multe cereri, incercati mai tarziu.',
                AuthErrorStatus.atLogin,
              ),
            );
          default:
            emit(
              AuthError(
                'S-a produs o eroare, incercati mai tarziu.',
                AuthErrorStatus.atLogin,
              ),
            );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        emit(AuthCodeSent(verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (_authenticationRepository.getCurrentUser() == null) {
          AppRouter.scaffoldMessengerState.currentState!
              .showSnackBar(const SnackBar(content: Text('Codul a expirat')));
          emit(AuthCodeAutoRetrievalTimeout(verificationId));
        }
      },
    );
  }

  Future<void> signInWithCredential(AuthCredential credential) async {
    try {
      emit(AuthLoading());
      final User? user =
          await _authenticationRepository.signInWithCredential(credential);
      if (user != null) {
        await _checkPhoneNumber();
      } else {
        emit(
          AuthError(
            'Autentificarea a esuat, incercati mai tarziu.',
            AuthErrorStatus.atLogin,
          ),
        );
      }
    } catch (e) {
      emit(AuthError(e.toString(), AuthErrorStatus.atLogin));
    }
  }

  void checkUserStatus() {
    final User? user = _authenticationRepository.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _checkPhoneNumber() async {
    final User? user = _authenticationRepository.getCurrentUser();
    if (user != null) {
      final String phoneNumber = user.phoneNumber!;
      final Driver? driver =
          await _firestoreRepository.getDriverByPhone(phoneNumber);
      if (driver == null) {
        emit(AuthError('Numarul nu a fost gasit.', AuthErrorStatus.atLogin));
      } else {
        emit(AuthSuccess(user));
      }
    } else {
      emit(AuthError('Failed to sign in', AuthErrorStatus.atLogin));
    }
  }

  void signInWithSmsCode(String verificationId, String smsCode) {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    signInWithCredential(credential);
  }

  void signOut() {
    _authenticationRepository
        .signOut()
        .then((_) => <void>{resetAuthentication()});
  }

  void resetAuthentication() {
    emit(AuthInitial());
  }
}
