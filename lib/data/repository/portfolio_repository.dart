import 'package:ceres_tools_app/data/datasource/portfolio_datasource.dart';
import 'package:ceres_tools_app/domain/repository/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioDatasource datasource;

  PortfolioRepositoryImpl({required this.datasource});

  @override
  Future getPortfolioItems(String address, int page) async {
    try {
      return await datasource.getPortfolioItems(address, page);
    } on Exception catch (_) {}
  }
}
