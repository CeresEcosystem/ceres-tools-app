import 'package:ceres_tools_app/domain/models/burn_filter.dart';
import 'package:ceres_tools_app/domain/repository/burning_repository.dart';

class GetBurns {
  final BurningRepository repository;

  GetBurns({required this.repository});

  Future execute(
    String token,
    int page,
    BurnFilter burnFilter,
  ) async {
    return repository.getBurns(
      token,
      page,
      burnFilter,
    );
  }
}
