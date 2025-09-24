import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'pref_service.dart';

class DioService {
  final PrefService _prefService;

  late final Dio _dio;
  Dio get dio => _dio;

  DioService(this._prefService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    // Attach token otomatis
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _prefService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Token expired, tapi ga auto logout
            print("Unauthorized: mungkin token expired");
          }
          handler.next(e); // teruskan ke caller
        },
      ),
    );

    // Pretty logger
    _dio.interceptors.add(
      PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, compact: true),
    );
  }
}
