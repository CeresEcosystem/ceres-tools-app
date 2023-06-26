import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/portfolio_item.dart';
import 'package:ceres_locker_app/domain/models/portfolio_list.dart';
import 'package:ceres_locker_app/domain/usecase/get_portfolio_items.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _tabs = ['Portfolio', 'Staking', 'Rewards', 'Liquidity'];

class PortfolioController extends GetxController {
  final getPortfolioItems = Injector.resolve!<GetPortfolioItems>();

  List<PortfolioItem> _portfolioItems = [];
  double _totalValue = 0;
  String _addressDB = '';

  String _walletAddress = '';
  final _pageLoading = LoadingStatus.LOADING.obs;
  final _loadingStatus = LoadingStatus.READY.obs;
  final _selectedTab = _tabs[0].obs;

  LoadingStatus get pageLoading => _pageLoading.value;
  LoadingStatus get loadingStatus => _loadingStatus.value;
  String get walletAddress => _walletAddress;
  List<PortfolioItem> get portfolioItems => _portfolioItems;
  double get totalValue => _totalValue;
  List<String> get tabs => _tabs;
  String get selectedTab => _selectedTab.value;

  void onTyping(String text) {
    _walletAddress = text;
  }

  @override
  void onInit() {
    getAddressFromDatabase();
    super.onInit();
  }

  changeSelectedTab(String tab) {
    if (tab != _selectedTab.value) {
      _selectedTab.value = tab;
      fetchPortfolioItems();
    }
  }

  Future getAddressFromDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? address = prefs.getString('address');

    if (address != null && address.isNotEmpty) {
      _addressDB = address;
      _walletAddress = address;
      fetchPortfolioItems();
    }

    _pageLoading.value = LoadingStatus.READY;
  }

  Future saveAddressToDatabase() async {
    if (_walletAddress != _addressDB) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setString('address', _walletAddress);

      if (result) {
        _addressDB = _walletAddress;
      }
    }
  }

  String getPortfolioItemsURL() {
    switch (_selectedTab.value) {
      case 'Portfolio':
        return _walletAddress;
      case 'Staking':
        return 'staking/$_walletAddress';
      case 'Rewards':
        return 'rewards/$_walletAddress';
      case 'Liquidity':
        return 'liquidity/$_walletAddress';
      default:
        return _walletAddress;
    }
  }

  Future fetchPortfolioItems() async {
    if (_walletAddress.isNotEmpty) {
      _loadingStatus.value = LoadingStatus.LOADING;

      saveAddressToDatabase();

      final url = getPortfolioItemsURL();

      final response = await getPortfolioItems.execute(url);

      if (response != null) {
        PortfolioList portfolioList = PortfolioList.fromJson(response);

        if (portfolioList.portfolioItems != null &&
            portfolioList.portfolioItems!.isNotEmpty) {
          List<PortfolioItem> itemsFiltered =
              portfolioList.portfolioItems!.where((pi) {
            if (_selectedTab.value == 'Liquidity') {
              return pi.value! >= 0.0001;
            }

            return pi.value! >= 0.0001 && pi.balance! >= 0.0001;
          }).toList();

          itemsFiltered.sort((portfolioItem1, portfolioItem2) =>
              portfolioItem2.value!.compareTo(portfolioItem1.value!));

          double tv = 0;

          for (PortfolioItem item in itemsFiltered) {
            tv += item.value!;
          }

          _totalValue = tv;
          _portfolioItems = itemsFiltered;
        } else {
          _portfolioItems = [];
          _totalValue = 0;
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
