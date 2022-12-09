class FavoriteToken {
  String assetId;

  FavoriteToken({required this.assetId});

  Map<String, dynamic> toMap() {
    return {'assetId': assetId};
  }
}
