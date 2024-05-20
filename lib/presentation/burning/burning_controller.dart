import 'dart:convert';

import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/address_format.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/burn.dart';
import 'package:ceres_tools_app/domain/models/burn_filter.dart';
import 'package:ceres_tools_app/domain/models/burn_list.dart';
import 'package:ceres_tools_app/domain/models/page_meta.dart';
import 'package:ceres_tools_app/domain/models/wallet.dart';
import 'package:ceres_tools_app/domain/usecase/get_burns.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BurningController extends GetxController {
  final getBurns = Injector.resolve!<GetBurns>();

  final _loadingStatus = LoadingStatus.LOADING.obs;
  final _pageLoadingStatus = LoadingStatus.LOADING.obs;

  final Map<String, String> _token = Get.arguments;

  final _burns = <Burn>[].obs;
  PageMeta _pageMeta = PageMeta(0, 0, 0, 0, false, false);
  Map<String, String> _summary = {'xorBurned': '0', 'tokenAllocated': '0'};
  final List<Wallet> _wallets = [];
  final Rx<BurnFilter> _burnFilter = BurnFilter().obs;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  LoadingStatus get pageLoadingStatus => _pageLoadingStatus.value;
  BurnFilter get burnFilter => _burnFilter.value;

  PageMeta get pageMeta => _pageMeta;
  Map<String, String> get summary => _summary;
  List<Burn> get burns => _burns;

  Future _fetchBurns([int page = 1]) async {
    final response = await getBurns.execute(
      _token['tokenFullName']!.toLowerCase(),
      page,
      _burnFilter.value,
    );

    final int divider =
        _token['tokenFullName'] == 'Karma' ? 100000000 : 1000000;

    if (response != null) {
      BurnList burnList = BurnList.fromJson(response['data']);

      if (response['summary'] != null) {
        double amountBurnedTotal = getDefaultDoubleValueNotNullable(
            response['summary']['amountBurnedTotal']);

        _summary = {
          'xorBurned': formatToCurrency(
            amountBurnedTotal,
            showSymbol: false,
          ),
          'tokenAllocated': formatToCurrency(
            amountBurnedTotal / divider,
            showSymbol: false,
          ),
        };
      }

      _pageMeta = PageMeta.fromJson(response['meta']);

      if (burnList.burns.isNotEmpty) {
        List<Burn> burnsFormatted = [];

        for (final burn in burnList.burns) {
          Burn b = burn;
          b.createdAt = formatDateToLocalTime(b.createdAt);
          b.formattedAccountId = _wallets
                  .firstWhereOrNull((w) => w.address == b.accountId)
                  ?.name ??
              formatAddress(b.accountId);
          b.tokenAllocated = b.amountBurned / divider;
          burnsFormatted.add(b);
        }

        _burns.value = burnsFormatted;
      } else {
        _burns.value = [];
      }

      _loadingStatus.value = LoadingStatus.READY;
      _pageLoadingStatus.value = LoadingStatus.READY;
    } else {
      _pageMeta = PageMeta(0, 0, 0, 0, false, false);
      _burns.value = [];
      _loadingStatus.value = LoadingStatus.READY;
      _pageLoadingStatus.value = LoadingStatus.READY;
    }
  }

  void goToFirstPage() {
    if (_pageMeta.hasPreviousPage) {
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _fetchBurns();
    }
  }

  void goToPreviousPage() {
    if (_pageMeta.hasPreviousPage) {
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _fetchBurns(_pageMeta.pageNumber - 1);
    }
  }

  void goToNextPage() {
    if (_pageMeta.hasNextPage) {
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _fetchBurns(_pageMeta.pageNumber + 1);
    }
  }

  void goToLastPage() {
    if (_pageMeta.hasNextPage) {
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _fetchBurns(_pageMeta.pageCount);
    }
  }

  Future _getWalletsFromDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? walletsJSON = prefs.getStringList(kWallets);

    if (walletsJSON != null && walletsJSON.isNotEmpty) {
      for (String wallet in walletsJSON) {
        _wallets.add(Wallet.fromJson(jsonDecode(wallet)));
      }

      _fetchBurns();
    } else {
      _fetchBurns();
    }
  }

  @override
  void onInit() {
    _getWalletsFromDatabase();
    super.onInit();
  }

  Future filterBurns(String dateFrom, String timeFrom, String dateTo,
      String timeTo, String accountId) async {
    DateTime? dateTimeFrom = combineDateAndTime(dateFrom, timeFrom);
    DateTime? dateTimeTo = combineDateAndTime(dateTo, timeTo);

    BurnFilter bf = BurnFilter.arguments(
      dateTimeFrom,
      dateTimeTo,
      accountId,
    );

    if (bf != _burnFilter.value) {
      Get.back();
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _burnFilter.value = bf;
      _fetchBurns();
    }
  }

  Future clearFilters() async {
    if (_burnFilter.value.isSet()) {
      _burnFilter.value = BurnFilter();
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _fetchBurns();
    }
  }
}
