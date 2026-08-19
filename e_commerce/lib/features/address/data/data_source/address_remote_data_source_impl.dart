import 'package:dio/dio.dart';
import 'package:e_commerce/core/helper_function/get_user_id.dart';

import 'package:e_commerce/features/address/data/model/address_model.dart';

class AddressRemoteDataSource {
  final Dio dio; // base URL = your Node.js API

  AddressRemoteDataSource({required this.dio});
  Future<AddressModel> addAddress(AddressModel address) async {
    final response = await dio.post('/address', data: address.toJson());
    final data = response.data as Map<String, dynamic>;

    return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
  }

  Future<List<AddressModel>> getAddresses() async {
    final response = await dio.get(
      '/address',
      queryParameters: {'user_id': cachedUserId},
    );
    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['addresses'] as List<dynamic>? ?? [];
    return data
        .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteAddress(String id) async {
    await dio.delete(
      '/address/$id',
      queryParameters: {'user_id': cachedUserId},
    );
  }

  Future<AddressModel> updateAddress(AddressModel address) async {
    final response = await dio.put(
      '/address/${address.id}',
      data: address.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    return AddressModel.fromJson(data['address'] as Map<String, dynamic>);
  }

  Future<void> setDefaultAddress(String id) async {
    await dio.patch('/address/$id', data: {'is_default': true});
  }
}
