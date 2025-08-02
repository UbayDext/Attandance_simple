import 'package:attandance_simple/core/cubit/cubit_ekskul/ekskul_cubit_cubit.dart';
import 'package:attandance_simple/core/storange/Ekskul_data_storange.dart';
import 'package:attandance_simple/view/Ekskul_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';


class EkskulScreen extends StatelessWidget {
  final String infoStudi;
  const EkskulScreen({Key? key, required this.infoStudi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EkskulCubit(
        box: Hive.box<EkskulDataStorange>('Ekskul_data_storange'),
        jenjang: infoStudi,
      ),
      child: EkskulView(infoStudi: infoStudi),
    );
  }
}
