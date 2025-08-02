

import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/model/Solo_round_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';



class IndividuRoundScreen extends StatefulWidget {
  final String namaLogo;
  final String ekskul;
  final String namaLomba;
  final String statusLomba;
  final int pointCount;
  final String roundName;

  const IndividuRoundScreen({
    Key? key,
    required this.namaLogo,
    required this.ekskul,
    required this.namaLomba,
    required this.statusLomba,
    this.pointCount = 5,
    required this.roundName,
  }) : super(key: key);

  @override
  State<IndividuRoundScreen> createState() => _IndividuRoundScreenState();
}

class _IndividuRoundScreenState extends State<IndividuRoundScreen> {
  late Box<SoloRoundModel> scoreBox;
  bool isStatusSelesai = false;

  @override
  void initState() {
    super.initState();
    scoreBox = Hive.box<SoloRoundModel>('Solo_round_model');
  }

  void _showAddParticipantDialog() async {
    final siswaBox = Hive.box<SiswaStudiModel>('Siswa_studi_model');
    final pesertaSudahAda = scoreBox.values
        .where((e) => e.roundName == widget.roundName && e.lombaName == widget.namaLomba)
        .map((e) => e.name)
        .toSet();

    final siswaList = siswaBox.values
        .where((s) => s.ekskul == widget.ekskul)
        .where((s) => !pesertaSudahAda.contains(s.nama))
        .toList();

    List<bool> selected = List.generate(siswaList.length, (_) => false);

    if (siswaList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada siswa yang bisa ditambahkan')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tambah Peserta'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: siswaList.length,
              itemBuilder: (ctx, i) {
                return CheckboxListTile(
                  title: Text(siswaList[i].nama),
                  value: selected[i],
                  onChanged: (val) {
                    setState(() => selected[i] = val!);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(ctx),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                for (int i = 0; i < siswaList.length; i++) {
                  if (selected[i]) {
                    scoreBox.add(SoloRoundModel(
                      name: siswaList[i].nama,
                      points: List.generate(widget.pointCount, (_) => 0),
                      roundName: widget.roundName,
                      lombaName: widget.namaLomba,
                    ));
                  }
                }
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _increasePoint(int participantIndex, int pointIndex, List<SoloRoundModel> listFiltered) {
    if (isStatusSelesai) return;
    final participant = listFiltered[participantIndex];
    final idxInBox = scoreBox.values.toList().indexOf(participant);
    if (idxInBox == -1) return;
    final updatedPoints = List<int>.from(participant.points);
    if (updatedPoints[pointIndex] < 90) {
      updatedPoints[pointIndex] += 5;
      final updatedParticipant = SoloRoundModel(
        name: participant.name,
        points: updatedPoints,
        roundName: participant.roundName,
        lombaName: participant.lombaName,
      );
      scoreBox.putAt(idxInBox, updatedParticipant);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      body: ValueListenableBuilder(
        valueListenable: scoreBox.listenable(),
        builder: (context, Box<SoloRoundModel> box, _) {
          final statusBabak = ModalRoute.of(context)?.settings.arguments as String? ?? widget.statusLomba;
          isStatusSelesai = statusBabak == "selesai";

          final filtered = box.values.where((peserta) =>
            peserta.roundName == widget.roundName && peserta.lombaName == widget.namaLomba
          ).toList();

          if (filtered.isEmpty) return const Center(child: Text('Belum ada peserta.'));

          if (isStatusSelesai) {
            filtered.sort((a, b) =>
              b.points.fold(0, (p, n) => p + n).compareTo(a.points.fold(0, (p, n) => p + n))
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.ekskul, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(widget.namaLomba, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    Text(widget.statusLomba, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Text(widget.roundName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // TABLE HEADER
              Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    SizedBox(width: 28, child: Text('No')),
                    Expanded(flex: 2, child: Text('Nama')),
                    if (!isStatusSelesai) ...List.generate(widget.pointCount, (i) => Expanded(
                      child: Text('Point\n${i + 1}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                    )) else
                      Expanded(child: Text('Total Score', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final peserta = filtered[i];
                    final totalScore = peserta.points.fold(0, (p, n) => p + n);
                    return Row(
                      children: [
                        SizedBox(width: 28, child: Text('${i + 1}')),
                        Expanded(flex: 2, child: Text(peserta.name)),
                        if (!isStatusSelesai) ...List.generate(widget.pointCount, (j) => Expanded(
                          child: GestureDetector(
                            onTap: () => _increasePoint(i, j, filtered),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                              child: Text(peserta.points[j].toString(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )) else
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                totalScore.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: isStatusSelesai
        ? null
        : FloatingActionButton(
            onPressed: _showAddParticipantDialog,
            child: const Icon(Icons.add),
          ),
    );
  }
}
