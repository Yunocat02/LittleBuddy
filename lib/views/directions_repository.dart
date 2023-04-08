import 'package:LittleBuddy/views/direction_model.dart';
import 'package:dio/dio.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'env.dart';

class DirectionsRepositoey{
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepositoey({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async{
    final Response =await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleAPIKey,
      }
    );
    
    // Check is Response is ได้
    if(Response.statusCode == 200){
      return Directions.fromMap(Response.data);
    }
    return null;
  }
}