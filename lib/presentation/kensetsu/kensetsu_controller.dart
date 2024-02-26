import 'dart:convert';

import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/address_format.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/kensetsu_burn.dart';
import 'package:ceres_tools_app/domain/models/kensetsu_burn_list.dart';
import 'package:ceres_tools_app/domain/models/kensetsu_filter.dart';
import 'package:ceres_tools_app/domain/models/page_meta.dart';
import 'package:ceres_tools_app/domain/models/wallet.dart';
import 'package:ceres_tools_app/domain/usecase/get_kensetsu_burns.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KensetsuController extends GetxController {
  final getKensetsuBurns = Injector.resolve!<GetKensetsuBurns>();

  final _loadingStatus = LoadingStatus.LOADING.obs;
  final _pageLoadingStatus = LoadingStatus.LOADING.obs;

  final _kensetsuBurns = <KensetsuBurn>[].obs;
  PageMeta _pageMeta = PageMeta(0, 0, 0, 0, false, false);
  Map<String, String> _summary = {'xorBurned': '0', 'kenAllocated': '0'};
  final List<Wallet> _wallets = [];
  final Rx<KensetsuFilter> _kensetsuFilter = KensetsuFilter().obs;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  LoadingStatus get pageLoadingStatus => _pageLoadingStatus.value;
  KensetsuFilter get kensetsuFilter => _kensetsuFilter.value;

  PageMeta get pageMeta => _pageMeta;
  Map<String, String> get summary => _summary;
  List<KensetsuBurn> get kensetsuBurns => _kensetsuBurns;

  Future _fetchKensetsuBurns([int page = 1]) async {
    final response = await getKensetsuBurns.execute(
      page,
      _kensetsuFilter.value,
    );

    if (response != null) {
      KensetsuBurnList kensetsuBurnList =
          KensetsuBurnList.fromJson(response['data']);

      if (response['summary'] != null) {
        double amountBurnedTotal = getDefaultDoubleValueNotNullable(
            response['summary']['amountBurnedTotal']);

        _summary = {
          'xorBurned': formatToCurrency(
            amountBurnedTotal,
            showSymbol: false,
          ),
          'kenAllocated': formatToCurrency(
            amountBurnedTotal / 1000000,
            showSymbol: false,
          ),
        };
      }

      _pageMeta = PageMeta.fromJson(response['meta']);

      if (kensetsuBurnList.kensetsuBurns.isNotEmpty) {
        List<KensetsuBurn> kensetsuBurnsFormatted = [];

        for (final burn in kensetsuBurnList.kensetsuBurns) {
          KensetsuBurn kb = burn;
          kb.createdAt = formatDateToLocalTime(kb.createdAt);
          kb.formattedAccountId = _wallets
                  .firstWhereOrNull((w) => w.address == kb.accountId)
                  ?.name ??
              formatAddress(kb.accountId);
          kb.kenAllocated = kb.amountBurned / 1000000;
          kensetsuBurnsFormatted.add(kb);
        }

        _kensetsuBurns.value = kensetsuBurnsFormatted;
      } else {
        _kensetsuBurns.value = [];
      }

      _loadingStatus.value = LoadingStatus.READY;
      _pageLoadingStatus.value = LoadingStatus.READY;
    } else {
      _pageMeta = PageMeta(0, 0, 0, 0, false, false);
      _kensetsuBurns.value = [];
      _loadingStatus.value = LoadingStatus.READY;
      _pageLoadingStatus.value = LoadingStatus.READY;
    }
  }

  void goToFirstPage() {
    if (_pageMeta.hasPreviousPage) {
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _fetchKensetsuBurns();
    }
  }

  void goToPreviousPage() {
    if (_pageMeta.hasPreviousPage) {
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _fetchKensetsuBurns(_pageMeta.pageNumber - 1);
    }
  }

  void goToNextPage() {
    if (_pageMeta.hasNextPage) {
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _fetchKensetsuBurns(_pageMeta.pageNumber + 1);
    }
  }

  void goToLastPage() {
    if (_pageMeta.hasNextPage) {
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _fetchKensetsuBurns(_pageMeta.pageCount);
    }
  }

  Future _getWalletsFromDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? walletsJSON = prefs.getStringList(kWallets);

    if (walletsJSON != null && walletsJSON.isNotEmpty) {
      for (String wallet in walletsJSON) {
        _wallets.add(Wallet.fromJson(jsonDecode(wallet)));
      }

      _fetchKensetsuBurns();
    } else {
      _fetchKensetsuBurns();
    }
  }

  @override
  void onInit() {
    _getWalletsFromDatabase();
    super.onInit();
  }

  Future filterKensetsuBurns(String dateFrom, String timeFrom, String dateTo,
      String timeTo, String accountId) async {
    DateTime? dateTimeFrom = combineDateAndTime(dateFrom, timeFrom);
    DateTime? dateTimeTo = combineDateAndTime(dateTo, timeTo);

    KensetsuFilter kf = KensetsuFilter.arguments(
      dateTimeFrom,
      dateTimeTo,
      accountId,
    );

    if (kf != _kensetsuFilter.value) {
      Get.back();
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _kensetsuFilter.value = kf;
      _fetchKensetsuBurns();
    }
  }

  Future clearFilters() async {
    if (_kensetsuFilter.value.isSet()) {
      _kensetsuFilter.value = KensetsuFilter();
      _pageLoadingStatus.value = LoadingStatus.LOADING;
      _fetchKensetsuBurns();
    }
  }
}
