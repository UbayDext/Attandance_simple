

import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/component/drawer_component.dart';
import 'package:attandance_simple/core/model/Solo_round_model.dart';
import 'package:attandance_simple/core/model/Team_round_model.dart';
import 'package:attandance_simple/core/model/lomba_model.dart';
import 'package:attandance_simple/core/model/round_model.dart';
import 'package:attandance_simple/core/storange/Ekskul_data_storange.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'individu_screen.dart';
import 'team_screen.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  final Box<LombaModel> _lombaBox = Hive.box<LombaModel>('lomba_model');
  final _namaController = TextEditingController();
  final Box<EkskulDataStorange> _ekskulBox = Hive.box<EkskulDataStorange>(
    'Ekskul_data_storange',
  );
  String? _selectedEkskul;
  String? _selectedStatus;

  Future<void> _addLomba() async {
    if (_namaController.text.isNotEmpty &&
        _selectedStatus != null &&
        _selectedEkskul != null) {
      await _lombaBox.add(
        LombaModel(
          name: _namaController.text,
          status: _selectedStatus!,
          ekskul: _selectedEkskul!,
        ),
      );
      _namaController.clear();
      Navigator.of(context).pop();
    }
  }

  Future<void> _updateLomba(int index) async {
    if (_namaController.text.isNotEmpty &&
        _selectedStatus != null &&
        _selectedEkskul != null) {
      await _lombaBox.putAt(
        index,
        LombaModel(
          name: _namaController.text,
          status: _selectedStatus!,
          ekskul: _selectedEkskul!,
        ),
      );
      _namaController.clear();
      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteLombaAndAllData(int index) async {
    final lomba = _lombaBox.getAt(index)!;
    if (lomba.status == "Individu") {
      final roundBox = Hive.box<RoundModel>('round_model');
      final pesertaBox = Hive.box<SoloRoundModel>('Solo_round_model');
      final babakToDelete = roundBox.values
          .where((babak) => babak.raceName == lomba.name)
          .toList();
      for (var babak in babakToDelete) babak.delete();
      final pesertaToDelete = pesertaBox.values
          .where((peserta) => peserta.lombaName == lomba.name)
          .toList();
      for (var peserta in pesertaToDelete) peserta.delete();
    } else if (lomba.status == "Team") {
      final groupBox = Hive.box<TeamRoundModel>('Team_round_model');
      final groupToDelete = groupBox.values
          .where((group) => group.nameLomba == lomba.name)
          .toList();
      for (var group in groupToDelete) group.delete();
    }
    await _lombaBox.deleteAt(index);
  }

  void _showFormDialog({int? index}) {
    final List<String> opsiStatus = ['Individu', 'Team'];
    final List<String> opsiEkskul = [];
    if (index != null) {
      final lomba = _lombaBox.getAt(index)!;
      _namaController.text = lomba.name;
      _selectedStatus = lomba.status;
      _selectedEkskul = lomba.ekskul;
    } else {
      _namaController.clear();
      _selectedStatus = null;
      _selectedEkskul = null;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(index == null ? 'Tambah Data Lomba' : 'Edit Data Lomba'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _namaController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Nama Lomba',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  hint: const Text('Pilih Status Lomba'),
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
                  onChanged: (v) => setState(() => _selectedStatus = v),
                ),
                const SizedBox(height: 16),
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
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(index == null ? 'Simpan' : 'Update'),
            onPressed: () {
              if (index == null)
                _addLomba();
              else
                _updateLomba(index);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    final lomba = _lombaBox.getAt(index)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus lomba "${lomba.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await _deleteLombaAndAllData(index);
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
      drawer: DrawerComponent(),
      body: ValueListenableBuilder<Box<LombaModel>>(
        valueListenable: _lombaBox.listenable(),
        builder: (context, box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data Lomba.\nSilakan tambahkan melalui tombol +',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              final lomba = box.getAt(index)!;
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 20.0,
                  ),
                  title: Text(
                    lomba.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Status: ${lomba.status}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lomba.ekskul,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit')
                            _showFormDialog(index: index);
                          else if (value == 'delete')
                            _showDeleteConfirmationDialog(index);
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Hapus')),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    if (lomba.status == "Individu") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividuScreen(
                            nameRace: lomba.name,
                            ekskul: lomba.ekskul,
                            statusRace: lomba.status,
                          ),
                        ),
                      );
                    } else if (lomba.status == "Team") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamScreen(
                            nameRace: lomba.name,
                            ekskul: lomba.ekskul,
                            statusRace: lomba.status,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        backgroundColor: ColorComponent.addColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
