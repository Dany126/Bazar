import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/address/data/data_source/address_remote_data_source_impl.dart';
import 'package:e_commerce/features/address/data/model/address_model.dart';
import 'package:e_commerce/features/address/data/model/picked_location_model.dart';
import 'package:e_commerce/features/address/data/model/search_result_model.dart';
import 'package:e_commerce/features/address/domain/entity/address_entity.dart';
import 'package:e_commerce/features/address/domain/entity/picked_location_entity.dart';
import 'package:e_commerce/features/address/domain/entity/search_result_entity.dart';
import 'package:e_commerce/features/address/domain/repo/address_repo.dart';
import 'package:geolocator/geolocator.dart';

class AddressRepoImpl implements AddressRepo {
  final AddressRemoteDataSource remoteDataSource;
  final Dio nominatimDio; // separate Dio pointed at nominatim.openstreetmap.org

  AddressRepoImpl({required this.remoteDataSource, required this.nominatimDio});

  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Left(ServerFailure(message: 'Please enable location services'));
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Left(ServerFailure(message: 'Location permission denied'));
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Left(
          ServerFailure(
            message:
                'Location permission permanently denied — enable it from Settings',
          ),
        );
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        return Left(
          ServerFailure(
            message:
                'Could not determine your location. Enable location on the device or emulator and try again.',
          ),
        );
      }

      return Right(position);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Could not determine your current location'),
      );
    }
  }

  @override
  Future<Either<Failure, PickedLocationEntity>> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await nominatimDio.get(
        '/reverse',
        queryParameters: {'lat': latitude, 'lon': longitude},
      );

      final data = response.data as Map<String, dynamic>;
      final features = (data['features'] as List<dynamic>?) ?? [];
      if (features.isEmpty) {
        return Left(
          ServerFailure(
            message: 'Could not resolve an address for this location',
          ),
        );
      }

      final photonLocation = PickedLocationModel.fromPhotonJson(
        features.first as Map<String, dynamic>,
        latitude: latitude,
        longitude: longitude,
      );
      if (photonLocation.city.isNotEmpty &&
          photonLocation.postalCode.isNotEmpty) {
        return Right(photonLocation);
      }

      return Left(
        ServerFailure(
          message:
              'This map provider returned no postal code for the selected location.',
        ),
      );
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _dioFailureMessage(e, 'Could not resolve this location'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Something went wrong while resolving the address',
        ),
      );
    }
  }

  String _dioFailureMessage(DioException error, String fallback) {
    final status = error.response?.statusCode;
    final uri = error.requestOptions.uri;
    final response = error.response?.data;
    return '$fallback (HTTP ${status ?? 'network error'} at $uri)'
        '${response == null ? '' : ': $response'}';
  }

  @override
  Future<Either<Failure, List<SearchResultEntity>>> searchPlaces(
    String query,
  ) async {
    if (query.trim().isEmpty) return const Right([]);
    try {
      final response = await nominatimDio.get(
        '/api/',
        queryParameters: {'q': query, 'limit': 8},
      );

      final data = response.data as Map<String, dynamic>;
      final features = (data['features'] as List<dynamic>?) ?? [];
      final results = features
          .map(
            (e) => SearchResultModel.fromPhotonJson(e as Map<String, dynamic>),
          )
          .toList();
      return Right(results);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _dioFailureMessage(e, 'Could not search for that location'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Could not search for that location'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> editAddress(
    AddressEntity address,
  ) async {
    try {
      final updated = await remoteDataSource.updateAddress(
        AddressModel.fromEntity(address),
      );
      return Right(updated);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _dioFailureMessage(e, 'Could not update the address'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Could not update the address'));
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> addAddress(
    AddressEntity address,
  ) async {
    try {
      final saved = await remoteDataSource.addAddress(
        AddressModel.fromEntity(address),
      );

      return Right(saved);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _dioFailureMessage(e, 'Could not save the address'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Could not save the address'));
    }
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    try {
      final addresses = await remoteDataSource.getAddresses();
      return Right(addresses);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _dioFailureMessage(e, 'Could not load your addresses'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Could not load your addresses'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAddress(String addressId) async {
    try {
      await remoteDataSource.deleteAddress(addressId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _dioFailureMessage(e, 'Could not delete the address'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Could not delete the address'));
    }
  }

  @override
  Future<Either<Failure, Unit>> setDefaultAddress(String addressId) async {
    try {
      await remoteDataSource.setDefaultAddress(addressId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _dioFailureMessage(e, 'Could not set the default address'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Could not set the default address'));
    }
  }
}
