import 'package:ceres_locker_app/domain/repository/swaps_repository.dart';

class GetSwaps {
  final SwapsRepository repository;

  GetSwaps({required this.repository});

  Future execute(String address, int page) async {
    return repository.getSwaps(address, page);
  }
}
