import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/address/data/model/address_model.dart';
import 'package:e_commerce/features/address/domain/data_source/address_remote_data_source.dart';

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiService apiService;

  AddressRemoteDataSourceImpl(this.apiService);

  List<AddressModel> _parseList(dynamic response) {
    final data = response is Map && response.containsKey('addresses')
        ? response['addresses']
        : response;
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => AddressModel.fromJson(e))
        .toList();
  }

  @override
  Future<Either<Failure, List<AddressModel>>> getAddresses() async {
    final result = await apiService.get('$kBaseUrl/address');
    return result.fold((failure) => Left(failure), (response) {
      try {
        return Right(_parseList(response));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, AddressModel>> addAddress({
    required String street,
    required String city,
    required String country,
    required String postalCode,
    bool isDefault = false,
  }) async {
    final result = await apiService.post(
      '$kBaseUrl/address',
      data: {
        'street': street,
        'city': city,
        'country': country,
        'postalCode': postalCode,
        'isDefault': isDefault,
      },
    );
    return result.fold((failure) => Left(failure), (response) {
      try {
        final data = response is Map && response.containsKey('address')
            ? response['address'] as Map<String, dynamic>
            : response as Map<String, dynamic>;
        return Right(AddressModel.fromJson(data));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, void>> deleteAddress({
    required String addressId,
  }) async {
    final result = await apiService.delete('$kBaseUrl/address/$addressId');
    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }
}
