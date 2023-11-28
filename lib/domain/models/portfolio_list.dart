import 'package:ceres_tools_app/domain/models/portfolio_item.dart';

class PortfolioList {
  final List<PortfolioItem>? _portfolioItems;

  const PortfolioList(this._portfolioItems);

  List<PortfolioItem>? get portfolioItems => _portfolioItems;

  factory PortfolioList.fromJson(List<dynamic> json) {
    return PortfolioList(
      json
          .map((e) => PortfolioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
