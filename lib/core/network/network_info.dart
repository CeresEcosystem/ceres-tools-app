import 'package:connectivity/connectivity.dart';

abstract class NetworkInfoI {
  Future<bool> isConnected();

  Future<ConnectivityResult> get connectivityResult;
}

class NetworkInfo implements NetworkInfoI {
  final Connectivity connectivity;

  NetworkInfo({required this.connectivity});

  @override
  Future<ConnectivityResult> get connectivityResult async {
    return connectivity.checkConnectivity();
  }

  @override
  Future<bool> isConnected() async {
    final result = await connectivity.checkConnectivity();

    return result != ConnectivityResult.none;
  }
}
