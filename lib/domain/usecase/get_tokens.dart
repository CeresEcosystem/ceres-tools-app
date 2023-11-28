import 'package:ceres_tools_app/domain/repository/tokens_repository.dart';

class GetTokens {
  final TokensRepository repository;

  GetTokens({required this.repository});

  Future execute() async {
    return repository.getTokens();
  }
}
