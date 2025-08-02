import 'package:attandance_simple/core/model/Date_ekskul_model.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/model/attandence_ekskul_model.dart';
import 'package:attandance_simple/core/screen/attendance_ekskul_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'date_ekskul_state.dart';

class DateEkskulCubit extends Cubit<DateEkskulState> {
  final Box<DateEkskulModel> dateBox;
  final Box<AttandenceEkskulModel> absensiBox;
  final Box<SiswaStudiModel> studentBox;
  final String namaEkskul;

  DateEkskulCubit({
    required this.dateBox,
    required this.absensiBox,
    required this.studentBox,
    required this.namaEkskul,
  }) : super(DateEkskulState.initial()) {
    refreshRekap();
  }

  void setSelectedDate(DateTime newDate) {
    emit(state.copyWith(selectedDate: newDate));
    refreshRekap();
  }

  void refreshRekap() {
    try {
      final semuaSiswa = studentBox.values
          .where((s) => s.ekskul == namaEkskul)
          .toList();

      final absenHariIni = absensiBox.values.where(
        (absen) =>
            absen.ekskul == namaEkskul &&
            absen.dateEkskul.year == state.selectedDate.year &&
            absen.dateEkskul.month == state.selectedDate.month &&
            absen.dateEkskul.day == state.selectedDate.day,
      );

      final rekap = _getRekapStatusBySiswa(semuaSiswa, absenHariIni);
      emit(state.copyWith(rekapStatus: rekap, isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Map<String, int> _getRekapStatusBySiswa(
    List<SiswaStudiModel> siswaAktif,
    Iterable<AttandenceEkskulModel> absensiHariIni,
  ) {
    int hadir = 0, izin = 0, sakit = 0, alpa = 0;
    for (final siswa in siswaAktif) {
      final absen = absensiHariIni.firstWhereOrNull(
        (a) => a.idStudet == siswa.key,
      );
      if (absen != null) {
        switch (absen.status) {
          case 'H':
            hadir++;
            break;
          case 'I':
            izin++;
            break;
          case 'S':
            sakit++;
            break;
          case 'A':
            alpa++;
            break;
        }
      }
    }
    return {'H': hadir, 'I': izin, 'S': sakit, 'A': alpa};
  }

  Future<void> saveDateAndNavigate(BuildContext context) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final newDateEkskul = DateEkskulModel(
        date: state.selectedDate,
        ekskul: namaEkskul,
      );
      String uniqueKey =
          '${namaEkskul}_${state.selectedDate.toIso8601String().substring(0, 10)}';
      await dateBox.put(uniqueKey, newDateEkskul);

      // Navigasi ke AttendanceEkskulScreen
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AttendanceEkskulScreen(
            namaEkskul: namaEkskul,
            selectedDate: state.selectedDate,
          ),
        ),
      );

      if (result == true) {
        refreshRekap();
      }
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
