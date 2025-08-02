// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class EkskulState extends Equatable {
  const EkskulState({this.ekskul = const []});

  final List<String> ekskul;

  @override
  List<Object> get props => [ekskul];

  EkskulState copyWith({
    List<String>? ekskul,
  }) {
    return EkskulState(
      ekskul: ekskul ?? this.ekskul,
    );
  }
}
