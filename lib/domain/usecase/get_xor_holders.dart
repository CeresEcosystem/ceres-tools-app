import 'package:ceres_tools_app/domain/repository/tokens_repository.dart';

class GetXorHolders {
  final TokensRepository repository;

  GetXorHolders({required this.repository});

  Future execute(int page) async {
    return repository.getXorHolders(page);
  }
}
