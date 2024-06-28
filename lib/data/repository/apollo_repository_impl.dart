import 'package:ceres_tools_app/data/datasource/apollo_datasource.dart';
import 'package:ceres_tools_app/domain/repository/apollo_repository.dart';

class ApolloRepositoryImpl implements ApolloRepository {
  final ApolloDatasource datasource;

  ApolloRepositoryImpl({required this.datasource});

  @override
  Future getApolloDashboard(String address) async {
    try {
      return await datasource.getApolloDashboard(address);
    } on Exception catch (_) {}
  }
}
