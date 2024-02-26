import 'package:ceres_tools_app/domain/models/kensetsu_filter.dart';

abstract class KensetsuRepository {
  Future getKensetsuBurns(
    int page,
    KensetsuFilter kensetsuFilter,
  );
}
