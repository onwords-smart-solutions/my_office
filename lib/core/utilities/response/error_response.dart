class ErrorResponse {
  final String error;
  final String metaInfo;

  ErrorResponse({required this.error, required this.metaInfo});

  @override
  String toString() {
    return 'Error is ("message":$error,"meta":$metaInfo)';
  }
}