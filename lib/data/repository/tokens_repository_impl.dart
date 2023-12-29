import 'package:ceres_tools_app/data/datasource/tokens_datasource.dart';
import 'package:ceres_tools_app/domain/repository/tokens_repository.dart';

class TokensRepositoryImpl implements TokensRepository {
  final TokensDatasource datasource;

  TokensRepositoryImpl({required this.datasource});

  @override
  Future getTokens() async {
    try {
      return await datasource.getTokens();
    } on Exception catch (_) {}
  }

  @override
  Future getTokenHolders(String assetId, int page) async {
    try {
      return await datasource.getTokenHolders(assetId, page);
    } on Exception catch (_) {}
  }

  @override
  Future getXorHolders(int page) async {
    try {
      return await datasource.getXorHolders(page);
    } on Exception catch (_) {}
  }
}
