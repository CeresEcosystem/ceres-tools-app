import 'package:ceres_tools_app/domain/repository/pairs_repository.dart';

class GetPairs {
  final PairsRepository repository;

  GetPairs({required this.repository});

  Future execute() async {
    return repository.getPairs();
  }
}
