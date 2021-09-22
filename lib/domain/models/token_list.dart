import 'package:ceres_locker_app/domain/models/token.dart';

class TokenList {
  final List<Token>? _tokens;

  const TokenList(this._tokens);

  List<Token>? get tokens => _tokens;

  factory TokenList.fromJson(List<dynamic> json) {
    return TokenList(
      json.map((e) => Token.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
