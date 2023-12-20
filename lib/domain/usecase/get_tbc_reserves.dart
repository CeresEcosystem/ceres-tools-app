import 'package:ceres_tools_app/domain/repository/tbc_reserves_repository.dart';

class GetTBCReserves {
  final TBCReservesRepository repository;

  GetTBCReserves({required this.repository});

  Future execute() async {
    return repository.getTBCReserves();
  }
}
