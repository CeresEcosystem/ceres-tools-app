class FavoriteToken {
  int id;

  FavoriteToken({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }
}
