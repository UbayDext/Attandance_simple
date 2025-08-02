import 'package:attandance_simple/core/cubit/cubit/attendance_ekskul_state.dart';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';




class AttendanceEkskulCubit extends Cubit<AttendanceEkskulState> {
  AttendanceEkskulCubit() : super(AttendanceEkskulInitial());
}
