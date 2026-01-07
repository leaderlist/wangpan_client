class Response<T> {
  final int code;
  final String message;
  final T data;

  Response({required this.code, required this.message, required this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
    };
  }
}