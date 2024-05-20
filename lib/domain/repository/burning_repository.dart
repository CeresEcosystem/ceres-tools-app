import 'package:ceres_tools_app/domain/models/burn_filter.dart';

abstract class BurningRepository {
  Future getBurns(
    String token,
    int page,
    BurnFilter burnFilter,
  );
}
