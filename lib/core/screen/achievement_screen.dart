import 'dart:io';


import 'package:attandance_simple/core/component/drawer_component.dart';
import 'package:attandance_simple/core/model/Champion_model.dart';
import 'package:attandance_simple/core/storange/Ekskul_data_storange.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';



class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  final Box<ChampionModel> _siswaBox = Hive.box<ChampionModel>(
    'Champion_model',
  );
  final Box<EkskulDataStorange> _ekskulBox = Hive.box<EkskulDataStorange>(
    'Ekskul_data_storange',
  );

  final picker = ImagePicker();
  void _showAddSiswaForm({int? index, ChampionModel? editSiswa}) {
    final List<String> opsiStatus = ['TK', 'SD', 'SMP'];
    String? fotoPath = editSiswa?.fotoPath;
    final _namaController = TextEditingController(text: editSiswa?.nama ?? '');
    String? _selectedStatus = editSiswa?.jenjang;
    String? _selectedEkskul = editSiswa?.ekskul;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              editSiswa == null
                  ? "Tambah Siswa Prestasi"
                  : "Edit Siswa Prestasi",
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picked = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        setDialogState(() {
                          fotoPath = picked.path;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: (fotoPath != null)
                          ? FileImage(File(fotoPath!))
                          : null,
                      child: fotoPath == null
                          ? const Icon(
                              Icons.camera_alt,
                              size: 32,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _namaController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Nama Siswa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    hint: const Text('Pilih Status Jenjang'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: opsiStatus
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setDialogState(() {
                        _selectedStatus = v;
                        _selectedEkskul =
                            null; // <--- Reset ekskul setiap ganti jenjang!
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<Box<EkskulDataStorange>>(
                    valueListenable: _ekskulBox.listenable(),
                    builder: (context, box, _) {
                      // Filter ekskul unik sesuai jenjang yang dipilih
                      final opsiEkskul = <String>{};
                      for (final e in box.values) {
                        if (_selectedStatus != null &&
                            e.jenjang == _selectedStatus) {
                          opsiEkskul.add(e.nama);
                        }
                      }
                      final opsiEkskulList = opsiEkskul.toList();

                      return DropdownButtonFormField<String>(
                        value: (opsiEkskulList.contains(_selectedEkskul))
                            ? _selectedEkskul
                            : null,
                        hint: const Text('Pilih Ekskul'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: opsiEkskulList.map((String ekskul) {
                          return DropdownMenuItem<String>(
                            value: ekskul,
                            child: Text(ekskul),
                          );
                        }).toList(),
                        onChanged: (_selectedStatus == null)
                            ? null 
                            : (String? newValue) {
                                setDialogState(() {
                                  _selectedEkskul = newValue;
                                });
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () async {
                  if (_namaController.text.isEmpty ||
                      _selectedStatus == null ||
                      _selectedEkskul == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Semua field harus diisi')),
                    );
                    return;
                  }
                  if (editSiswa != null && index != null) {
                    final updated = ChampionModel(
                      fotoPath: fotoPath,
                      nama: _namaController.text,
                      jenjang: _selectedStatus!,
                      ekskul: _selectedEkskul!,
                    );
                    await _siswaBox.putAt(index, updated);
                  } else {
                    await _siswaBox.add(
                      ChampionModel(
                        fotoPath: fotoPath,
                        nama: _namaController.text,
                        jenjang: _selectedStatus!,
                        ekskul: _selectedEkskul!,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteSiswaDialog(int index, ChampionModel siswa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Siswa'),
        content: Text('Yakin ingin menghapus ${siswa.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await _siswaBox.deleteAt(index);
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerComponent(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.school, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Siswa Prestasi',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[200],
        child: const Icon(Icons.add),
        onPressed: _showAddSiswaForm,
      ),
      body: ValueListenableBuilder(
        valueListenable: _siswaBox.listenable(),
        builder: (context, Box<ChampionModel> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data siswa prestasi.\nSilakan tambahkan dengan tombol +',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              final siswa = box.getAt(index)!;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: siswa.fotoPath != null
                        ? FileImage(File(siswa.fotoPath!))
                        : null,
                    child: siswa.fotoPath == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  title: Text(siswa.nama),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jenjang: ${siswa.jenjang}'),
                      Text('Ekskul: ${siswa.ekskul}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        child: const Text("Lihat Data"),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => DetailSiswaScreen(
                          //       siswa: siswa,
                          //       index: index,
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showAddSiswaForm(index: index, editSiswa: siswa);
                          } else if (value == 'delete') {
                            _deleteSiswaDialog(index, siswa);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
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
    );
  }
}
