import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse extends Equatable {
  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'error_code')
  final int errorCode;

  ErrorResponse({
    @required this.errorCode,
    @required this.message,
  }) : super([errorCode, message]);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() {
    return 'ErrorResponse{message: $message, errorCode: $errorCode}';
  }
}
