import 'package:ceres_tools_app/core/utils/default_value.dart';

class LendingInfo {
  final String poolAssetId;
  final String poolAssetSymbol;
  final double apr;
  final double amount;
  double? amountPrice;
  final double rewards;
  double? rewardPrice;

  LendingInfo({
    required this.poolAssetId,
    required this.poolAssetSymbol,
    required this.apr,
    required this.amount,
    required this.rewards,
  });

  factory LendingInfo.fromJson(Map<String, dynamic> json) => LendingInfo(
        poolAssetId: json['poolAssetId'],
        poolAssetSymbol: json['poolAssetSymbol'],
        apr: getDefaultDoubleValueNotNullable(json['apr']),
        amount: getDefaultDoubleValueNotNullable(json['amount']),
        rewards: getDefaultDoubleValueNotNullable(json['rewards']),
      );
}

class Collateral {
  final String collateralAssetId;
  final String collateralAssetSymbol;
  final double collateralAmount;
  double? collateralAmountPrice;
  final double borrowedAmount;
  double? borrowedAmountPrice;
  final double interest;
  double? interestPrice;
  final double rewards;
  double? rewardPrice;

  Collateral({
    required this.collateralAssetId,
    required this.collateralAssetSymbol,
    required this.collateralAmount,
    required this.borrowedAmount,
    required this.interest,
    required this.rewards,
  });

  factory Collateral.fromJson(Map<String, dynamic> json) => Collateral(
        collateralAssetId: json['collateralAssetId'],
        collateralAssetSymbol: json['collateralAssetSymbol'],
        collateralAmount:
            getDefaultDoubleValueNotNullable(json['collateralAmount']),
        borrowedAmount:
            getDefaultDoubleValueNotNullable(json['borrowedAmount']),
        interest: getDefaultDoubleValueNotNullable(json['interest']),
        rewards: getDefaultDoubleValueNotNullable(json['rewards']),
      );
}

class BorrowingInfo {
  final String poolAssetId;
  final String poolAssetSymbol;
  final double amount;
  double? amountPrice;
  final double interest;
  double? interestPrice;
  final double rewards;
  double? rewardPrice;
  List<Collateral> collaterals;

  BorrowingInfo({
    required this.poolAssetId,
    required this.poolAssetSymbol,
    required this.amount,
    required this.interest,
    required this.rewards,
    required this.collaterals,
  });

  factory BorrowingInfo.fromJson(Map<String, dynamic> json) => BorrowingInfo(
        poolAssetId: json['poolAssetId'],
        poolAssetSymbol: json['poolAssetSymbol'],
        amount: getDefaultDoubleValueNotNullable(json['amount']),
        interest: getDefaultDoubleValueNotNullable(json['interest']),
        rewards: getDefaultDoubleValueNotNullable(json['rewards']),
        collaterals: List<Collateral>.from(
            json['collaterals'].map((x) => Collateral.fromJson(x))),
      );
}

class Stats {
  final double tvl;
  final double totalLent;
  final double totalBorrowed;
  final double totalRewards;

  Stats({
    required this.tvl,
    required this.totalLent,
    required this.totalBorrowed,
    required this.totalRewards,
  });

  factory Stats.empty() => Stats(
        tvl: 0,
        totalLent: 0,
        totalBorrowed: 0,
        totalRewards: 0,
      );

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        tvl: getDefaultDoubleValueNotNullable(json['tvl']),
        totalLent: getDefaultDoubleValueNotNullable(json['totalLent']),
        totalBorrowed: getDefaultDoubleValueNotNullable(json['totalBorrowed']),
        totalRewards: getDefaultDoubleValueNotNullable(json['totalRewards']),
      );
}

class ApolloDashboard {
  final List<LendingInfo> lendingInfo;
  final List<BorrowingInfo> borrowingInfo;
  final Stats stats;

  factory ApolloDashboard.empty() => ApolloDashboard(
        lendingInfo: [],
        borrowingInfo: [],
        stats: Stats.empty(),
      );

  ApolloDashboard({
    required this.lendingInfo,
    required this.borrowingInfo,
    required this.stats,
  });

  factory ApolloDashboard.fromJson(Map<String, dynamic> json) =>
      ApolloDashboard(
        lendingInfo: List<LendingInfo>.from(
            json['lendingInfo'].map((x) => LendingInfo.fromJson(x))),
        borrowingInfo: List<BorrowingInfo>.from(
            json['borrowingInfo'].map((x) => BorrowingInfo.fromJson(x))),
        stats: Stats.fromJson(json['userData']),
      );
}
