import 'package:ceres_locker_app/data/datasource/portfolio_datasource.dart';
import 'package:ceres_locker_app/domain/repository/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioDatasource datasource;

  PortfolioRepositoryImpl({required this.datasource});

  @override
  Future getPortfolioItems(String address) async {
    try {
      return await datasource.getPortfolioItems(address);
    } on Exception catch (_) {}
  }
}
