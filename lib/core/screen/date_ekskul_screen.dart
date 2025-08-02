import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/model/Date_ekskul_model.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/model/attandence_ekskul_model.dart';
import 'package:attandance_simple/core/screen/attendance_ekskul_screen.dart';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class DateEkskulScreen extends StatefulWidget {
  final String namaEkskul;
  
  const DateEkskulScreen({super.key, required this.namaEkskul});

  @override
  State<DateEkskulScreen> createState() => _DateEkskulScreenState();
}

class _DateEkskulScreenState extends State<DateEkskulScreen> {
  late final Box<DateEkskulModel> _dateBox;
  late final Box<AttandenceEkskulModel> _absensiBox;
  late final Box<SiswaStudiModel> _studentBox;
  DateTime _selectedDate = DateTime.now();

  Map<String, int> _rekapStatus = {'H': 0, 'I': 0, 'S': 0, 'A': 0};

  Map<String, int> getRekapStatusBySiswa(
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

  @override
  void initState() {
    super.initState();
    _dateBox = Hive.box<DateEkskulModel>('date_ekskul_model');
    _absensiBox = Hive.box<AttandenceEkskulModel>('attandence_ekskul_model');
    _studentBox = Hive.box<SiswaStudiModel>('Siswa_studi_model');

    _refreshRekap();
  }

  void _refreshRekap() {
    final semuaSiswa = _studentBox.values
        .where((s) => s.ekskul == widget.namaEkskul)
        .toList();

    final absenHariIni = _absensiBox.values.where(
      (absen) =>
          absen.ekskul == widget.namaEkskul &&
          absen.dateEkskul.year == _selectedDate.year &&
          absen.dateEkskul.month == _selectedDate.month &&
          absen.dateEkskul.day == _selectedDate.day,
    );

    setState(() {
      _rekapStatus = getRekapStatusBySiswa(semuaSiswa, absenHariIni);
    });
  }

  Future<void> _saveDateAndNavigate() async {
  final newDateEkskul = DateEkskulModel(
    date: _selectedDate,
    ekskul: widget.namaEkskul,
  );
  String uniqueKey =
      '${widget.namaEkskul}_${_selectedDate.toIso8601String().substring(0, 10)}';
  await _dateBox.put(uniqueKey, newDateEkskul);

  if (mounted) {
    // Ambil hasil dari halaman absensi
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceEkskulScreen(
          namaEkskul: widget.namaEkskul,
          selectedDate: _selectedDate,
        ),
      ),
    );

    // Jika result true, maka refresh rekap
    if (result == true) {
      _refreshRekap();
    }
  }
}


  Widget _buildRekapCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.grey[50],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _rekapItem('Hadir', _rekapStatus['H'] ?? 0, Colors.green),
            _rekapItem('Izin', _rekapStatus['I'] ?? 0, Colors.blue),
            _rekapItem('Sakit', _rekapStatus['S'] ?? 0, Colors.orange),
            _rekapItem('Alpa', _rekapStatus['A'] ?? 0, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _rekapItem(String label, int value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Jadwal Kehadiran untuk:',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              widget.namaEkskul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime(2025),
                lastDate: DateTime(2030),
                onDateChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                  _refreshRekap(); // update rekap ketika tanggal diganti
                },
              ),
            ),
            const SizedBox(height: 12),
            _buildRekapCard(),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _saveDateAndNavigate,
              icon: const Icon(Icons.checklist),
              label: const Text('Lihat Kehadiran Ekskul'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
