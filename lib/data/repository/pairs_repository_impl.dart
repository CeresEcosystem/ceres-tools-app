import 'package:ceres_locker_app/data/datasource/pairs_datasource.dart';
import 'package:ceres_locker_app/domain/repository/pairs_repository.dart';

class PairsRepositoryImpl implements PairsRepository {
  final PairsDatasource datasource;

  PairsRepositoryImpl({required this.datasource});

  @override
  Future getPairs() async {
    try {
      return await datasource.getPairs();
    } on Exception catch (_) {}
  }
}
