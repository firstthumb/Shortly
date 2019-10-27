import 'package:equatable/equatable.dart';

class Shorten extends Equatable {
  final String id;

  Shorten({
    this.id,
  }) : super([id]);

  @override
  String toString() {
    return "Shorten{id: $id}";
  }
}
