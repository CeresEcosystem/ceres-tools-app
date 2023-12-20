import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/domain/usecase/get_tracker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class SupplyController extends GetxController {
  final getTracker = Injector.resolve!<GetTracker>();

  final _loadingStatus = LoadingStatus.READY.obs;
  List? _supplyGraph;
  Map<String, dynamic>? _supplyGraphData;
  double _currentSupply = 0;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  Map<String, dynamic>? get supplyGraphData => _supplyGraphData;
  double get currentSupply => _currentSupply;

  @override
  void onInit() {
    fetchSupply();
    super.onInit();
  }

  void _setSupplyGraphData() {
    if (_supplyGraph != null && _supplyGraph!.isNotEmpty) {
      double maxY = 0;
      double minY = 0;
      double maxX = 0;
      double minX = 0;
      List<Map<String, dynamic>> data = [];

      for (var i = 0; i < _supplyGraph!.length; i++) {
        final value = _supplyGraph![i];
        if (value is Map<String, dynamic>) {
          double x = dateStringToDouble(value['x']);
          double y = getDefaultDoubleValue(value['y'])!;

          if (i == _supplyGraph!.length - 1) {
            _currentSupply = y;
          }

          if (x > 0 && y > 0) {
            if (i == 0) {
              minY = y;
              minX = x;
            }
            if (y > maxY) {
              maxY = y;
            }
            if (y < minY) {
              minY = y;
            }
            if (i == _supplyGraph!.length - 1 && value['x'] != null) {
              maxX = x;
            }
            data.add({...value, 'y': y, 'x': x});
          }
        }
      }

      final intervalY = (maxY - minY) / 4;
      final intervalX = (maxX - minX) / 2;

      _supplyGraphData = {
        'maxY': maxY,
        'minY': minY,
        'maxX': maxX,
        'minX': minX,
        'intervalY': intervalY > 0 ? intervalY : 1.0,
        'intervalX': intervalX > 0 ? intervalX : 1.0,
        'data': data
      };
    } else {
      _supplyGraphData = null;
    }
  }

  String getSupplyTooltipData(LineBarSpot touchedSpot) {
    Map<String, dynamic> item = List.from(supplyGraphData!['data']).firstWhere(
        (spot) => spot['x'] == touchedSpot.x && spot['y'] == touchedSpot.y);
    return 'DATE: ${formatDate(item['x'], formatFullDate: true)}\nGross Burn: ${formatToCurrency(touchedSpot.y, decimalDigits: 4)}';
  }

  void fetchSupply() async {
    final args = Get.arguments;
    Token token = args['token'];

    _loadingStatus.value = LoadingStatus.LOADING;

    final response = await getTracker.execute(token.shortName!);

    if (response != null) {
      if (response['graphSupply'] != null && response['graphSupply'] is List) {
        _supplyGraph = response['graphSupply'];
        _setSupplyGraphData();
      }

      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }
}
