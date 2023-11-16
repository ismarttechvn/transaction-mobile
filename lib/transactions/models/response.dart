class Response {
  Response(
      {required this.message, required this.statusCode, required this.data});

  String message;
  int statusCode;
  Map<String, dynamic> data;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
        statusCode: json['statusCode'],
        message: json['message'],
        data: json['data']);
  }
}

class ListResponse {
  ListResponse(
      {required this.returned, required this.total, required this.result});

  int returned;
  int total;
  List<dynamic> result;

  factory ListResponse.fromJson(Map<String, dynamic> json) {
    return ListResponse(
        total: json['total'],
        returned: json['returned'],
        result: json['result']);
  }
}
