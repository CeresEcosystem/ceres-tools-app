import 'package:ceres_tools_app/data/datasource/currency_datasource.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CurrencyService extends GetxService {
  final datasource = Injector.resolve!<CurrencyDatasource>();

  final List<Map<String, dynamic>> _currencies = [
    {'currency': 'USD', 'sign': '\$', 'rate': 0},
    {'currency': 'EUR', 'sign': '€', 'rate': 0},
  ];

  List<Map<String, dynamic>> get currencies => _currencies;

  Future<CurrencyService> init() async {
    try {
      final responses = await Future.wait(
        _currencies.map((currency) async {
          return await datasource.getCurrencyRates(currency['currency']);
        }),
      );

      if (responses.isNotEmpty) {
        for (int i = 0; i < _currencies.length; i++) {
          _currencies[i]['rate'] = responses[i]['rate'];
        }
      }
    } on DioException catch (_) {}

    return this;
  }
}
