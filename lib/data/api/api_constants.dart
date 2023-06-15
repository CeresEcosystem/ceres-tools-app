// ignore_for_file: constant_identifier_names

class ApiConstants {
  static const OLD_BASE_URL = 'https://cerestoken.io/api';
  static const NEW_BASE_URL = 'https://data.cerestoken.io/api';
  static const LOCK_URL = 'https://api.cerestoken.io/api';
  static const DEMETER_URL = 'https://farming-api.cerestoken.io';
  static const HERMES_TVL_URL =
      'https://api.hermes-dao.io/api/supply/supply-data';
  static const DEMETER_TVL_PERMALINK = '/get-supply-data';
  static const DEMETER_FARMS_PERMALINK = '/get-farms';
  static const DEMETER_POOLS_PERMALINK = '/get-pools';
  static const PSWAP_TVL_PERMALINK = '/pairs/tvl';
  static const TOKENS_PERMALINK = '/prices';
  static const PAIRS_PERMALINK = '/pairs';
  static const FARMING_PERMALINK = '/rewards';
  static const TRACKER_PERMALINK = '/tracker/{token}';
  static const BANNERS_PERMALINK = '/banners/mobile';
  static const LOCK_TOKEN_PERMALINK = '/lock/tokens/{token}';
  static const LOCK_PAIR_PERMALINK = '/lock/pairs/{baseAsset}/{token}';
  static const TOKEN_INFOS_PERMALINK = '/get-tokens-infos';
  static const PORTFOLIO_PERMALINK = '/portfolio/{address}';
}
