import 'package:dio/dio.dart';

import 'package:e_commerce/core/services/hive_server.dart';
import 'package:e_commerce/features/address/data/model/address_model.dart';

class AddressRemoteDataSource {
  final Dio dio; // base URL = your Node.js API

  Future<dynamic> get userID =>
      HiveService.openBox('authBox').then((value) => value.get('id'));

  AddressRemoteDataSource({required this.dio});
  Future<AddressModel> addAddress(AddressModel address) async {
    final response = await dio.post('/addresses', data: address.toJson());
    return AddressModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<AddressModel>> getAddresses() async {
    final response = await dio.get('/address/${await userID}');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteAddress(String id) async {
    await dio.delete('/addresse/$id');
  }

  Future<AddressModel> updateAddress(AddressModel address) async {
    final response = await dio.put(
      '/addresses/${address.id}',
      data: address.toJson(),
    );
    return AddressModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> setDefaultAddress(String id) async {
    await dio.patch('/addresses/$id/default');
  }
}
