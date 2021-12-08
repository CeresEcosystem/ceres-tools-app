class Banners {
  static final Banners instance = Banners._internal();
  List _banners = [];

  factory Banners() {
    return instance;
  }

  Banners._internal();

  List get banners => _banners;

  void setBanners(List b) {
    _banners = b;
  }
}
