import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_search_app_001/core/network/network_info.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc(this._networkInfo) : super(ConnectivityInitial()) {
    on<ConnectivityCheckRequested>(_onCheckRequested);
    on<ConnectivityChanged>(_onChanged);
  }

  final NetworkInfo _networkInfo;

  Future<void> _onCheckRequested(
    ConnectivityCheckRequested event,
    Emitter<ConnectivityState> emit,
  ) async {
    final connected = await _networkInfo.isConnected;
    emit(connected ? ConnectivityOnline() : ConnectivityOffline());
  }

  void _onChanged(ConnectivityChanged event, Emitter<ConnectivityState> emit) {
    emit(event.connected ? ConnectivityOnline() : ConnectivityOffline());
  }
}
