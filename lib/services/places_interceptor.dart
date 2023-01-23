import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessToken = 'pk.eyJ1IjoiamVuc2xhbSIsImEiOiJjbGNucWZpOHA2cDRsM3Bsa2NycTBrZTBjIn0.UaJX1JQQrySXKxx75DIXKg';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters.addAll({
      'access_token': accessToken,
      'language': 'es',
      'limit': 7
    });

    super.onRequest(options, handler);
  }
}