
import 'package:attandance_simple/core/cubit/cubit_date_ekskul/date_ekskul_cubit.dart';
import 'package:attandance_simple/core/model/Date_ekskul_model.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/model/attandence_ekskul_model.dart';

import 'package:attandance_simple/view/Date_ekskul_view.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';


class DateEkskulScreen extends StatelessWidget {
  final String namaEkskul;
  const DateEkskulScreen({super.key, required this.namaEkskul});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DateEkskulCubit(
        dateBox: Hive.box<DateEkskulModel>('date_ekskul_model'),
        absensiBox: Hive.box<AttandenceEkskulModel>('attandence_ekskul_model'),
        studentBox: Hive.box<SiswaStudiModel>('Siswa_studi_model'),
        namaEkskul: namaEkskul,
      ),
      child: const DateEkskulView(),
    );
  }
}