import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/portfolio_item.dart';
import 'package:ceres_locker_app/domain/models/portfolio_list.dart';
import 'package:ceres_locker_app/domain/usecase/get_portfolio_items.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortfolioController extends GetxController {
  final getPortfolioItems = Injector.resolve!<GetPortfolioItems>();

  List<PortfolioItem> _portfolioItems = [];
  double _totalValue = 0;
  String _addressDB = '';

  String _searchQueary = '';
  final _pageLoading = LoadingStatus.LOADING.obs;
  final _loadingStatus = LoadingStatus.READY.obs;

  LoadingStatus get pageLoading => _pageLoading.value;
  LoadingStatus get loadingStatus => _loadingStatus.value;
  String get searchQuery => _searchQueary;
  List<PortfolioItem> get portfolioItems => _portfolioItems;
  double get totalValue => _totalValue;

  void onTyping(String text) {
    _searchQueary = text;
  }

  @override
  void onInit() {
    getAddressFromDatabase();
    super.onInit();
  }

  Future getAddressFromDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? address = prefs.getString('address');

    if (address != null && address.isNotEmpty) {
      _addressDB = address;
      _searchQueary = address;
      _pageLoading.value = LoadingStatus.READY;
      fetchPortfolioItems();
    }
  }

  Future saveAddressToDatabase() async {
    if (_searchQueary != _addressDB) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setString('address', _searchQueary);

      if (result) {
        _addressDB = _searchQueary;
      }
    }
  }

  Future fetchPortfolioItems() async {
    if (_searchQueary.isNotEmpty) {
      _loadingStatus.value = LoadingStatus.LOADING;

      saveAddressToDatabase();

      final response = await getPortfolioItems.execute(_searchQueary);

      if (response != null) {
        PortfolioList portfolioList = PortfolioList.fromJson(response);

        if (portfolioList.portfolioItems != null &&
            portfolioList.portfolioItems!.isNotEmpty) {
          List<PortfolioItem> itemsFiltered = portfolioList.portfolioItems!
              .where((pi) => pi.balance! >= 0.0001)
              .toList();
          itemsFiltered.sort((portfolioItem1, portfolioItem2) =>
              portfolioItem2.value!.compareTo(portfolioItem1.value!));

          double tv = 0;

          for (PortfolioItem item in itemsFiltered) {
            tv += item.value!;
          }

          _totalValue = tv;
          _portfolioItems = itemsFiltered;
        }

        _loadingStatus.value = LoadingStatus.READY;
      } else {
        _portfolioItems = [];
        _totalValue = 0;
        _loadingStatus.value = LoadingStatus.ERROR;
      }
    }
  }
}
