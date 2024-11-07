import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../repository/auth_repository.dart';
import '../event/auth_event.dart';
import '../state/auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<Authenticate>((event, emit) async {
      emit(AuthLoading());
      try {
        bool didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'Please authenticate to unlock',
        );

        if (didAuthenticate) {
          // Validate password through the repository
          bool isAuthorized = await _authRepository.validatePassword();
          if (isAuthorized) {
            emit(AuthSuccess());
          } else {
            emit(AuthFailure('Unauthorized'));
          }
        } else {
          emit(AuthFailure('Authentication failed'));
        }
      } catch (e) {
        emit(AuthFailure('An error occurred'));
      }
    });
  }
}

