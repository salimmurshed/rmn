part of 'splash_bloc.dart';

@immutable
sealed class SplashEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TriggerSplashNavigation extends SplashEvent {}
class TriggerSplashTiming extends SplashEvent {}
class TriggerCheckForDynamic extends SplashEvent {}