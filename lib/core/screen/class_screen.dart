
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/model/attandence_ekskul_model.dart';
import 'package:attandance_simple/core/model/study_model.dart';
import 'package:attandance_simple/core/screen/data_siswa_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class ClassScreen extends StatefulWidget {
  final String infoStudi;
  const ClassScreen({Key? key, required this.infoStudi}) : super(key: key);

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final Box<StudyModel> _studiBox = Hive.box<StudyModel>('study_model');
  final Box<SiswaStudiModel> _studentBox = Hive.box<SiswaStudiModel>('Siswa_studi_model');
  final _nameStudiController = TextEditingController();

  Future<void> _addClass() async {
    if (_nameStudiController.text.isNotEmpty) {
      final newStudi = StudyModel(
        nameStudi: _nameStudiController.text,
        jumlah: '',
        jenjang: widget.infoStudi,
      );
      await _studiBox.add(newStudi);
      _nameStudiController.clear();
      Navigator.of(context).pop();
    }
  }

  Future<void> _updateStudi(int index) async {
    if (_nameStudiController.text.isNotEmpty) {
      final updatedStudi = StudyModel(
        nameStudi: _nameStudiController.text,
        jumlah: '',
        jenjang: widget.infoStudi,
      );
      await _studiBox.putAt(index, updatedStudi);
      _nameStudiController.clear();
      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteStudi(int index) async {
    final StudyModel? studi = _studiBox.getAt(index);
    if (studi == null) return;

    final studentBox = Hive.box<SiswaStudiModel>('Siswa_studi_model');
    final absensiBox = Hive.box<AttandenceEkskulModel>(
      'attandence_ekskul_model',
    );

    final siswaEntries = studentBox
        .toMap()
        .entries
        .where(
          (entry) =>
              entry.value.kelas.toLowerCase() == studi.nameStudi.toLowerCase(),
        )
        .toList();

    for (final entry in siswaEntries) {
      final absensiKeys = absensiBox.keys.where((key) {
        final absensi = absensiBox.get(key);
        return absensi != null && absensi.idStudet == entry.key;
      }).toList();
      for (final abKey in absensiKeys) {
        await absensiBox.delete(abKey);
      }
      await studentBox.delete(entry.key);
    }

    await _studiBox.deleteAt(index);
  }

  void _showFormatDialog({int? index}) {
    if (index != null) {
      final studi = _studiBox.getAt(index);
      final classStudent = _studentBox.getAt(index);
      _nameStudiController.text = studi?.nameStudi ?? '';
      _nameStudiController.text = classStudent?.nama ?? '';
    } else {
      _nameStudiController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(index == null ? 'Tambah Kelas' : 'Edit Kelas'),
        content: TextFormField(
          controller: _nameStudiController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Nama Kelas',
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
                _addClass();
              } else {
                _updateStudi(index);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    final studi = _studiBox.getAt(index);
    if (studi == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${studi.nameStudi}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _deleteStudi(index);
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
    _nameStudiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              children: [
                Text(
                  widget.infoStudi,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ValueListenableBuilder<Box<StudyModel>>(
              valueListenable: _studiBox.listenable(),
              builder: (context, box, _) {
                // **FILTER sesuai jenjang**
                final kelasTerfilter = box.values
                    .where((studi) => studi.jenjang == widget.infoStudi)
                    .toList();

                if (kelasTerfilter.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada data kelas. Silakan tambah melalui tombol +',
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: kelasTerfilter.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final studi = kelasTerfilter[index];
                    final jumlahStudent = _studentBox.values
                        .where(
                          (student) =>
                              student.kelas.toLowerCase() ==
                              studi.nameStudi.toLowerCase(),
                        )
                        .length;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 20.0,
                        ),
                        title: Text(
                          studi.nameStudi,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '$jumlahStudent siswa',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showFormatDialog(
                                index: box.values.toList().indexOf(studi),
                              );
                            } else if (value == 'delete') {
                              _showDeleteConfirmationDialog(
                                box.values.toList().indexOf(studi),
                              );
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
                                  DataSiswaScreen(
                                    nameClass: studi.nameStudi,
                                    jenjang: widget.infoStudi,),
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
        onPressed: () => _showFormatDialog(),
        backgroundColor: ColorComponent.addColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
