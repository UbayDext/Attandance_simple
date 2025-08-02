
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/screen/date_ekskul_screen.dart';
import 'package:attandance_simple/core/storange/Ekskul_data_storange.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class EkskulScreen extends StatefulWidget {
  final String infoStudi;
  const EkskulScreen({Key? key, required this.infoStudi}) : super(key: key);

  @override
  State<EkskulScreen> createState() => _EkskulScreenState();
}

class _EkskulScreenState extends State<EkskulScreen> {
  final Box<EkskulDataStorange> _localStorange = Hive.box<EkskulDataStorange>('Ekskul_data_storange');
  final Box<SiswaStudiModel> _siswaBox = Hive.box<SiswaStudiModel>('Siswa_studi_model');
  final _namaController = TextEditingController();

  Future<void> _addEkskul() async {
    final namaBaru = _namaController.text.trim();
    if (namaBaru.isNotEmpty) {
      final sudahAda = _localStorange.values.any((e) =>
          e.nama.toLowerCase() == namaBaru.toLowerCase() &&
          e.jenjang == widget.infoStudi);

      if (sudahAda) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ekskul sudah ada di jenjang ini!')),
        );
        return;
      }
      final newEkskul = EkskulDataStorange(
        nama: namaBaru,
        jumlah: '',
        jenjang: widget.infoStudi,
      );
      await _localStorange.add(newEkskul);
      _namaController.clear();
      Navigator.of(context).pop();
    }
  }

  Future<void> _updateEkskul(int index) async {
    if (_namaController.text.isNotEmpty) {
      final updatedEkskul = EkskulDataStorange(
        nama: _namaController.text,
        jumlah: '',
        jenjang: widget.infoStudi,
      );
      await _localStorange.putAt(index, updatedEkskul);
      _namaController.clear();
      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteEkskul(int index) async {
    await _localStorange.deleteAt(index);
  }

  void _showFormDialog({int? index}) {
    if (index != null) {
      final ekskul = _localStorange.getAt(index);
      _namaController.text = ekskul?.nama ?? '';
    } else {
      _namaController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(index == null ? 'Tambah Ekskul' : 'Edit Ekskul'),
        content: TextFormField(
          controller: _namaController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Nama Ekskul',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(index == null ? 'Simpan' : 'Update'),
            onPressed: () {
              if (index == null) {
                _addEkskul();
              } else {
                _updateEkskul(index);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    final ekskul = _localStorange.getAt(index);
    if (ekskul == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "${ekskul.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _deleteEkskul(index);
              Navigator.of(context).pop();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      body: Column(
        children: [
          Text(widget.infoStudi),
          const Divider(),
          Expanded(
            child: ValueListenableBuilder<Box<EkskulDataStorange>>(
              valueListenable: _localStorange.listenable(),
              builder: (context, box, _) {
                final filterStudi = box.values
                    .where((studi) => studi.jenjang == widget.infoStudi)
                    .toList();

                // Hilangkan duplikat berdasarkan nama ekskul (case-insensitive)
                final ekskulUnik = <String, EkskulDataStorange>{};
                for (var eks in filterStudi) {
                  ekskulUnik[eks.nama.toLowerCase()] = eks;
                }
                final ekskulList = ekskulUnik.values.toList();

                if (ekskulList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada data ekskul.\nSilakan tambahkan melalui tombol +',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: ekskulList.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final ekskul = ekskulList[index];
                    final jumlahSiswa = _siswaBox.values
                        .where(
                          (siswa) =>
                              siswa.ekskul.toLowerCase() ==
                              ekskul.nama.toLowerCase() &&
                              siswa.jenjang == widget.infoStudi,
                        )
                        .length;
                    final realIndex = box.values.toList().indexOf(ekskul);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 20.0,
                        ),
                        title: Text(
                          ekskul.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '$jumlahSiswa siswa',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showFormDialog(index: realIndex);
                            } else if (value == 'delete') {
                              _showDeleteConfirmationDialog(realIndex);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Hapus'),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DateEkskulScreen(namaEkskul: ekskul.nama),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        backgroundColor: ColorComponent.addColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
