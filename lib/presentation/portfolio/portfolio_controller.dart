import 'dart:convert';

import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/utils/image_extension.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/portfolio_item.dart';
import 'package:ceres_locker_app/domain/models/portfolio_list.dart';
import 'package:ceres_locker_app/domain/models/wallet.dart';
import 'package:ceres_locker_app/domain/usecase/get_portfolio_items.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _tabs = ['Portfolio', 'Staking', 'Rewards', 'Liquidity'];
const _timeFrames = ['1h', '24h', '7d', '30d'];
const kWallets = 'WALLETS';
const kSelectedWallet = 'SELECTED_WALLET';

class PortfolioController extends GetxController {
  final getPortfolioItems = Injector.resolve!<GetPortfolioItems>();

  List<PortfolioItem> _portfolioItems = [];

  double _totalValue = 0;
  double _totalValueChangeForTimeFrame = 0;

  final List<Wallet> _wallets = [];
  final _selectedWallet = Wallet('', '', false).obs;

  final _pageLoading = LoadingStatus.LOADING.obs;
  final _loadingStatus = LoadingStatus.READY.obs;
  final _selectedTab = _tabs[0].obs;
  final _selectedTimeFrame = _timeFrames[0].obs;

  LoadingStatus get pageLoading => _pageLoading.value;
  LoadingStatus get loadingStatus => _loadingStatus.value;

  List<Wallet> get wallets => _wallets;
  List<Wallet> get walletsForDB =>
      _wallets.where((w) => w.temporaryAddress == false).toList();
  Wallet get selectedWallet => _selectedWallet.value;
  List<PortfolioItem> get portfolioItems => _portfolioItems;
  double get totalValue => _totalValue;
  double get totalValueChangeForTimeFrame => _totalValueChangeForTimeFrame;
  List<String> get tabs => _tabs;
  List<String> get timeFrames => _timeFrames;
  String get selectedTab => _selectedTab.value;
  String get selectedTimeFrame => _selectedTimeFrame.value;

  @override
  void onInit() {
    String address = Get.arguments != null ? Get.arguments['address'] : '';
    getWalletsFromDatabase(address);
    super.onInit();
  }

  changeSelectedTab(String tab) {
    if (tab != _selectedTab.value) {
      _selectedTab.value = tab;
      fetchPortfolioItems();
    }
  }

  calculateTotalValueChangeForTimeFrame([String? timeFrame]) {
    switch (timeFrame ?? _selectedTimeFrame.value) {
      case '1h':
        _totalValueChangeForTimeFrame = _portfolioItems.fold(
            0, (double value, pi) => value + pi.oneHourValueDifference!);
        break;
      case '24h':
        _totalValueChangeForTimeFrame = _portfolioItems.fold(
            0, (double value, pi) => value + pi.oneDayValueDifference!);
        break;
      case '7d':
        _totalValueChangeForTimeFrame = _portfolioItems.fold(
            0, (double value, pi) => value + pi.oneWeekValueDifference!);
        break;
      case '30d':
        _totalValueChangeForTimeFrame = _portfolioItems.fold(
            0, (double value, pi) => value + pi.oneMonthValueDifference!);
        break;
    }
  }

  changeSelectedTimeFrame(String timeFrame) {
    if (timeFrame != _selectedTimeFrame.value) {
      calculateTotalValueChangeForTimeFrame(timeFrame);
      _selectedTimeFrame.value = timeFrame;
    }
  }

  Future getWalletsFromDatabase(String address) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? walletsJSON = prefs.getStringList(kWallets);

    if (walletsJSON != null && walletsJSON.isNotEmpty) {
      for (String wallet in walletsJSON) {
        _wallets.add(Wallet.fromJson(jsonDecode(wallet)));
      }

      if (address.isNotEmpty) {
        final walletExist =
            _wallets.firstWhereOrNull((w) => w.address == address);

        if (walletExist != null) {
          prefs.setString(kSelectedWallet, jsonEncode(walletExist.toJson()));
          _selectedWallet.value = walletExist;
        } else {
          Wallet w = Wallet('', address, true);
          _wallets.add(w);
          _selectedWallet.value = w;
        }
      } else {
        final String? selectedWalletJSON = prefs.getString(kSelectedWallet);

        if (selectedWalletJSON != null && selectedWalletJSON.isNotEmpty) {
          _selectedWallet.value =
              Wallet.fromJson(jsonDecode(selectedWalletJSON));
        } else {
          _selectedWallet.value = _wallets[0];
        }
      }

      _pageLoading.value = LoadingStatus.READY;
      await fetchPortfolioItems();
    } else {
      _pageLoading.value = LoadingStatus.READY;
      if (address.isNotEmpty) {
        Wallet w = Wallet('', address, true);
        _wallets.add(w);
        _selectedWallet.value = w;
        await fetchPortfolioItems();
      }
    }
  }

  Future handleWalletChange(Wallet wallet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (wallet != _selectedWallet.value) {
      if (wallet.name.isNotEmpty) {
        prefs.setString(kSelectedWallet, jsonEncode(wallet.toJson()));
      }

      _selectedWallet.value = wallet;
      fetchPortfolioItems();
    }
  }

  addWallet(Wallet wallet, bool storeWallets, SharedPreferences prefs) {
    Wallet? walletExist =
        _wallets.firstWhereOrNull((w) => w.address == wallet.address);

    if (walletExist != null) {
      if (storeWallets) {
        prefs.setString(kSelectedWallet, jsonEncode(walletExist.toJson()));
      }

      _selectedWallet.value = walletExist;
    } else {
      _wallets.add(wallet);

      if (storeWallets) {
        List<String> walletsJSON =
            walletsForDB.map((w) => jsonEncode(w.toJson())).toList();
        prefs.setStringList(kWallets, walletsJSON);
        prefs.setString(kSelectedWallet, jsonEncode(wallet.toJson()));
      }

      _selectedWallet.value = wallet;
    }
  }

  editWallet(Wallet wallet, int index, SharedPreferences prefs) {
    if (index != -1) {
      _wallets[index] =
          Wallet(wallet.name, wallet.address, wallet.temporaryAddress);
    }

    List<String> walletsJSON =
        walletsForDB.map((w) => jsonEncode(w.toJson())).toList();
    prefs.setStringList(kWallets, walletsJSON);
    prefs.setString(kSelectedWallet, jsonEncode(wallet.toJson()));
    _selectedWallet.value = wallet;
  }

  Future addEditWallet(Wallet wallet, Wallet previousWallet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (wallet.name.isNotEmpty) {
      if (previousWallet.address.isNotEmpty) {
        int editWalletIndex =
            _wallets.indexWhere((w) => w.address == previousWallet.address);

        editWallet(wallet, editWalletIndex, prefs);
      } else {
        addWallet(wallet, true, prefs);
      }
    } else {
      addWallet(wallet, false, prefs);
    }

    fetchPortfolioItems();
  }

  Future removeWallet(Wallet wallet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _wallets.removeWhere((w) => w.address == wallet.address);

    List<String> walletsJSON =
        walletsForDB.map((w) => jsonEncode(w.toJson())).toList();
    prefs.setStringList(kWallets, walletsJSON);

    if (_wallets.isNotEmpty) {
      prefs.setString(kSelectedWallet, jsonEncode(_wallets[0].toJson()));
      _selectedWallet.value = _wallets[0];
    } else {
      Wallet emptyWallet = Wallet('', '', false);
      prefs.setString(kSelectedWallet, jsonEncode(emptyWallet.toJson()));
      _selectedWallet.value = emptyWallet;
    }

    fetchPortfolioItems();
  }

  String getPortfolioItemsURL() {
    switch (_selectedTab.value) {
      case 'Portfolio':
        return _selectedWallet.value.address;
      case 'Staking':
        return 'staking/${_selectedWallet.value.address}';
      case 'Rewards':
        return 'rewards/${_selectedWallet.value.address}';
      case 'Liquidity':
        return 'liquidity/${_selectedWallet.value.address}';
      default:
        return _selectedWallet.value.address;
    }
  }

  Future fetchPortfolioItems() async {
    if (_wallets.isNotEmpty && _selectedWallet.value.address.isNotEmpty) {
      _loadingStatus.value = LoadingStatus.LOADING;

      final url = getPortfolioItemsURL();

      final response = await getPortfolioItems.execute(url);

      if (response != null) {
        PortfolioList portfolioList = PortfolioList.fromJson(response);

        if (portfolioList.portfolioItems != null &&
            portfolioList.portfolioItems!.isNotEmpty) {
          for (PortfolioItem pi in portfolioList.portfolioItems!) {
            if (pngIcons.contains(pi.token)) {
              pi.imageExtension = kImagePNGExtension;
            }
          }
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
          calculateTotalValueChangeForTimeFrame();
        } else {
          _portfolioItems = [];
          _totalValue = 0;
          calculateTotalValueChangeForTimeFrame();
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
