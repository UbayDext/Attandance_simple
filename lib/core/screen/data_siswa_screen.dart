import 'dart:io';
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/model/Trofi_model.dart';
import 'package:attandance_simple/core/screen/detail_screen.dart';
import 'package:attandance_simple/core/storange/Ekskul_data_storange.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';




class DataSiswaScreen extends StatefulWidget {
  final String nameClass;
  final String jenjang;
  const DataSiswaScreen({
    Key? key,
    required this.nameClass,
    required this.jenjang,
  }) : super(key: key);

  @override
  State<DataSiswaScreen> createState() => _DataSiswaScreenState();
}

class _DataSiswaScreenState extends State<DataSiswaScreen> {
  final Box<SiswaStudiModel> _siswaBox = Hive.box<SiswaStudiModel>(
    'Siswa_studi_model',
  );
  final Box<EkskulDataStorange> _ekskulBox = Hive.box<EkskulDataStorange>(
    'Ekskul_data_storange',
  );
  final Box<TrofiModel> _trofiBox = Hive.box<TrofiModel>('Trofi_model');
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _bulkInputController = TextEditingController();
  String? _selectedEkskul;

  @override
  void dispose() {
    _namaController.dispose();
    _kelasController.dispose();
    _bulkInputController.dispose();
    super.dispose();
  }

  /// --- FUNGSI IMPORT DARI EXCEL & CSV ---
  Future<void> _importFromExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
    );
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final ext = filePath.split('.').last.toLowerCase();

      int importCount = 0;

      if (ext == 'xlsx') {
        final fileBytes = File(filePath).readAsBytesSync();
        final excel = Excel.decodeBytes(fileBytes);

        for (final table in excel.tables.keys) {
          final sheet = excel.tables[table];
          if (sheet == null) continue;

          for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
            final row = sheet.rows[rowIndex];
            if (row.length < 3) continue;
            final nama = row[0]?.value?.toString().trim() ?? '';
            final kelas = row[1]?.value?.toString().trim() ?? '';
            final ekskul = row[2]?.value?.toString().trim() ?? '';

            // Import semua baris (tidak filter kelas)
            if (nama.isNotEmpty && kelas.isNotEmpty && ekskul.isNotEmpty) {
              final siswaBaru = SiswaStudiModel(
                nama: nama,
                kelas: kelas,
                ekskul: ekskul,
                jenjang: widget.jenjang,
              );
              await _siswaBox.add(siswaBaru);
              importCount++;
            }
          }
        }
      } else if (ext == 'csv') {
        final lines = File(filePath).readAsLinesSync();
        for (int i = 1; i < lines.length; i++) {
          // Mulai dari 1 agar header dilewati
          final parts = lines[i].split(',');
          if (parts.length < 3) continue;
          final nama = parts[0].trim();
          final kelas = parts[1].trim();
          final ekskul = parts[2].trim();
          if (nama.isNotEmpty && kelas.isNotEmpty && ekskul.isNotEmpty) {
            final siswaBaru = SiswaStudiModel(
              nama: nama,
              kelas: kelas,
              ekskul: ekskul,
              jenjang: widget.jenjang,
            );
            await _siswaBox.add(siswaBaru);
            importCount++;
          }
        }
      }

      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import $importCount data berhasil')),
      );
    }
  }

  Future<void> _tambahSiswa() async {
    if (_namaController.text.isNotEmpty &&
        _kelasController.text.isNotEmpty &&
        _selectedEkskul != null) {
      final siswaBaru = SiswaStudiModel(
        nama: _namaController.text,
        kelas: _kelasController.text,
        ekskul: _selectedEkskul!,
        jenjang: widget.jenjang,
      );
      await _siswaBox.add(siswaBaru);
      _namaController.clear();
      _kelasController.clear();
      _selectedEkskul = null;
      Navigator.of(context).pop();
    }
  }

  Future<void> _tambahSiswaBulk() async {
    final text = _bulkInputController.text;
    if (text.trim().isEmpty) return;

    final lines = text.trim().split('\n');
    for (var line in lines) {
      final parts = line.split(RegExp(r'[,;\t]')).map((e) => e.trim()).toList();
      if (parts.length < 3) continue;
      final siswaBaru = SiswaStudiModel(
        nama: parts[0],
        kelas: parts[1],
        ekskul: parts[2],
        jenjang: widget.jenjang,
      );
      await _siswaBox.add(siswaBaru);
    }
    _bulkInputController.clear();
    Navigator.of(context).pop();
  }

  Future<void> _updateSiswaByKey(int key) async {
    if (_namaController.text.isNotEmpty &&
        _kelasController.text.isNotEmpty &&
        _selectedEkskul != null) {
      final siswaUpdate = SiswaStudiModel(
        nama: _namaController.text,
        kelas: _kelasController.text,
        ekskul: _selectedEkskul!,
        jenjang: widget.jenjang,
      );
      await _siswaBox.put(key, siswaUpdate);
      _namaController.clear();
      _kelasController.clear();
      _selectedEkskul = null;
      Navigator.of(context).pop();
    }
  }

  void _showFormDialog({int? key, SiswaStudiModel? siswa}) {
    if (siswa != null) {
      _namaController.text = siswa.nama;
      _kelasController.text = siswa.kelas;
      _selectedEkskul = siswa.ekskul;
      _bulkInputController.clear();
    } else {
      _namaController.clear();
      _kelasController.clear();
      _selectedEkskul = null;
      _bulkInputController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(key == null ? 'Tambah Data Siswa' : 'Edit Data Siswa'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (key != null) ...[
                    TextFormField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Siswa',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _kelasController,
                      decoration: InputDecoration(
                        labelText: 'Kelas',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ValueListenableBuilder<Box<EkskulDataStorange>>(
                      valueListenable: _ekskulBox.listenable(),
                      builder: (context, box, _) {
                        final List<String> opsiEkskul = box.values
                            .map((e) => e.nama)
                            .toSet()
                            .toList();

                        if (_selectedEkskul != null &&
                            !opsiEkskul.contains(_selectedEkskul)) {
                          opsiEkskul.insert(0, _selectedEkskul!);
                        }

                        return DropdownButtonFormField<String>(
                          value: (opsiEkskul.contains(_selectedEkskul))
                              ? _selectedEkskul
                              : null,
                          hint: const Text('Pilih Ekskul'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: opsiEkskul.map((String ekskul) {
                            return DropdownMenuItem<String>(
                              value: ekskul,
                              child: Text(ekskul),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedEkskul = newValue;
                            });
                          },
                        );
                      },
                    ),
                  ],
                  if (key == null) ...[
                    TextFormField(
                      controller: _bulkInputController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText:
                            'Paste Banyak Siswa\nFormat: Nama,Kelas,Ekskul',
                        hintText: 'Contoh:\nAhmad,2A,Futsal\nBudi,5E,Pramuka',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jika ingin tambah banyak data sekaligus,\npaste data siswa ke kolom ini.\nKolom atas dikosongkan saja.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(key == null ? 'Simpan' : 'Update'),
            onPressed: () {
              if (key == null) {
                if (_bulkInputController.text.isNotEmpty) {
                  _tambahSiswaBulk();
                } else {
                  _tambahSiswa();
                }
              } else {
                _updateSiswaByKey(key);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(int key, SiswaStudiModel siswa) {
    showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus data siswa "${siswa.nama}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _siswaBox.delete(key);
              Navigator.of(context).pop();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      body: Column(
        children: [
          Text(
            widget.jenjang,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(widget.nameClass, style: const TextStyle(fontSize: 15)),
          const Divider(),
          Expanded(
            child: ValueListenableBuilder<Box<SiswaStudiModel>>(
              valueListenable: _siswaBox.listenable(),
              builder: (context, box, _) {
                final filteredEntries = box
                    .toMap()
                    .entries
                    .where((e) => e.value.jenjang == widget.jenjang)
                    .toList();

                if (filteredEntries.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada data siswa yang terdaftar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredEntries.length,
                  itemBuilder: (context, index) {
                    final entry = filteredEntries[index];
                    final key = entry.key;
                    final siswa = entry.value;
                    final jumlahTrofi = _trofiBox.values
                        .where(
                          (e) =>
                              e.ekskul == siswa.ekskul &&
                              e.nameSiswa == siswa.nama &&
                              e.kelas == siswa.kelas,
                        )
                        .length;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 20.0,
                        ),
                        title: Text(
                          siswa.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kelas: ${siswa.kelas}'),
                            Text('Ekskul: ${siswa.ekskul}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailSiswaScreen(
                                      siswa: siswa,
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Sertifikat: $jumlahTrofi',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showFormDialog(key: key, siswa: siswa);
                                } else if (value == 'delete') {
                                  _showDeleteConfirmDialog(key, siswa);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'import',
            onPressed: _importFromExcel,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.upload_file, color: Colors.white),
            tooltip: 'Import dari Excel/CSV',
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _showFormDialog,
            backgroundColor: ColorComponent.addColor,
            child: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Tambah Manual',
          ),
        ],
      ),
    );
  }
}
