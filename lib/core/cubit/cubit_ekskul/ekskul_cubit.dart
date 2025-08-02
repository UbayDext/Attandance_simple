import 'package:attandance_simple/core/cubit/cubit_ekskul/ekskul_state.dart';
import 'package:bloc/bloc.dart';



class EkskulCubit extends Cubit<EkskulState> {
  EkskulCubit() : super(EkskulState());

  void addEkskul(String ekskul) {
    final newEkskul = List<String>.from(state.ekskul)..add(ekskul);
    emit(state.copyWith(ekskul: newEkskul));
  }

  void removeEkskul(int index) {
    emit(state.copyWith(ekskul: List.from(state.ekskul)..removeAt(index)));
  }

  void updateEkskul(int index, String upEkskul) {
    final newList = List<String>.from(state.ekskul);
    newList[index] = upEkskul;
    emit(state.copyWith(ekskul: newList));
  }
}
