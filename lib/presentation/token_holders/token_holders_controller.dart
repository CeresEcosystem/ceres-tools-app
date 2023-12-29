import 'dart:convert';

import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/address_format.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/page_meta.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/domain/models/token_holder.dart';
import 'package:ceres_tools_app/domain/models/token_holder_list.dart';
import 'package:ceres_tools_app/domain/models/wallet.dart';
import 'package:ceres_tools_app/domain/usecase/get_token_holders.dart';
import 'package:ceres_tools_app/domain/usecase/get_xor_holders.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenHoldersController extends GetxController {
  final getTokenHolders = Injector.resolve!<GetTokenHolders>();
  final getXorHolders = Injector.resolve!<GetXorHolders>();

  final _loadingStatus = LoadingStatus.LOADING.obs;
  final List<Wallet> _wallets = [];
  PageMeta _pageMeta = PageMeta(0, 0, 0, 0, false, false);
  List<TokenHolder> _tokenHolders = [];

  LoadingStatus get loadingStatus => _loadingStatus.value;
  PageMeta get pageMeta => _pageMeta;
  List<TokenHolder> get tokenHolders => _tokenHolders;

  @override
  void onInit() {
    _getWalletsFromDatabase();
    super.onInit();
  }

  Future _getWalletsFromDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? walletsJSON = prefs.getStringList(kWallets);

    if (walletsJSON != null && walletsJSON.isNotEmpty) {
      for (String wallet in walletsJSON) {
        _wallets.add(Wallet.fromJson(jsonDecode(wallet)));
      }
    }

    _fetchTokenHolders();
  }

  _fetchTokenHolders([int page = 1]) {
    Token token = Get.arguments['token'];

    if (token.shortName == kXOR) {
      _fetchXorHolders(page);
    } else {
      _fetchOtherTokenHolders(token, page);
    }
  }

  Future _fetchOtherTokenHolders(Token token, int page) async {
    final response = await getTokenHolders.execute(token.assetId!, page);

    if (response != null) {
      TokenHolderList tokenHolderList =
          TokenHolderList.fromJson(response['data']);
      _pageMeta = PageMeta.fromJson(response['meta']);

      if (tokenHolderList.tokenHolders.isNotEmpty) {
        List<TokenHolder> tokenHoldersFormatted = [];

        for (final tokenHolder in tokenHolderList.tokenHolders) {
          TokenHolder th = tokenHolder;

          th.accountIdFormatted =
              _wallets.firstWhereOrNull((w) => w.address == th.holder)?.name ??
                  formatAddress(th.holder);

          th.balanceFormatted = formatToCurrency(th.balance);

          tokenHoldersFormatted.add(th);
        }

        _tokenHolders = tokenHoldersFormatted;
      }

      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }

  Future _fetchXorHolders(int page) async {
    final response = await getXorHolders.execute(page);

    if (response != null) {
      final int holderCount = response?['data']?['count'] ?? 0;
      final int pageCount = (holderCount / kPageSize).ceil();

      _pageMeta = PageMeta(
        page,
        kPageSize,
        holderCount,
        pageCount,
        page > 1,
        page < pageCount,
      );

      List<TokenHolder> tokenHoldersFormatted = [];

      for (final tokenHolder in List.from(response?['data']?['list'])) {
        TokenHolder th = TokenHolder(
          tokenHolder['address'],
          getDefaultDoubleValueNotNullable(tokenHolder['balance']),
        );

        th.accountIdFormatted =
            _wallets.firstWhereOrNull((w) => w.address == th.holder)?.name ??
                formatAddress(th.holder);

        th.balanceFormatted = formatToCurrency(th.balance);

        tokenHoldersFormatted.add(th);
      }

      _tokenHolders = tokenHoldersFormatted;
      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }

  void goToFirstPage() {
    if (_pageMeta.hasPreviousPage) {
      _loadingStatus.value = LoadingStatus.LOADING;
      _fetchTokenHolders();
    }
  }

  void goToPreviousPage() {
    if (_pageMeta.hasPreviousPage) {
      _loadingStatus.value = LoadingStatus.LOADING;
      _fetchTokenHolders(_pageMeta.pageNumber - 1);
    }
  }

  void goToNextPage() {
    if (_pageMeta.hasNextPage) {
      _loadingStatus.value = LoadingStatus.LOADING;
      _fetchTokenHolders(_pageMeta.pageNumber + 1);
    }
  }

  void goToLastPage() {
    if (_pageMeta.hasNextPage) {
      _loadingStatus.value = LoadingStatus.LOADING;
      _fetchTokenHolders(_pageMeta.pageCount);
    }
  }
}
