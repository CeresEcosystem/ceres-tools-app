import 'dart:convert';

import 'package:ceres_tools_app/core/assets/fonts/flaticon.dart';
import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/image_extension.dart';
import 'package:ceres_tools_app/core/utils/toast.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/apollo_dashboard.dart';
import 'package:ceres_tools_app/domain/models/page_meta.dart';
import 'package:ceres_tools_app/domain/models/portfolio_item.dart';
import 'package:ceres_tools_app/domain/models/portfolio_list.dart';
import 'package:ceres_tools_app/domain/models/swap.dart';
import 'package:ceres_tools_app/domain/models/swap_list.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/domain/models/token_list.dart';
import 'package:ceres_tools_app/domain/models/transfer.dart';
import 'package:ceres_tools_app/domain/models/transfer_list.dart';
import 'package:ceres_tools_app/domain/models/wallet.dart';
import 'package:ceres_tools_app/domain/usecase/get_apollo_dashboard.dart';
import 'package:ceres_tools_app/domain/usecase/get_portfolio_items.dart';
import 'package:ceres_tools_app/domain/usecase/get_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<Map<String, dynamic>> _tabs = [
  {
    'label': 'Portfolio',
    'icon': const Icon(Icons.star),
    'index': 0,
  },
  {
    'label': 'Staking',
    'icon': const Icon(Flaticon.token),
    'index': 1,
  },
  {
    'label': 'Rewards',
    'icon': const Icon(Icons.emoji_events),
    'index': 2,
  },
  {
    'label': 'Liquidity',
    'icon': const HeroIcon(
      HeroIcons.circleStack,
    ),
    'index': 3,
  },
  {
    'label': 'Swaps',
    'icon': const Icon(Icons.swap_horiz),
    'index': 4,
  },
  {
    'label': 'Transfers',
    'icon': const Icon(Icons.swap_vert),
    'index': 5,
  },
  {
    'label': 'Apollo',
    'icon': SvgPicture.network(
      '${kImageStorage}APOLLO.svg',
      height: Dimensions.ICON_SIZE,
    ),
    'index': 6,
  },
];
const _timeFrames = ['1h', '24h', '7d', '30d'];
const kSelectedWallet = 'SELECTED_WALLET';
const kWalletExistError = 'Wallet with entered address already exist.';

class PortfolioController extends GetxController {
  final getPortfolioItems = Injector.resolve!<GetPortfolioItems>();
  final getTokens = Injector.resolve!<GetTokens>();
  final getApolloDashboard = Injector.resolve!<GetApolloDashboard>();

  List<PortfolioItem> _portfolioItems = [];
  List<Swap> _swaps = [];
  List<Transfer> _transfers = [];
  List<Token> _tokens = [];
  PageMeta _pageMeta = PageMeta(0, 0, 0, 0, false, false);

  double _totalValue = 0;
  double _totalValueChangeForTimeFrame = 0;

  final List<Wallet> _wallets = [];
  final _selectedWallet = Wallet('', '', false).obs;

  final _pageLoading = LoadingStatus.LOADING.obs;
  final _loadingStatus = LoadingStatus.READY.obs;
  final _selectedTab = 0.obs;
  final _selectedTimeFrame = _timeFrames[0].obs;

  ApolloDashboard _apolloDashboard = ApolloDashboard.empty();

  LoadingStatus get pageLoading => _pageLoading.value;
  LoadingStatus get loadingStatus => _loadingStatus.value;

  List<Wallet> get wallets => _wallets;
  List<Wallet> get walletsForDB =>
      _wallets.where((w) => w.temporaryAddress == false).toList();
  Wallet get selectedWallet => _selectedWallet.value;
  List<PortfolioItem> get portfolioItems => _portfolioItems;
  List<Swap> get swaps => _swaps;
  List<Transfer> get transfers => _transfers;
  PageMeta get pageMeta => _pageMeta;
  double get totalValue => _totalValue;
  double get totalValueChangeForTimeFrame => _totalValueChangeForTimeFrame;
  List<Map<String, dynamic>> get tabs => _tabs;
  List<String> get timeFrames => _timeFrames;
  int get selectedTab => _selectedTab.value;
  String get selectedTimeFrame => _selectedTimeFrame.value;
  ApolloDashboard get apolloDashboard => _apolloDashboard;

  @override
  void onInit() async {
    String address = Get.arguments != null ? Get.arguments['address'] : '';
    getWalletsFromDatabase(address);
    await setTokens();
    super.onInit();
  }

  changeSelectedTab(int tab) {
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
      showToastAndCopy(kWalletExistError, '', shouldCopy: false);
    } else {
      _wallets.add(wallet);

      if (storeWallets) {
        List<String> walletsJSON =
            walletsForDB.map((w) => jsonEncode(w.toJson())).toList();
        prefs.setStringList(kWallets, walletsJSON);
        prefs.setString(kSelectedWallet, jsonEncode(wallet.toJson()));
      }

      _selectedWallet.value = wallet;

      fetchPortfolioItems();
    }
  }

  editWallet(Wallet wallet, Wallet previousWallet, SharedPreferences prefs) {
    int walletIndex =
        _wallets.indexWhere((w) => w.address == previousWallet.address);

    Wallet? walletExist =
        _wallets.firstWhereOrNull((w) => w.address == wallet.address);

    bool shouldEdit =
        walletExist == null || wallet.address == previousWallet.address;

    if (shouldEdit) {
      _wallets[walletIndex] =
          Wallet(wallet.name, wallet.address, wallet.temporaryAddress);
      List<String> walletsJSON =
          walletsForDB.map((w) => jsonEncode(w.toJson())).toList();
      prefs.setStringList(kWallets, walletsJSON);
      prefs.setString(kSelectedWallet, jsonEncode(wallet.toJson()));
      _selectedWallet.value = wallet;

      fetchPortfolioItems();
    } else {
      showToastAndCopy(kWalletExistError, '', shouldCopy: false);
    }
  }

  Future addEditWallet(Wallet wallet, Wallet previousWallet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (previousWallet.address.isNotEmpty) {
      editWallet(wallet, previousWallet, prefs);
    } else {
      addWallet(wallet, wallet.name.isNotEmpty, prefs);
    }
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
      case 0:
        return _selectedWallet.value.address;
      case 1:
        return 'staking/${_selectedWallet.value.address}';
      case 2:
        return 'rewards/${_selectedWallet.value.address}';
      case 3:
        return 'liquidity/${_selectedWallet.value.address}';
      case 4:
        return 'swaps/${_selectedWallet.value.address}';
      case 5:
        return 'transfers/${_selectedWallet.value.address}';
      default:
        return _selectedWallet.value.address;
    }
  }

  Future setTokens() async {
    final tokensResponse = await getTokens.execute();

    if (tokensResponse != null) {
      TokenList tokenList = TokenList.fromJson(tokensResponse);
      if (tokenList.tokens != null && tokenList.tokens!.isNotEmpty) {
        _tokens = tokenList.tokens!;
      }
    }
  }

  setSwaps(dynamic response) async {
    SwapList swapList = SwapList.fromJson(response['data']);
    _pageMeta = PageMeta.fromJson(response['meta']);

    if (swapList.swaps.isNotEmpty) {
      List<Swap> swapFormatted = [];

      for (final swap in swapList.swaps) {
        Swap s = swap;
        s.inputAsset = _tokens
                .firstWhereOrNull((t) => t.assetId == s.inputAssetId)
                ?.shortName ??
            '';
        s.outputAsset = _tokens
                .firstWhereOrNull((t) => t.assetId == s.outputAssetId)
                ?.shortName ??
            '';
        s.inputImageExtension = imageExtension(s.inputAsset);
        s.outputImageExtension = imageExtension(s.outputAsset);
        s.swappedAt = formatDateToLocalTime(s.swappedAt);
        swapFormatted.add(s);
      }

      _swaps = swapFormatted;
    } else {
      _swaps = [];
    }

    _loadingStatus.value = LoadingStatus.READY;
  }

  setTransfers(dynamic response) async {
    TransferList transferList = TransferList.fromJson(response['data']);
    _pageMeta = PageMeta.fromJson(response['meta']);

    if (transferList.transfers.isNotEmpty) {
      List<Transfer> transferFormatted = [];

      for (final transfer in transferList.transfers) {
        Transfer tr = transfer;
        tr.tokenFormatted =
            _tokens.firstWhereOrNull((t) => t.assetId == tr.asset)?.shortName ??
                '';
        tr.tokenImageExtension = imageExtension(tr.asset);
        tr.transferredAtFormatted = formatDateToLocalTime(tr.transferredAt);

        transferFormatted.add(tr);
      }

      _transfers = transferFormatted;
    } else {
      _swaps = [];
    }

    _loadingStatus.value = LoadingStatus.READY;
  }

  Future _fetchApolloDashboard(String address) async {
    final response = await getApolloDashboard.execute(address);

    if (response != null) {
      final rewardPrice =
          _tokens.firstWhere((Token t) => t.shortName == 'APOLLO').price ?? 0;

      _apolloDashboard = ApolloDashboard.fromJson(response);

      _apolloDashboard = ApolloDashboard(
        lendingInfo: _apolloDashboard.lendingInfo
            .where((item) => item.amount > 0)
            .map((item) {
          item.amountPrice = item.amount *
              (_tokens
                      .firstWhere((Token t) => t.assetId == item.poolAssetId)
                      .price ??
                  0);
          item.rewardPrice = item.rewards * rewardPrice;

          return item;
        }).toList(),
        borrowingInfo: _apolloDashboard.borrowingInfo
            .where((item) => item.amount > 0)
            .map((item) {
          double amountPrice = _tokens
                  .firstWhere((Token t) => t.assetId == item.poolAssetId)
                  .price ??
              0;

          item.amountPrice = item.amount * amountPrice;
          item.interestPrice = item.interest * amountPrice;
          item.rewardPrice = item.rewards * rewardPrice;
          item.collaterals = item.collaterals.map((collateral) {
            collateral.collateralAmountPrice = collateral.collateralAmount *
                (_tokens
                        .firstWhere((Token t) =>
                            t.assetId == collateral.collateralAssetId)
                        .price ??
                    0);
            collateral.borrowedAmountPrice =
                collateral.borrowedAmount * amountPrice;
            collateral.interestPrice = collateral.interest * amountPrice;
            collateral.rewardPrice = collateral.rewards * rewardPrice;
            return collateral;
          }).toList();

          return item;
        }).toList(),
        stats: _apolloDashboard.stats,
      );
      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }

  Future fetchPortfolioItems([int page = 1]) async {
    if (_wallets.isNotEmpty && _selectedWallet.value.address.isNotEmpty) {
      _loadingStatus.value = LoadingStatus.LOADING;

      final url = getPortfolioItemsURL();

      if (_selectedTab.value == 6) {
        _portfolioItems = [];
        _swaps = [];
        _totalValue = 0;

        await _fetchApolloDashboard(url);
        return;
      }

      final response = await getPortfolioItems.execute(url, page);

      if (response != null) {
        if (_selectedTab.value == 4) {
          setSwaps(response);
        } else if (_selectedTab.value == 5) {
          setTransfers(response);
        } else {
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
              if (_selectedTab.value == 3) {
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
        }
      } else {
        _portfolioItems = [];
        _swaps = [];
        _totalValue = 0;
        _loadingStatus.value = LoadingStatus.ERROR;
      }
    }
  }

  void goToFirstPage() {
    if (_pageMeta.hasPreviousPage) {
      fetchPortfolioItems();
    }
  }

  void goToPreviousPage() {
    if (_pageMeta.hasPreviousPage) {
      fetchPortfolioItems(_pageMeta.pageNumber - 1);
    }
  }

  void goToNextPage() {
    if (_pageMeta.hasNextPage) {
      fetchPortfolioItems(_pageMeta.pageNumber + 1);
    }
  }

  void goToLastPage() {
    if (_pageMeta.hasNextPage) {
      fetchPortfolioItems(_pageMeta.pageCount);
    }
  }
}
