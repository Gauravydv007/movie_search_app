part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

class ConnectivityCheckRequested extends ConnectivityEvent {
  const ConnectivityCheckRequested();
}

class ConnectivityChanged extends ConnectivityEvent {
  const ConnectivityChanged(this.connected);
  final bool connected;
  @override
  List<Object?> get props => [connected];
}
