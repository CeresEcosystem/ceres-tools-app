import 'package:ceres_tools_app/domain/repository/tokens_repository.dart';

class GetTokenHolders {
  final TokensRepository repository;

  GetTokenHolders({required this.repository});

  Future execute(String assetId, int page) async {
    return repository.getTokenHolders(assetId, page);
  }
}
