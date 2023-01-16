import 'package:dio/dio.dart';

const accessToken = 'pk.eyJ1IjoiamVuc2xhbSIsImEiOiJjbGNucWZpOHA2cDRsM3Bsa2NycTBrZTBjIn0.UaJX1JQQrySXKxx75DIXKg';

class TrafficInterceptor extends Interceptor {
  
  @override 
  void onRequest( RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': accessToken,
    });
    super.onRequest(options, handler);
  }
}