import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/block.dart';
import 'package:ceres_locker_app/domain/models/block_list.dart';
import 'package:ceres_locker_app/domain/usecase/get_tracker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class TrackerController extends GetxController {
  final getTracker = Injector.resolve!<GetTracker>();

  final _loadingStatus = LoadingStatus.READY.obs;

  final List<String> _filterTimes = ['24h', '7d', '30d', 'all'];
  final _selectedFilterPSWAPBurn = '24h'.obs;
  final _selectedFilterXORSpent = '24h'.obs;
  Map<String, dynamic>? _burnData;
  BlockList? _blockList;
  final int _xorSpentItemsPerPage = 5;
  final _xorSpentPagination = 1.obs;
  final List<String> _mainTableDataHeader = ['Latest Blocks', 'Gross burn', 'Reminted for Liquidity', 'Reminted for parliament', 'PSWAP net burn'];
  final int _mainTableItemsPerPage = 5;
  final _mainTablePagination = 1.obs;
  int? _lastBlockAdded;

  // GRAPH DATA //

  List? _pswapBurningGraph;
  Map<String, dynamic>? _pswapBurningGraphData;
  List? _pswapSupplyGraph;
  Map<String, dynamic>? _pswapSupplyGraphData;

  Map<String, dynamic>? get pswapBurningGraphData => _pswapBurningGraphData;
  Map<String, dynamic>? get pswapSupplyGraphData => _pswapSupplyGraphData;

  void _setPswapBurningGraphData() {
    if (_pswapBurningGraph != null && _pswapBurningGraph!.isNotEmpty) {
      double maxY = 0;
      double maxX = 0;
      double minX = 0;
      List<Map<String, dynamic>> data = [];

      for (var i = 0; i < _pswapBurningGraph!.length; i++) {
        final value = _pswapBurningGraph![i];
        if (value is Map<String, dynamic>) {
          double x = dateStringToDouble(value['x']);
          double y = getDefaultDoubleValue(value['y'])!;

          if (x > 0 && y > 0) {
            if (value['y'] != null && value['y'] > maxY) {
              maxY = y;
            }
            if (i == _pswapBurningGraph!.length - 1 && value['x'] != null) {
              maxX = x;
            }
            if (i == 0 && value['x'] != null) {
              minX = x;
            }
            data.add({...value, 'y': y, 'x': x});
          }
        }
      }

      _pswapBurningGraphData = {'maxY': maxY, 'maxX': maxX, 'minX': minX, 'intervalY': maxY / 4, 'intervalX': (maxX - minX) / 2, 'data': data};
    } else {
      _pswapBurningGraphData = null;
    }
  }

  void _setPswapSupplyGraphData() {
    if (_pswapSupplyGraph != null && _pswapSupplyGraph!.isNotEmpty) {
      double maxY = 0;
      double minY = 0;
      double maxX = 0;
      double minX = 0;
      List<Map<String, dynamic>> data = [];

      for (var i = 0; i < _pswapSupplyGraph!.length; i++) {
        final value = _pswapSupplyGraph![i];
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
            if (i == _pswapSupplyGraph!.length - 1 && value['x'] != null) {
              maxX = x;
            }
            data.add({...value, 'y': y, 'x': x});
          }
        }
      }

      _pswapSupplyGraphData = {'maxY': maxY, 'minY': minY, 'maxX': maxX, 'minX': minX, 'intervalY': (maxY - minY) / 4, 'intervalX': (maxX - minX) / 2, 'data': data};
    } else {
      _pswapSupplyGraphData = null;
    }
  }

  String getTooltipData(LineBarSpot touchedSpot) {
    Map<String, dynamic> item = List.from(pswapBurningGraphData!['data']).firstWhere((spot) => spot['x'] == touchedSpot.x && spot['y'] == touchedSpot.y);
    return 'DATE: ${formatDate(item['x'], formatFullDate: true)}\nPSWAP Gross Burn: ${formatToCurrency(touchedSpot.y)}\nXOR Spent: ${formatToCurrency(item['spent'])}\nPSWAP Reminted LP: ${formatToCurrency(item['lp'])}\nPSWAP Reminted Parliament: ${formatToCurrency(item['parl'])}\nTotal Reminted: ${formatToCurrency(item['lp'] + item['parl'])}\nPSWAP Net Burn: ${formatToCurrency(item['net'])}';
  }

  String getSupplyTooltipData(LineBarSpot touchedSpot) {
    Map<String, dynamic> item = List.from(pswapSupplyGraphData!['data']).firstWhere((spot) => spot['x'] == touchedSpot.x && spot['y'] == touchedSpot.y);
    return 'DATE: ${formatDate(item['x'], formatFullDate: true)}\nPSWAP supply: ${formatToCurrency(touchedSpot.y, decimalDigits: 4)}';
  }

  // GRAPH DATA //

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<String> get filterTimes => _filterTimes;
  String get selectedFilterPSWAPBurn => _selectedFilterPSWAPBurn.value;
  String get selectedFilterXORSpent => _selectedFilterXORSpent.value;
  Map<String, dynamic>? get burnData {
    if (_burnData != null && _burnData!.isNotEmpty) {
      if (_selectedFilterPSWAPBurn.value == 'all') return _burnData!['-1'];
      for (String key in _burnData!.keys) {
        if (_selectedFilterPSWAPBurn.value.contains(key)) return _burnData![key];
      }
    }

    return null;
  }

  int get xorSpentTotalPages {
    if (_blockList != null && _blockList!.blocks != null && _blockList!.blocks!.isNotEmpty) {
      int limiter = getLimiter();

      if (limiter != -1) {
        List<Block> blocksLimited = _blockList!.blocks!.where((Block block) => block.blockNumber! >= limiter).toList();
        return (blocksLimited.length / _xorSpentItemsPerPage).ceil();
      }

      return (_blockList!.blocks!.length / _xorSpentItemsPerPage).ceil();
    }

    return 0;
  }

  List<Block>? get xorSpent {
    if (_blockList != null && _blockList!.blocks != null && _blockList!.blocks!.isNotEmpty) {
      int lastPage = _xorSpentPagination.value * _xorSpentItemsPerPage;
      int limiter = getLimiter();

      if (limiter != -1) {
        List<Block> blocksLimited = _blockList!.blocks!.where((Block block) => block.blockNumber! >= limiter).toList();

        int lastPageForList = lastPage > blocksLimited.length ? blocksLimited.length : lastPage;
        return blocksLimited.getRange((_xorSpentPagination.value * _xorSpentItemsPerPage) - _xorSpentItemsPerPage, lastPageForList).toList();
      }

      int lastPageForList = lastPage > _blockList!.blocks!.length ? _blockList!.blocks!.length : lastPage;

      return _blockList!.blocks!.getRange((_xorSpentPagination.value * _xorSpentItemsPerPage) - _xorSpentItemsPerPage, lastPageForList).toList();
    }

    return null;
  }

  int get xorSpentPagination => _xorSpentPagination.value;

  List<String> get mainTableDataHeader => _mainTableDataHeader;
  int get mainTablePagination => _mainTablePagination.value;
  int get mainTableTotalPages => _blockList != null && _blockList!.blocks != null && _blockList!.blocks!.isNotEmpty ? (_blockList!.blocks!.length / _mainTableItemsPerPage).ceil() : 0;
  List<Block>? get mainTableData {
    if (_blockList != null && _blockList!.blocks != null && _blockList!.blocks!.isNotEmpty) {
      int lastPage = _mainTablePagination.value * _mainTableItemsPerPage;
      int lastPageForList = lastPage > _blockList!.blocks!.length ? _blockList!.blocks!.length : lastPage;
      return _blockList!.blocks!.getRange((_mainTablePagination.value * _mainTableItemsPerPage) - _mainTableItemsPerPage, lastPageForList).toList();
    }

    return null;
  }

  int getLimiter() {
    if (_lastBlockAdded != null) {
      switch (_selectedFilterXORSpent.value) {
        case '24h':
          return _lastBlockAdded! - 14400;
        case '7d':
          return _lastBlockAdded! - 100800;
        case '30d':
          return _lastBlockAdded! - 432000;
        default:
          return -1;
      }
    }

    return -1;
  }

  void setFilterPSWAPBurn(String filter) {
    if (filter != _selectedFilterPSWAPBurn.value) {
      _selectedFilterPSWAPBurn.value = filter;
    }
  }

  void setFilterXORSpent(String filter) {
    if (filter != _selectedFilterXORSpent.value) {
      _selectedFilterXORSpent.value = filter;
    }
  }

  void setXorSpentPage(int page) {
    if (page > 0 && page <= xorSpentTotalPages && page != _xorSpentPagination.value) {
      _xorSpentPagination.value = page;
    }
  }

  void setMainTablePage(int page) {
    if (page > 0 && page <= mainTableTotalPages && page != _mainTablePagination.value) {
      _mainTablePagination.value = page;
    }
  }

  final _faqs = [
    {'question': 'What is Polkaswap?', 'answer': 'Polkaswap is a next-generation, cross-chain liquidity aggregator DEX protocol for swapping tokens based on the Polkadot (and Kusama) network(s), Parachains, and blockchains connected via bridges. Through the development of bridge technologies, Polkaswap enables Ethereum-based tokens to be traded. This is done seamlessly, at high speed and low fees, while exchanging assets in a non-custodial manner on the SORA network.'},
    {'question': 'What is the purpose of Polkaswap (PSWAP) token?', 'answer': '• Used to reward liquidity providers on Polkaswap\n• Decreasing supply, with tokens burned with every token swap on Polkaswap\n• The 0.3% fee for every swap on the Polkaswap DEX is used to buy back PSWAP tokens, which are then burned.'},
    {'question': 'What is the distribution of PSWAP?', 'answer': 'PSWAP max supply is 10 billion, decreasing with tokens burned.\n• ~6% rewards at launch (Sora farm game finished)\n• 30% supply for development team (released)\n• 25% token bonding curve rewards (vested)\n• 35% liquidity rewards (vested)\n• ~4% market making rewards (vested)'},
    {'question': 'How PSWAP burning and reminting work?', 'answer': 'Unlike transaction fee models on other exchanges, on Polkaswap, trading fees are used to buy back and burn PSWAP tokens and then new PSWAP tokens are minted to reward LPs. Newly minted PSWAP tokens to liquidity providers start at 90% of the amount of burned PSWAP tokens in a 24 hour time period, and will gradually decrease down to a constant at 35% of daily burned tokens after 5 years.'},
    {'question': 'How can I earn PSWAP tokens?', 'answer': 'PSWAP tokens can be earned in three ways:\n• The first way to earn PSWAP tokens is to be one of the liquidity providers on Polkaswap.\n• The second way to earn PSWAP is to buy XOR with ETH, DAI, DOT, or KSM from the token bonding curve.\n• The third way to earn PSWAP tokens is from market making rebates on Polkaswap.'},
    {'question': 'What are the benefits of being liquidity provider on Polkaswap?', 'answer': 'About 2,500,000 PSWAP will be allocated daily to liquidity providers on Polkaswap, and after a vesting period, users will be able to claim them. To read the full article on the first incentive program, have a look', 'link': 'https://medium.com/polkaswap/pswap-rewards-1-polkaswap-liquidity-reward-farming-3e045d71509'},
    {'question': 'How to earn PSWAP tokens using token bonding curve (TBC)?', 'answer': 'Buying XOR with ETH, DAI, DOT, or KSM would help grow the SORA ecosystem, collateralize the bonding curve, and in the case of DOT and KSM, help SORA secure parachain slots for the Polkadot and Kusama chains respectively. 2.5 billion PSWAP tokens have been allocated as rewards for XOR buyers.'},
    {'question': 'What are market making rebates on Polkaswap?', 'answer': '400 million PSWAP (20 million per month) will be reserved proportionally for market makers that have at least 500 transactions with an average of at least 1 XOR in each transaction. You can read the details', 'link': 'https://medium.com/polkaswap/pswap-rewards-part-3-polkaswap-market-making-rebates-1856f62ccfaa'},
  ];
  final List<Map<String, dynamic>> _contactSocials = [
    {'icon': 'lib/core/assets/images/medium_icon.png', 'url': 'https://tokenceres.medium.com'},
    {'icon': 'lib/core/assets/images/telegram_icon.png', 'url': 'https://t.me/cerestoken'},
    {'icon': 'lib/core/assets/images/twitter_icon.png', 'url': 'https://twitter.com/TokenCeres'},
  ];

  List get faqs => _faqs;
  List<Map<String, dynamic>> get contactSocials => _contactSocials;

  @override
  void onInit() {
    fetchTracker();
    super.onInit();
  }

  void fetchTracker([bool refresh = false]) async {
    _loadingStatus.value = refresh ? LoadingStatus.IDLE : LoadingStatus.LOADING;

    final response = await getTracker.execute();

    if (response != null) {
      if (response['blocks'] != null && response['blocks'] is List) {
        _blockList = BlockList.fromJson(response['blocks']);
      }
      _burnData = getDefaultMapValue(response['burn'], nullable: true);
      _lastBlockAdded = getDefaultIntValue(response['last']);

      if (response['graph_burning'] != null && response['graph_burning'] is List) {
        _pswapBurningGraph = response['graph_burning'];
        _setPswapBurningGraphData();
      }

      if (response['graph_supply'] != null && response['graph_supply'] is List) {
        _pswapSupplyGraph = response['graph_supply'];
        _setPswapSupplyGraphData();
      }

      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }
}
