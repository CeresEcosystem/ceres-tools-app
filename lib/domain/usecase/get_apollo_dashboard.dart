import 'package:ceres_tools_app/domain/repository/apollo_repository.dart';

class GetApolloDashboard {
  final ApolloRepository repository;

  GetApolloDashboard({required this.repository});

  Future execute(String address) async {
    return repository.getApolloDashboard(address);
  }
}
