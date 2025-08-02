
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/model/attandence_ekskul_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class AttendanceEkskulScreen extends StatefulWidget {
  final String namaEkskul;
  final DateTime selectedDate;

  const AttendanceEkskulScreen({
    super.key,
    required this.namaEkskul,
    required this.selectedDate,
  });

  @override
  State<AttendanceEkskulScreen> createState() => _AttendanceEkskulScreenState();
}

class _AttendanceEkskulScreenState extends State<AttendanceEkskulScreen> {
  final List<Map<String, dynamic>> _daftarSiswaAbsensi = [];
  late final Box<SiswaStudiModel> _siswaBox;
  late final Box<AttandenceEkskulModel> _absensiEkskulBox;

  String generateAbsensiKey(int siswaId, String ekskul, DateTime tanggal) =>
      '${ekskul}_$siswaId${tanggal.toIso8601String().substring(0, 10)}';

  @override
  void initState() {
    super.initState();
    _siswaBox = Hive.box<SiswaStudiModel>('Siswa_studi_model');
    _absensiEkskulBox = Hive.box<AttandenceEkskulModel>(
      'attandence_ekskul_model',
    );
    _loadSiswaByEkskul();
  }

  void _loadSiswaByEkskul() {
    final semuaSiswa = _siswaBox.values
        .where((s) => s.ekskul == widget.namaEkskul)
        .toList();

    setState(() {
      _daftarSiswaAbsensi.clear();
      for (var siswa in semuaSiswa) {
        final key = generateAbsensiKey(
          siswa.key as int,
          widget.namaEkskul,
          widget.selectedDate,
        );
        final absensi = _absensiEkskulBox.get(key);
        _daftarSiswaAbsensi.add({
          'id': siswa.key as int,
          'nama': siswa.nama,
          'status': absensi?.status,
        });
      }
    });
  }

  void _updateStatus(int siswaId, String newStatus) {
    setState(() {
      final siswa = _daftarSiswaAbsensi.firstWhere((s) => s['id'] == siswaId);
      siswa['status'] = newStatus;
    });
  }

  Future _simpanDataAbsensiEkskul() async {
    for (final siswa in _daftarSiswaAbsensi) {
      if (siswa['status'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Status ${siswa['nama']} belum dipilih!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    for (final siswa in _daftarSiswaAbsensi) {
      final key = generateAbsensiKey(
        siswa['id'],
        widget.namaEkskul,
        widget.selectedDate,
      );
      final dataAbsensi = AttandenceEkskulModel(
        idStudet: siswa['id'],
        ekskul: widget.namaEkskul,
        dateEkskul: widget.selectedDate,
        status: siswa['status'],
      );
      await _absensiEkskulBox.put(key, dataAbsensi);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Absensi berhasil disimpan di Hive!"),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {}); // refresh untuk rekap
  }

  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Simpan'),
        content: const Text(
          'Pesan: Apakah data sudah benar? Karena data tidak bisa di-update dan dihapus.',
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cek Kembali'),
          ),
          TextButton(
            onPressed: () async {
              await _simpanDataAbsensiEkskul();
              Navigator.of(context).pop(); // Tutup dialog
              Navigator.of(
                context,
              ).pop(true); // Kembalikan "true" ke Date Screen!
            },
            child: const Text('YA, SIMPAN'),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${widget.selectedDate.day} ${months[widget.selectedDate.month - 1]} ${widget.selectedDate.year}';
  }

  Map<String, int> _getRekapStatus() {
    int hadir = 0, izin = 0, sakit = 0, alpa = 0;
    for (var siswa in _daftarSiswaAbsensi) {
      switch (siswa['status']) {
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
    return {'H': hadir, 'I': izin, 'S': sakit, 'A': alpa};
  }

  Widget _buildRekapCard() {
    final rekap = _getRekapStatus();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.grey[50],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _rekapItem('Hadir', rekap['H'] ?? 0, Colors.green),
            _rekapItem('Izin', rekap['I'] ?? 0, Colors.blue),
            _rekapItem('Sakit', rekap['S'] ?? 0, Colors.orange),
            _rekapItem('Alpa', rekap['A'] ?? 0, Colors.red),
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

  Widget _buildRadioCell(Map<String, dynamic> siswa, String status) {
    return Radio<String>(
      value: status,
      groupValue: siswa['status'],
      onChanged: (String? value) {
        if (value != null) {
          _updateStatus(siswa['id'], value);
        }
      },
      activeColor: status == 'H'
          ? Colors.green
          : status == 'I'
          ? Colors.blue
          : status == 'S'
          ? Colors.orange
          : Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Text(
                  widget.namaEkskul,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getFormattedDate(),
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            color: Colors.grey[200],
            child: const Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    'No',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Nama Siswa',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'H',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'I',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'S',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'A',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Expanded(
            child: _daftarSiswaAbsensi.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada siswa yang terdaftar di ekskul ini.',
                    ),
                  )
                : ListView.separated(
                    itemCount: _daftarSiswaAbsensi.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final siswa = _daftarSiswaAbsensi[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 40, child: Text('${index + 1}')),
                            Expanded(
                              flex: 3,
                              child: Text(
                                siswa['nama'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildRadioCell(siswa, 'H'),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildRadioCell(siswa, 'I'),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildRadioCell(siswa, 'S'),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildRadioCell(siswa, 'A'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: _buildRekapCard(),
          ),
          const Divider(height: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _showSaveConfirmationDialog,
              child: const Text('Save All'),
            ),
          ),
        ],
      ),
    );
  }
}
