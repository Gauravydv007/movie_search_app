import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_info.dart';

/// Uses connectivity_plus to determine if the device has network access.
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.any((c) =>
        c == ConnectivityResult.mobile || c == ConnectivityResult.wifi);
  }
}
