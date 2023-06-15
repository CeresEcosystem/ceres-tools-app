import 'package:ceres_locker_app/domain/repository/portfolio_repository.dart';

class GetPortfolioItems {
  final PortfolioRepository repository;

  GetPortfolioItems({required this.repository});

  Future execute(String address) async {
    return repository.getPortfolioItems(address);
  }
}
