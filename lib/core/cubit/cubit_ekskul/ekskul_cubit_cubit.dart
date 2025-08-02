import 'package:attandance_simple/core/cubit/cubit_ekskul/ekskul_cubit_state.dart';
import 'package:attandance_simple/core/storange/Ekskul_data_storange.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
class EkskulCubit extends Cubit<EkskulState> {
  final Box<EkskulDataStorange> box;
  final String jenjang;

  EkskulCubit({required this.box, required this.jenjang}) : super(EkskulInitial()) {
    loadEkskul();
  }

  void loadEkskul() {
    emit(EkskulLoading());
    try {
      final list = box.values
          .where((e) => e.jenjang == jenjang)
          .toList();
      // Unik by nama (case-insensitive)
      final unik = <String, EkskulDataStorange>{};
      for (var eks in list) {
        unik[eks.nama.toLowerCase()] = eks;
      }
      emit(EkskulLoaded(unik.values.toList()));
    } catch (e) {
      emit(EkskulError(e.toString()));
    }
  }

  Future<void> addEkskul(String nama) async {
    final sudahAda = box.values.any((e) => e.nama.toLowerCase() == nama.toLowerCase() && e.jenjang == jenjang);
    if (sudahAda) {
      emit(const EkskulError('Ekskul sudah ada di jenjang ini!'));
      loadEkskul();
      return;
    }
    await box.add(EkskulDataStorange(nama: nama, jumlah: '', jenjang: jenjang));
    loadEkskul();
  }

  Future<void> updateEkskul(int index, String nama) async {
    await box.putAt(index, EkskulDataStorange(nama: nama, jumlah: '', jenjang: jenjang));
    loadEkskul();
  }

  Future<void> deleteEkskul(int index) async {
    await box.deleteAt(index);
    loadEkskul();
  }
}
