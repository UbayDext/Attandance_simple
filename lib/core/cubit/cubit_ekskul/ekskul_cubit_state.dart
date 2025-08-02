import 'package:equatable/equatable.dart';
import 'package:attandance_simple/core/storange/Ekskul_data_storange.dart';

abstract class EkskulState extends Equatable {
  const EkskulState();

  @override
  List<Object> get props => [];
}

class EkskulInitial extends EkskulState {}

class EkskulLoading extends EkskulState {}

class EkskulLoaded extends EkskulState {
  final List<EkskulDataStorange> ekskulList;
  const EkskulLoaded(this.ekskulList);

  @override
  List<Object> get props => [ekskulList];
}

class EkskulError extends EkskulState {
  final String message;
  const EkskulError(this.message);

  @override
  List<Object> get props => [message];
}
