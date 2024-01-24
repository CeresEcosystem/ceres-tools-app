import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/tbc_reserve.dart';
import 'package:ceres_tools_app/domain/models/tbc_reserve_list.dart';
import 'package:ceres_tools_app/domain/usecase/get_tbc_reserves.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class TBCReservesController extends GetxController {
  final getTBCReserves = Injector.resolve!<GetTBCReserves>();

  final _loadingStatus = LoadingStatus.LOADING.obs;

  late double _currrentBalance;
  late double _currentValue;

  List<TBCReserve> _tbcReserves = [];

  LoadingStatus get loadingStatus => _loadingStatus.value;
  String get currentBalance => formatToCurrency(_currrentBalance);
  String get currentValue => formatToCurrency(_currentValue, showSymbol: true);
  List<TBCReserve> get tbcReserves => _tbcReserves;

  Map<String, dynamic>? get graphData {
    if (_tbcReserves.isNotEmpty) {
      double maxY = 0;
      double minY = 0;
      double maxX = 0;
      double minX = 0;
      List<Map<String, dynamic>> data = [];

      for (var i = 0; i < _tbcReserves.length; i++) {
        TBCReserve tbcReserve = _tbcReserves[i];

        double x = dateStringToDouble(tbcReserve.updatedAt);
        double y = getDefaultDoubleValueNotNullable(tbcReserve.balance);

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
          if (i == _tbcReserves.length - 1) {
            maxX = x;
          }
          data.add({...tbcReserve.toJson(), 'y': y, 'x': x});
        }
      }

      final intervalY = (maxY - minY) / 4;
      final intervalX = (maxX - minX) / 6;

      return {
        'maxY': maxY,
        'minY': minY,
        'maxX': maxX,
        'minX': minX,
        'intervalY': intervalY > 0 ? intervalY : 1.0,
        'intervalX': intervalX > 0 ? intervalX : 1.0,
        'data': data
      };
    } else {
      return null;
    }
  }

  String getSupplyTooltipData(LineBarSpot touchedSpot) {
    if (graphData != null) {
      Map<String, dynamic> item = List.from(graphData!['data']).firstWhere(
          (spot) => spot['x'] == touchedSpot.x && spot['y'] == touchedSpot.y);
      return 'DATE: ${formatDateAndTime(item['x'])}\nBalance: ${formatToCurrency(item['y'])}\nValue: ${formatToCurrency(item['value'], showSymbol: true)}';
    }

    return '';
  }

  @override
  void onInit() {
    _fetchTBCReserves();
    super.onInit();
  }

  void _fetchTBCReserves() async {
    final response = await getTBCReserves.execute();

    if (response != null) {
      _currrentBalance = response['currentBalance'];
      _currentValue = response['currentValue'];

      if (response['data'] != null && response['data'] is List) {
        _tbcReserves = TBCReserveList.fromJson(response['data']).tbcReserves;

        _loadingStatus.value = LoadingStatus.READY;
      } else {
        _loadingStatus.value = LoadingStatus.ERROR;
      }
    }
  }
}
