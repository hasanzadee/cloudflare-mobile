import 'package:dio/dio.dart';

class CFEnvelope<T> {
  final bool success;
  final T? result;
  final List<CFError> errors;
  final dynamic resultInfo;
  final dynamic raw;
  CFEnvelope({
    required this.success,
    required this.result,
    required this.errors,
    this.resultInfo,
    this.raw,
  });
}

class CFError {
  final int code;
  final String message;
  CFError(this.code, this.message);
  @override
  String toString() => '[$code] $message';
}

class CFException implements Exception {
  final List<CFError> errors;
  final int httpCode;
  CFException(this.httpCode, this.errors);
  @override
  String toString() =>
      'Cloudflare API error (HTTP $httpCode): ${errors.join('; ')}';
}

class CFApi {
  final Dio _dio;
  CFApi._(this._dio);

  factory CFApi(String token) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.cloudflare.com/client/v4/',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(_RateLimitInterceptor());
    return CFApi._(dio);
  }

  Future<CFEnvelope<T>> _wrap<T>(Future<Response> req) async {
    try {
      final r = await req;
      final data = r.data;
      if (data is Map) {
        return CFEnvelope<T>(
          success: data['success'] == true,
          result: data['result'] as T?,
          errors: ((data['errors'] as List?) ?? const [])
              .map((e) => CFError(
                    (e['code'] ?? 0) as int,
                    (e['message'] ?? '').toString(),
                  ))
              .toList(),
          resultInfo: data['result_info'],
          raw: data,
        );
      }
      throw CFException(r.statusCode ?? 0, [CFError(0, 'Bad response')]);
    } on DioException catch (e) {
      final data = e.response?.data;
      final errs = <CFError>[];
      if (data is Map && data['errors'] is List) {
        for (final x in (data['errors'] as List)) {
          errs.add(CFError(
            (x['code'] ?? 0) as int,
            (x['message'] ?? '').toString(),
          ));
        }
      }
      if (errs.isEmpty) errs.add(CFError(0, e.message ?? 'Network error'));
      throw CFException(e.response?.statusCode ?? 0, errs);
    }
  }

  Future<bool> verifyToken() async {
    final env = await _wrap<Map<String, dynamic>>(_dio.get('user/tokens/verify'));
    return env.success;
  }

  Future<List<dynamic>> listZones({String? name, int page = 1}) async {
    final env = await _wrap<List<dynamic>>(
      _dio.get('zones', queryParameters: {
        'per_page': 50,
        'page': page,
        if (name != null && name.isNotEmpty) 'name': name,
      }),
    );
    if (!env.success) throw CFException(0, env.errors);
    return env.result ?? const [];
  }

  Future<List<dynamic>> listDns(String zoneId, {int page = 1}) async {
    final env = await _wrap<List<dynamic>>(
      _dio.get('zones/$zoneId/dns_records',
          queryParameters: {'per_page': 100, 'page': page}),
    );
    if (!env.success) throw CFException(0, env.errors);
    return env.result ?? const [];
  }

  Future<Map<String, dynamic>> createDns(
      String zoneId, Map<String, dynamic> body) async {
    final env = await _wrap<Map<String, dynamic>>(
      _dio.post('zones/$zoneId/dns_records', data: body),
    );
    if (!env.success) throw CFException(0, env.errors);
    return env.result ?? const {};
  }

  Future<Map<String, dynamic>> updateDns(
      String zoneId, String id, Map<String, dynamic> body) async {
    final env = await _wrap<Map<String, dynamic>>(
      _dio.put('zones/$zoneId/dns_records/$id', data: body),
    );
    if (!env.success) throw CFException(0, env.errors);
    return env.result ?? const {};
  }

  Future<void> deleteDns(String zoneId, String id) async {
    final env = await _wrap<Map<String, dynamic>>(
      _dio.delete('zones/$zoneId/dns_records/$id'),
    );
    if (!env.success) throw CFException(0, env.errors);
  }

  /// Universal request for the Raw API explorer.
  Future<Response> raw({
    required String method,
    required String path,
    Object? body,
    Map<String, dynamic>? query,
  }) async {
    return _dio.request(
      path.startsWith('/') ? path.substring(1) : path,
      data: body,
      queryParameters: query,
      options: Options(
        method: method,
        responseType: ResponseType.json,
        validateStatus: (_) => true,
      ),
    );
  }
}

class _RateLimitInterceptor extends Interceptor {
  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 429) {
      final retry = int.tryParse(response.headers.value('retry-after') ?? '');
      if (retry != null && retry > 0 && retry < 30) {
        await Future.delayed(Duration(seconds: retry));
      }
    }
    handler.next(response);
  }
}
