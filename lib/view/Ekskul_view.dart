import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/cubit/cubit_ekskul/ekskul_cubit_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_ekskul/ekskul_cubit_state.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/screen/date_ekskul_screen.dart';
import 'package:attandance_simple/core/storange/Ekskul_data_storange.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class EkskulView extends StatefulWidget {
  final String infoStudi;
  const EkskulView({Key? key, required this.infoStudi}) : super(key: key);

  @override
  State<EkskulView> createState() => _EkskulViewState();
}

class _EkskulViewState extends State<EkskulView> {
  final _namaController = TextEditingController();

  void _showFormDialog({int? index, String? nama}) {
    if (nama != null) {
      _namaController.text = nama;
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
              final cubit = context.read<EkskulCubit>();
              if (index == null) {
                cubit.addEkskul(_namaController.text.trim());
              } else {
                cubit.updateEkskul(index, _namaController.text.trim());
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<EkskulCubit>().deleteEkskul(index);
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
    final siswaBox = Hive.box<SiswaStudiModel>('Siswa_studi_model');
    return Scaffold(
      appBar: AppbarComponent(),
      body: Column(
        children: [
          Text(widget.infoStudi),
          const Divider(),
          Expanded(
            child: BlocConsumer<EkskulCubit, EkskulState>(
              listener: (context, state) {
                if (state is EkskulError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is EkskulLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is EkskulLoaded) {
                  final ekskulList = state.ekskulList;
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
                      final jumlahSiswa = siswaBox.values
                          .where((siswa) =>
                              siswa.ekskul.toLowerCase() == ekskul.nama.toLowerCase() &&
                              siswa.jenjang == widget.infoStudi)
                          .length;
                      final realIndex = Hive.box<EkskulDataStorange>('Ekskul_data_storange')
                          .values
                          .toList()
                          .indexOf(ekskul);
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
                                _showFormDialog(
                                    index: realIndex, nama: ekskul.nama);
                              } else if (value == 'delete') {
                                _showDeleteConfirmationDialog(
                                    realIndex, ekskul.nama);
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
                                builder: (context) => DateEkskulScreen(namaEkskul: ekskul.nama),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
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
