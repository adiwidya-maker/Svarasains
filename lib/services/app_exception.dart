class AppException implements Exception {
  final String message;
  const AppException(this.message);
  @override
  String toString() => message;
}

String errorText(Object e) =>
    e is AppException ? e.message : 'Terjadi kesalahan: $e';
