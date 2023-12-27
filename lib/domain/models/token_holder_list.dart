import 'package:ceres_tools_app/domain/models/token_holder.dart';

class TokenHolderList {
  List<TokenHolder> _tokenHolders = [];

  TokenHolderList(this._tokenHolders);

  List<TokenHolder> get tokenHolders => _tokenHolders;

  factory TokenHolderList.fromJson(List<dynamic> json) {
    return TokenHolderList(
      json.map((e) => TokenHolder.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
