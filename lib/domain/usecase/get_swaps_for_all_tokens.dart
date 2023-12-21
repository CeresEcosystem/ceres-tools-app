import 'package:ceres_tools_app/domain/repository/swaps_repository.dart';

class GetSwapsForAllTokens {
  final SwapsRepository repository;

  GetSwapsForAllTokens({required this.repository});

  Future execute(int page) async {
    return repository.getSwapsForAllTokens(page);
  }
}
