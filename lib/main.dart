import 'package:attandance_simple/core/model/Champion_model.dart';
import 'package:attandance_simple/core/model/Date_ekskul_model.dart';
import 'package:attandance_simple/core/model/Race_ekskul_model.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/model/Solo_round_model.dart';
import 'package:attandance_simple/core/model/Team_round_model.dart';
import 'package:attandance_simple/core/model/Trofi_model.dart';
import 'package:attandance_simple/core/model/attandence_ekskul_model.dart';
import 'package:attandance_simple/core/model/info_studi_model.dart';
import 'package:attandance_simple/core/model/lomba_model.dart';
import 'package:attandance_simple/core/model/round_model.dart';
import 'package:attandance_simple/core/model/study_model.dart';
import 'package:attandance_simple/core/screen/achievement_screen.dart';
import 'package:attandance_simple/core/screen/edit_profile_screen.dart';
import 'package:attandance_simple/core/screen/home_screen.dart';
import 'package:attandance_simple/core/screen/race_screen.dart';
import 'package:attandance_simple/core/screen/studi_ekskul_screen.dart';
import 'package:attandance_simple/core/screen/studi_screen.dart';
import 'package:attandance_simple/core/storange/Ekskul_data_storange.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();


  Hive.registerAdapter(LombaModelAdapter());
  Hive.registerAdapter(DateEkskulModelAdapter());
  Hive.registerAdapter(AttandenceEkskulModelAdapter());
  Hive.registerAdapter(RaceEkskulModelAdapter());
  Hive.registerAdapter(RoundModelAdapter());
  Hive.registerAdapter(InfoStudiModelAdapter());
  Hive.registerAdapter(StudyModelAdapter());
  Hive.registerAdapter(TeamRoundModelAdapter());
  Hive.registerAdapter(SoloRoundModelAdapter());
  Hive.registerAdapter(ChampionModelAdapter());
  Hive.registerAdapter(TrofiModelAdapter());
  Hive.registerAdapter(EkskulDataStorangeAdapter());
  Hive.registerAdapter(SiswaStudiModelAdapter());
  



  await Hive.openBox<LombaModel>('lomba_model');
  await Hive.openBox<DateEkskulModel>('date_ekskul_model');
  await Hive.openBox<AttandenceEkskulModel>('attandence_ekskul_model');
  await Hive.openBox<RaceEkskulModel>('Race_ekskul_model');
  await Hive.openBox<RoundModel>('round_model');
  await Hive.openBox<InfoStudiModel>('info_studi_model');
  await Hive.openBox<StudyModel>('study_model');
  await Hive.openBox<TeamRoundModel>('Team_round_model');
  await Hive.openBox<SoloRoundModel>('Solo_round_model');
  await Hive.openBox<ChampionModel>('Champion_model');
  await Hive.openBox<TrofiModel>('Trofi_model');
  await Hive.openBox<EkskulDataStorange>('Ekskul_data_storange');
  await Hive.openBox<SiswaStudiModel>('Siswa_studi_model');





  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/ekskul': (context) => const StudiEkskulScreen(),
        '/editProfile': (context) => const EditProfileScreen(),
        '/eksport': (context) => const RaceScreen(),
        '/achievement': (context) => const AchievementScreen(),
        '/siswa': (context) => const StudiScreen(),
      },
    );
  }
}
