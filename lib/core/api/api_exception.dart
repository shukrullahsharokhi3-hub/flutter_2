class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.responseData,
  });

  final String message;
  final int? statusCode;
  final Object? responseData;

  @override
  String toString() {
    final status = statusCode == null ? '' : ' (status $statusCode)';
    return 'ApiException$status: $message';
  }
}
