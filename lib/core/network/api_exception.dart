class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() {
    // TODO: implement toString
    return 'ApiException{message: $message, statusCode: $statusCode}';
  }

  factory ApiException.fromDioError(dynamic error) {
    try {
      if (error is Exception) {
        final e = error;
        if (e.toString().contains('DioException')) {
          final response = (e as dynamic).response;

          return ApiException(
            message:
                response?.data?['message'] ??
                response?.statusMessage ??
                "Network error",
            statusCode: response?.statusCode,
          );
        }
      }

      return ApiException(message: 'Unexpected error');
    } catch (e) {
      return ApiException(message: e.toString());
    }
  }
}
