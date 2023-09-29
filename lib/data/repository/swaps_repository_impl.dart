import 'package:ceres_locker_app/data/datasource/swaps_datasource.dart';
import 'package:ceres_locker_app/domain/repository/swaps_repository.dart';

class SwapsRepositoryImpl implements SwapsRepository {
  final SwapsDatasource datasource;

  SwapsRepositoryImpl({required this.datasource});

  @override
  Future getSwaps(String address, int page) async {
    try {
      return await datasource.getSwaps(address, page);
    } on Exception catch (_) {}
  }
}
