part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState{
}
class DrivingAllowedfalse extends LoginState{
}

class LoginOtpSentState extends LoginState{
  late String phone;
  LoginOtpSentState({required this.phone});
}

class LoginSuccessState extends LoginState {}

class LoginErrorState extends LoginState {
  late String Error;
  LoginErrorState({required this.Error});
}