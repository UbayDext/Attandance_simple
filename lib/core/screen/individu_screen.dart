
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/model/Solo_round_model.dart';
import 'package:attandance_simple/core/model/round_model.dart';
import 'package:attandance_simple/core/screen/individu_round_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';



class IndividuScreen extends StatefulWidget {
  final String nameRace;
  final String ekskul;
  final String statusRace;

  const IndividuScreen({
    Key? key,
    required this.nameRace,
    required this.statusRace,
    required this.ekskul,
  }) : super(key: key);

  @override
  State<IndividuScreen> createState() => _IndividuScreenState();
}

class _IndividuScreenState extends State<IndividuScreen> {
  final Box<RoundModel> _raceStatusBox = Hive.box<RoundModel>('round_model');
  final _roundController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _statusRound;

  void _showFormDialog({int? index}) {
    if (index != null) {
      final babak = _raceStatusBox.getAt(index)!;
      _roundController.text = babak.round;
      _startDate = babak.startRound;
      _endDate = babak.endRound;
      _statusRound = babak.statusRound;
    } else {
      _roundController.clear();
      _startDate = null;
      _endDate = null;
      _statusRound = null;
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(index == null ? 'Tambah Babak' : 'Edit Babak'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _roundController,
                    decoration: InputDecoration(
                      labelText: 'Nama Babak',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      _startDate == null
                          ? 'Pilih Tanggal Mulai'
                          : 'Mulai: ${DateFormat('dd/MM/yyyy').format(_startDate!)}',
                    ),
                    trailing: Icon(Icons.date_range),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          _startDate = picked;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      _endDate == null
                          ? 'Pilih Tanggal Selesai'
                          : 'Selesai: ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                    ),
                    trailing: Icon(Icons.date_range),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? (_startDate ?? DateTime.now()),
                        firstDate: _startDate ?? DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          _endDate = picked;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Status: '),
                      DropdownButton<String>(
                        value: _statusRound,
                        hint: const Text('Pilih Status'),
                        items: const [
                          DropdownMenuItem(
                            value: 'berlangsung',
                            child: Text('Berlangsung'),
                          ),
                          DropdownMenuItem(
                            value: 'selesai',
                            child: Text('Selesai'),
                          ),
                        ],
                        onChanged: (v) {
                          setDialogState(() => _statusRound = v);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Batal'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(index == null ? 'Simpan' : 'Update'),
                onPressed: () async {
                  if (_roundController.text.isEmpty ||
                      _startDate == null ||
                      _endDate == null ||
                      _statusRound == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Semua field harus diisi!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  final data = RoundModel(
                    round: _roundController.text,
                    startRound: _startDate!,
                    endRound: _endDate!,
                    statusRound: _statusRound!,
                    raceName: widget.nameRace,
                  );
                  if (index == null) {
                    await _raceStatusBox.add(data);
                  } else {
                    await _raceStatusBox.putAt(index, data);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // === Delete babak SEKALIGUS peserta terkait ===
  Future<void> _deleteRoundAndParticipants(int index) async {
    final babak = _raceStatusBox.getAt(index)!;
    final roundName = babak.round;
    final lombaName = babak.raceName;

    final scoreBox = Hive.box<SoloRoundModel>('Solo_round_model');
    final pesertaToDelete = scoreBox.keys.where((key) {
      final peserta = scoreBox.get(key);
      return peserta?.roundName == roundName && peserta?.lombaName == lombaName;
    }).toList();

    for (final key in pesertaToDelete) {
      await scoreBox.delete(key);
    }

    await _raceStatusBox.deleteAt(index);
  }

  void _showDeleteDialog(int index) {
    final babak = _raceStatusBox.getAt(index)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Babak'),
        content: Text('Hapus babak "${babak.round}"?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await _deleteRoundAndParticipants(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);

  @override
  void dispose() {
    _roundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorComponent.addColor,
        child: const Icon(Icons.add, color: ColorComponent.bgColor),
        onPressed: () => _showFormDialog(),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              children: [
                Text(
                  widget.ekskul,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.nameRace,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Status: ${widget.statusRace}',
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ValueListenableBuilder<Box<RoundModel>>(
              valueListenable: _raceStatusBox.listenable(),
              builder: (context, box, _) {
                // Filter data babak berdasarkan nama lomba
                final filtered = box.values
                    .where((item) => (item.raceName ?? '') == widget.nameRace)
                    .toList();
                if (filtered.isEmpty) {
                  return const Center(child: Text('Belum ada babak.'));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final babak = filtered[index];

                    // --- Logika auto status ---
                    String statusDisplay = babak.statusRound;
                    if (babak.statusRound == "berlangsung" &&
                        DateTime.now().isAfter(babak.endRound)) {
                      statusDisplay = "selesai";
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        title: Text(
                          babak.round,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text('Start: ${_formatDate(babak.startRound)}'),
                            const SizedBox(height: 10),
                            Text('End:   ${_formatDate(babak.endRound)}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusDisplay == "berlangsung"
                                    ? Colors.orange.shade100
                                    : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusDisplay,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: statusDisplay == "berlangsung"
                                      ? Colors.orange
                                      : Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showFormDialog(
                                    index: box.values.toList().indexOf(babak),
                                  );
                                } else if (value == 'delete') {
                                  _showDeleteDialog(
                                    box.values.toList().indexOf(babak),
                                  );
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
                        onTap: () {
                          // Kirim statusDisplay (auto updated) ke screen peserta!
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndividuRoundScreen(
                                namaLogo: "Nama Logo",
                                ekskul: widget.ekskul,
                                namaLomba: widget.nameRace,
                                statusLomba: statusDisplay,
                                pointCount: 5,
                                roundName: babak.round,
                              ),
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
    );
  }
}
