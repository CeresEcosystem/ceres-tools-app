// ignore_for_file: constant_identifier_names

class ApiConstants {
  static const NEW_BASE_URL = 'https://data.cerestoken.io/api';
  static const LOCK_URL = 'https://api.cerestoken.io/api';
  static const DEMETER_URL = 'https://api.deotoken.com/api/demeter';
  static const HERMES_TVL_URL =
      'https://api.hermes-dao.io/api/supply/supply-data';
  static const APOLLO_URL = 'https://api.apolloprotocol.io/api';
  static const SORA_SUBSCAN_URL = 'https://sora.webapi.subscan.io/api/v2/scan';
  static const DEMETER_TVL_PERMALINK = '/supply-data';
  static const DEMETER_FARMS_PERMALINK = '/farms';
  static const DEMETER_POOLS_PERMALINK = '/stakings';
  static const PSWAP_TVL_PERMALINK = '/pairs/tvl';
  static const TOKENS_PERMALINK = '/prices';
  static const PAIRS_PERMALINK = '/pairs';
  static const PAIRS_LIQUIDITY = '/pairs-liquidity/{baseAsset}/{tokenAsset}';
  static const PAIR_LIQUIDITY_PROVIDERS =
      '/pairs-liquidity/providers/{baseAsset}/{tokenAsset}';
  static const PAIRS_LIQUIDITY_CHART =
      '/pairs-liquidity/history/{baseToken}/{token}';
  static const FARMING_PERMALINK = '/rewards';
  static const TRACKER_PERMALINK = '/tracker/v2/{token}';
  static const TRACKER_SUPPLY_PERMALINK = '/tracker/supply/{token}';
  static const TRACKER_BLOCKS_PERMALINK = '/tracker/{token}/blocks/{type}';
  static const BANNERS_PERMALINK = '/banners/mobile';
  static const LOCK_TOKEN_PERMALINK = '/lock/tokens/{token}';
  static const LOCK_PAIR_PERMALINK = '/lock/pairs/{baseAsset}/{token}';
  static const TOKEN_INFOS_PERMALINK = '/tokens-infos';
  static const PORTFOLIO_PERMALINK = '/portfolio/{address}';
  static const SWAPS_PERMALINK = '/swaps';
  static const SWAPS_FOR_ALL_TOKENS_PERMALINK = '/swaps/all';
  static const INITIAL_FAVS_PERMALINK = '/device/initial-favs';
  static const ADD_TOKEN_TO_FAVORITES_PERMALINK = '/device/add-token';
  static const REMOVE_TOKEN_FROM_FAVORITES_PERMALINK =
      '/device/remove-token/{deviceId}/{token}';
  static const TBC_RESERVES_PERMALINK = '/reserves/TBCD';
  static const TOKEN_HOLDERS_PERMALINK = '/holders';
  static const SORA_SUBSCAN_HOLDERS_PERMALINK = '/accounts';
  static const CURRENCY_PERMALINK = '/currency-rate/{currency}';
  static const BURNING_PERMALINK = '/burns/{token}';
  static const APOLLO_DASHBOARD_PERMALINK = '/users/{address}';
}
