import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/enums/tracker_table_type.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/block.dart';
import 'package:ceres_tools_app/domain/models/block_list.dart';
import 'package:ceres_tools_app/domain/models/page_meta.dart';
import 'package:ceres_tools_app/domain/usecase/get_tracker.dart';
import 'package:ceres_tools_app/domain/usecase/get_tracker_blocks.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

const _tabs = ['PSWAP', 'VAL', 'XOR'];
const Map<String, String> _filterTimes = {
  'DAY': '24h',
  'WEEK': '7d',
  'MONTH': '30d',
  'ALL': 'all'
};

class TrackerController extends GetxController {
  final getTracker = Injector.resolve!<GetTracker>();
  final getTrackerBlocks = Injector.resolve!<GetTrackerBlocks>();

  final _loadingStatus = LoadingStatus.READY.obs;

  final _selectedToken = _tabs[0].obs;
  final _selectedFilterBurning = 'DAY'.obs;

  Map<String, dynamic>? _burnData;

  final _loadingXorSpent = LoadingStatus.READY.obs;
  final _loadingGrossTable = LoadingStatus.READY.obs;
  PageMeta _pageMetaXorSpent = PageMeta(0, 0, 0, 0, false, false);
  PageMeta _pageMetaGrossTable = PageMeta(0, 0, 0, 0, false, false);
  List<Block> _blocksXorSpent = [];
  List<Block> _blocksGrossTable = [];

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<String> get tabs => _tabs;
  String get selectedToken => _selectedToken.value;
  Map<String, String> get filterTimes => _filterTimes;
  String get selectedFilterBurning => _selectedFilterBurning.value;

  LoadingStatus get loadingXorSpent => _loadingXorSpent.value;
  LoadingStatus get loadingGrossTable => _loadingGrossTable.value;
  PageMeta get pageMetaXorSpent => _pageMetaXorSpent;
  List<Block> get blocksXorSpent => _blocksXorSpent;
  PageMeta get pageMetaGrossTable => _pageMetaGrossTable;
  List<Block> get blocksGrossTable => _blocksGrossTable;

  Map<String, dynamic>? get burnData {
    if (_burnData != null && _burnData!.isNotEmpty) {
      for (String key in _burnData!.keys) {
        if (_selectedFilterBurning.value == key) {
          return _burnData![key];
        }
      }
    }

    return null;
  }

  // GRAPH DATA //

  List? _burningGraph;
  Map<String, dynamic>? _burningGraphData;
  List? _supplyGraph;
  Map<String, dynamic>? _supplyGraphData;

  Map<String, dynamic>? get burningGraphData => _burningGraphData;
  Map<String, dynamic>? get supplyGraphData => _supplyGraphData;

  void _setBurningGraphData() {
    if (_burningGraph != null && _burningGraph!.isNotEmpty) {
      double maxY = 0;
      double maxX = 0;
      double minX = 0;
      List<Map<String, dynamic>> data = [];

      for (var i = 0; i < _burningGraph!.length; i++) {
        final value = _burningGraph![i];
        if (value is Map<String, dynamic>) {
          double x = dateStringToDouble(value['x']);
          double y = getDefaultDoubleValue(value['y'])!;

          if (x > 0 && y > 0) {
            if (value['y'] != null && value['y'] > maxY) {
              maxY = y;
            }
            if (i == _burningGraph!.length - 1 && value['x'] != null) {
              maxX = x;
            }
            if (i == 0 && value['x'] != null) {
              minX = x;
            }
            data.add({...value, 'y': y, 'x': x});
          }
        }
      }

      _burningGraphData = {
        'maxY': maxY,
        'maxX': maxX,
        'minX': minX,
        'intervalY': maxY / 4,
        'intervalX': (maxX - minX) / 6,
        'data': data
      };
    } else {
      _burningGraphData = null;
    }
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

      _supplyGraphData = {
        'maxY': maxY,
        'minY': minY,
        'maxX': maxX,
        'minX': minX,
        'intervalY': (maxY - minY) / 4,
        'intervalX': (maxX - minX) / 6,
        'data': data
      };
    } else {
      _supplyGraphData = null;
    }
  }

  String getTooltipData(LineBarSpot touchedSpot) {
    Map<String, dynamic> item = List.from(_burningGraphData!['data'])
        .firstWhere(
            (spot) => spot['x'] == touchedSpot.x && spot['y'] == touchedSpot.y);

    switch (_selectedToken.value) {
      case 'PSWAP':
        return 'DATE: ${formatDate(item['x'], formatFullDate: true)}\nGross Burn: ${formatToCurrency(touchedSpot.y)}\nXOR spent: ${formatToCurrency(item['spent'])}\nReminted LP: ${formatToCurrency(item['lp'])}\nReminted Parliament: ${formatToCurrency(item['parl'])}\nTotal Reminted: ${formatToCurrency(item['lp'] + item['parl'])}\nNet Burn: ${formatToCurrency(item['net'])}';
      case 'VAL':
        return 'DATE: ${formatDate(item['x'], formatFullDate: true)}\nGross Burn: ${formatToCurrency(touchedSpot.y)}\nXOR fees: ${formatToCurrency(item['spent'])}\nXOR for buyback: ${formatToCurrency(item['back'])}\nReminted Parliament: ${formatToCurrency(item['parl'])}\nTotal Reminted: ${formatToCurrency(item['lp'] + item['parl'])}\nNet Burn: ${formatToCurrency(item['net'])}';
      case 'XOR':
        return 'DATE: ${formatDate(item['x'], formatFullDate: true)}\nGross Burn: ${formatToCurrency(touchedSpot.y)}';
      default:
        return 'DATE: ${formatDate(item['x'], formatFullDate: true)}\nGross Burn: ${formatToCurrency(touchedSpot.y)}';
    }
  }

  String getSupplyTooltipData(LineBarSpot touchedSpot) {
    Map<String, dynamic> item = List.from(_supplyGraphData!['data']).firstWhere(
        (spot) => spot['x'] == touchedSpot.x && spot['y'] == touchedSpot.y);
    return 'DATE: ${formatDate(item['x'], formatFullDate: true)}\nGross Burn: ${formatToCurrency(touchedSpot.y, decimalDigits: 4)}';
  }

  // GRAPH DATA //

  void changeToken(String token) {
    if (token != _selectedToken.value) {
      fetchTracker(token);
      _selectedToken.value = token;
    }
  }

  List<String> get getGrossTableDataHeader {
    if (_selectedToken.value == _tabs[0]) {
      return [
        'Latest Blocks',
        'Gross burn',
        'Reminted for LP',
        'Reminted for Parliament',
        'Net burn'
      ];
    }

    return [
      'Latest Blocks',
      'XOR for buyback',
      'Gross burn',
      'Reminted for Parliament',
      'Net burn'
    ];
  }

  void setFilterBurning(String filter) {
    if (filter != _selectedFilterBurning.value) {
      _selectedFilterBurning.value = filter;
    }
  }

  @override
  void onInit() {
    fetchTracker(_tabs[0]);
    super.onInit();
  }

  Future fetchTracker(String token) async {
    _loadingStatus.value = LoadingStatus.LOADING;

    final response = await getTracker.execute(token);

    if (response != null) {
      if (response['blocksFees'] != null && response['blocksTbc'] != null) {
        BlockList blockListFees =
            BlockList.fromJson(response['blocksFees']['data']);
        BlockList blockListTBC =
            BlockList.fromJson(response['blocksTbc']['data']);

        List<Block>? blocksFees = blockListFees.blocks;
        List<Block>? blocksTbc = blockListTBC.blocks;

        if (blocksFees != null && blocksTbc != null) {
          if (token == 'VAL') {
            _blocksXorSpent = blocksTbc;
            _pageMetaXorSpent =
                PageMeta.fromJson(response['blocksTbc']['meta']);
          } else {
            _blocksXorSpent = blocksFees;
            _pageMetaXorSpent =
                PageMeta.fromJson(response['blocksFees']['meta']);
          }

          _blocksGrossTable = blocksFees;
          _pageMetaGrossTable =
              PageMeta.fromJson(response['blocksFees']['meta']);
        } else {
          _blocksXorSpent = [];
          _blocksGrossTable = [];
        }
      }

      _burnData = getDefaultMapValue(response['burn'], nullable: true);

      if (response['graphBurning'] != null &&
          response['graphBurning'] is List) {
        _burningGraph = response['graphBurning'];
        _setBurningGraphData();
      }

      if (response['graphSupply'] != null && response['graphSupply'] is List) {
        _supplyGraph = response['graphSupply'];
        _setSupplyGraphData();
      }

      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }

  // PAGINATION //

  String getBlockType(TrackerTableType trackerBlockType) {
    if (trackerBlockType == TrackerTableType.XOR_SPENT) {
      if (_selectedToken.value == 'VAL') {
        return 'TBC';
      }
    }

    return 'FEES';
  }

  Future _fetchBlocks(TrackerTableType trackerBlockType, int page) async {
    final response = await getTrackerBlocks.execute(
      _selectedToken.value,
      getBlockType(trackerBlockType),
      page,
    );

    if (response != null) {
      if (trackerBlockType == TrackerTableType.XOR_SPENT) {
        BlockList blockList = BlockList.fromJson(response['data']);
        _pageMetaXorSpent = PageMeta.fromJson(response['meta']);

        List<Block>? blocks = blockList.blocks;

        if (blocks != null) {
          _blocksXorSpent = blockList.blocks!;
        }

        _loadingXorSpent.value = LoadingStatus.READY;
      } else {
        BlockList blockList = BlockList.fromJson(response['data']);
        _pageMetaGrossTable = PageMeta.fromJson(response['meta']);

        List<Block>? blocks = blockList.blocks;

        if (blocks != null) {
          _blocksGrossTable = blockList.blocks!;
        }

        _loadingGrossTable.value = LoadingStatus.READY;
      }
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }

  void goToFirstPage(TrackerTableType trackerBlockType) {
    if (trackerBlockType == TrackerTableType.XOR_SPENT) {
      if (_pageMetaXorSpent.hasPreviousPage) {
        _loadingXorSpent.value = LoadingStatus.LOADING;
        _fetchBlocks(trackerBlockType, 1);
      }
    } else {
      if (_pageMetaGrossTable.hasPreviousPage) {
        _loadingGrossTable.value = LoadingStatus.LOADING;
        _fetchBlocks(trackerBlockType, 1);
      }
    }
  }

  void goToPreviousPage(TrackerTableType trackerBlockType) {
    if (trackerBlockType == TrackerTableType.XOR_SPENT) {
      if (_pageMetaXorSpent.hasPreviousPage) {
        _loadingXorSpent.value = LoadingStatus.LOADING;
        _fetchBlocks(trackerBlockType, _pageMetaXorSpent.pageNumber - 1);
      }
    } else {
      if (_pageMetaGrossTable.hasPreviousPage) {
        _loadingGrossTable.value = LoadingStatus.LOADING;
        _fetchBlocks(trackerBlockType, _pageMetaGrossTable.pageNumber - 1);
      }
    }
  }

  void goToNextPage(TrackerTableType trackerBlockType) {
    if (trackerBlockType == TrackerTableType.XOR_SPENT) {
      if (_pageMetaXorSpent.hasNextPage) {
        _loadingXorSpent.value = LoadingStatus.LOADING;
        _fetchBlocks(trackerBlockType, _pageMetaXorSpent.pageNumber + 1);
      }
    } else {
      if (_pageMetaGrossTable.hasNextPage) {
        _loadingGrossTable.value = LoadingStatus.LOADING;
        _fetchBlocks(trackerBlockType, _pageMetaGrossTable.pageNumber + 1);
      }
    }
  }

  void goToLastPage(TrackerTableType trackerBlockType) {
    if (trackerBlockType == TrackerTableType.XOR_SPENT) {
      if (_pageMetaXorSpent.hasNextPage) {
        _loadingXorSpent.value = LoadingStatus.LOADING;
        _fetchBlocks(trackerBlockType, _pageMetaXorSpent.pageCount);
      }
    } else {
      if (_pageMetaGrossTable.hasNextPage) {
        _loadingGrossTable.value = LoadingStatus.LOADING;
        _fetchBlocks(trackerBlockType, _pageMetaGrossTable.pageCount);
      }
    }
  }
}
