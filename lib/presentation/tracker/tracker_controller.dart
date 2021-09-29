import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:get/get.dart';

class TrackerController extends GetxController {
  final _loadingStatus = LoadingStatus.READY.obs;
  final List<String> _filterTimes = ['24h', '7d', '30d', 'all'];
  final _selectedFilter = '24h'.obs;
  final List<Map<String, dynamic>> _xorSpent = [
    {'block': '#13,138,507', 'xor': '1,906.07'},
    {'block': '#13,138,507', 'xor': '1,906.07'},
    {'block': '#13,138,507', 'xor': '1,906.07'},
    {'block': '#13,138,507', 'xor': '1,906.07'},
    {'block': '#13,138,507', 'xor': '1,906.07'},
    {'block': '#12,138,507', 'xor': '1,906.07'},
    {'block': '#12,138,507', 'xor': '1,906.07'},
    {'block': '#12,138,507', 'xor': '1,906.07'},
    {'block': '#12,138,507', 'xor': '1,906.07'},
    {'block': '#12,138,507', 'xor': '1,906.07'},
    {'block': '#11,138,507', 'xor': '1,906.07'},
    {'block': '#11,138,507', 'xor': '1,906.07'},
    {'block': '#11,138,507', 'xor': '1,906.07'},
    {'block': '#11,138,507', 'xor': '1,906.07'},
    {'block': '#11,138,507', 'xor': '1,906.07'},
  ];
  final List<String> _mainTableDataHeader = ['Latest Blocks', 'Gross burn', 'Reminted for Liquidity', 'Reminted for parliament', 'PSWAP net burn'];
  final List<Map<String, dynamic>> _mainTableData = [
    {'block': '#13,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#13,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#13,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#13,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#13,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#12,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#12,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#12,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#12,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#12,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#11,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#11,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#11,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#11,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
    {'block': '#11,138,507', 'gross': '1,906.07', 'remintedlp': '1,906.07', 'remintedp': '1,906.07', 'pswap': '1,906.07'},
  ];
  final int _xorSpentItemsPerPage = 5;
  final _xorSpentPagination = 1.obs;
  final int _mainTableItemsPerPage = 5;
  final _mainTablePagination = 1.obs;
  final _faqs = [
    {'question': 'What is fee burn?', 'answer': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate'},
    {'question': 'What is fee burn?', 'answer': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate'},
    {'question': 'What is fee burn?', 'answer': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate'},
    {'question': 'What is fee burn?', 'answer': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate'},
    {'question': 'What is fee burn?', 'answer': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate'},
  ];
  final List<Map<String, dynamic>> _contactSocials = [
    {'icon': 'lib/core/assets/images/medium_icon.png', 'url': 'https://tokenceres.medium.com'},
    {'icon': 'lib/core/assets/images/telegram_icon.png', 'url': 'https://t.me/cerestoken'},
    {'icon': 'lib/core/assets/images/twitter_icon.png', 'url': 'https://twitter.com/TokenCeres'},
  ];

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<String> get filterTimes => _filterTimes;
  String get selectedFilter => _selectedFilter.value;
  int get xorSpentPagination => _xorSpentPagination.value;
  int get xorSpentTotalPages => (_xorSpent.length / _xorSpentItemsPerPage).ceil();
  List<Map<String, dynamic>> get xorSpent {
    return _xorSpent.getRange((_xorSpentPagination.value * _xorSpentItemsPerPage) - _xorSpentItemsPerPage, _xorSpentPagination.value * _xorSpentItemsPerPage).toList();
  }

  List<String> get mainTableDataHeader => _mainTableDataHeader;
  int get mainTablePagination => _mainTablePagination.value;
  int get mainTableTotalPages => (_mainTableData.length / _mainTableItemsPerPage).ceil();
  List<Map<String, dynamic>> get mainTableData {
    return _mainTableData.getRange((_mainTablePagination.value * _mainTableItemsPerPage) - _mainTableItemsPerPage, _mainTablePagination.value * _mainTableItemsPerPage).toList();
  }

  List get faqs => _faqs;
  List<Map<String, dynamic>> get contactSocials => _contactSocials;

  void setFilter(String filter) {
    if (filter != _selectedFilter.value) {
      _selectedFilter.value = filter;
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
}
