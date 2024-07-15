import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/services/global_service.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/domain/models/token_list.dart';
import 'package:ceres_tools_app/domain/usecase/get_tokens.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:get/get.dart';

class TokensController extends GetxController {
  final GlobalService _globalService = Get.find<GlobalService>();
  final getTokens = Injector.resolve!<GetTokens>();

  final _loadingStatus = LoadingStatus.READY.obs;
  List<Token> _tokens = [];
  final searchQueary = ''.obs;

  final List<String> filters = ['All', 'Favorites', 'Synthetics'];
  final _selectedFilter = 'All'.obs;
  final _selectedPriceFilter = '\$'.obs;

  String get selectedFilter => _selectedFilter.value;
  String get selectedPriceFilter => _selectedPriceFilter.value;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<Token> get allTokens {
    List<Token> favoriteTokens = [];
    List<Token> otherTokens = [];

    for (final t in _tokens) {
      bool isFavorite = checkIfFavorite(t);

      if (isFavorite) {
        t.isFavorite = true;
        favoriteTokens.add(t);
      } else {
        otherTokens.add(t);
      }
    }

    return [...favoriteTokens, ...otherTokens];
  }

  List<Token> get tokens {
    if (_tokens.isNotEmpty) {
      List<Token> filterTokens = _tokens.where((token) {
        token.isFavorite = checkIfFavorite(token);
        if (token.fullName != null && token.assetId != null) {
          return (token.fullName!
                  .toUpperCase()
                  .contains(searchQueary.value.toUpperCase()) ||
              token.assetId!
                  .toUpperCase()
                  .contains(searchQueary.value.toUpperCase()));
        }

        return false;
      }).toList();

      if (_selectedFilter.value == 'Favorites') {
        return filterTokens.where((t) => t.isFavorite).toList();
      }

      if (_selectedFilter.value == 'Synthetics') {
        return filterTokens
            .where((t) => t.assetId!.startsWith(kSyntheticsAddress))
            .toList();
      }

      return filterTokens;
    }

    return [];
  }

  void setFilter(String filter) {
    if (filter != _selectedFilter.value) {
      _selectedFilter.value = filter;
    }
  }

  void setPriceFilter(String priceFilter) {
    if (priceFilter != _selectedPriceFilter.value) {
      _selectedPriceFilter.value = priceFilter;
    }
  }

  @override
  void onInit() async {
    await _globalService.setOneSignal();
    fetchTokens();
    super.onInit();
  }

  bool checkIfFavorite(Token t) {
    return _globalService.checkIfFavorite(t);
  }

  void addTokenToFavorites(Token t) async {
    _globalService.addTokenToFavorites(t);
  }

  void removeTokenFromFavorites(Token t) async {
    _globalService.removeTokenFromFavorites(t);
  }

  void onTyping(String text) {
    searchQueary.value = text;
  }

  void clearSearch() {
    if (searchQueary.value.isNotEmpty) {
      searchQueary.value = '';
    }
  }

  void fetchTokens([bool refresh = false]) async {
    _loadingStatus.value = refresh ? LoadingStatus.IDLE : LoadingStatus.LOADING;

    final response = await getTokens.execute();

    if (response != null) {
      TokenList tokenList = TokenList.fromJson(response);

      if (tokenList.tokens != null && tokenList.tokens!.isNotEmpty) {
        final xorPrice =
            tokenList.tokens!.firstWhere((t) => t.shortName == 'XOR').price ??
                0;

        for (Token t in tokenList.tokens!) {
          t.valueInXor = t.price! / xorPrice;
        }
        _tokens = tokenList.tokens ?? [];
      }

      if (_globalService.favoriteTokens.isNotEmpty) {
        _selectedFilter.value = 'Favorites';
      }

      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }

  void openChartForToken(String? token) {
    if (token != null) {
      Get.toNamed(Routes.CHART, arguments: {'token': token, 'replace': false});
    }
  }
}
