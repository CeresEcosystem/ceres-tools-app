import 'package:ceres_tools_app/data/datasource/tbc_reserves_datasource.dart';
import 'package:ceres_tools_app/domain/repository/tbc_reserves_repository.dart';

class TBCReservesRepositoryImpl implements TBCReservesRepository {
  final TBCReservesDatasource datasource;

  TBCReservesRepositoryImpl({required this.datasource});

  @override
  Future getTBCReserves() async {
    try {
      return await datasource.getTBCReserves();
    } on Exception catch (_) {}
  }
}
