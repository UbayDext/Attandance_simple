
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/model/Group_model.dart';
import 'package:attandance_simple/core/model/Team_round_model.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';



class BracketScreen extends StatefulWidget {
  final String namaLogo;
  final String ekskul;
  final String namaLomba;
  final String statusLomba;
  final Group group;
  final int groupHiveKey;
  final TeamRoundModel teamHiveModel;

  const BracketScreen({
    Key? key,
    required this.namaLogo,
    required this.ekskul,
    required this.namaLomba,
    required this.statusLomba,
    required this.group,
    required this.groupHiveKey,
    required this.teamHiveModel,
  }) : super(key: key);

  @override
  State<BracketScreen> createState() => _BracketScreenState();
}

class _BracketScreenState extends State<BracketScreen> {
  late List<String?> round1;
  late List<String?> round2;
  String? finalWinner;

  @override
  void initState() {
    super.initState();
    // Cek ada status tersimpan
    round1 =
        widget.teamHiveModel.round1Status ??
        List<String?>.from(widget.group.teamNames);
    round2 = widget.teamHiveModel.round2Status ?? [null, null];
    finalWinner = widget.teamHiveModel.champion.isNotEmpty
        ? widget.teamHiveModel.champion
        : null;
  }

  void _saveBracketStateToHive() async {
    final box = Hive.box<TeamRoundModel>('Team_round_model');
    final old = widget.teamHiveModel;
    final updated = TeamRoundModel(
      nameGroup: old.nameGroup,
      nameTeam1: old.nameTeam1,
      nameTeam2: old.nameTeam2,
      nameTeam3: old.nameTeam3,
      nameTeam4: old.nameTeam4,
      champion: finalWinner ?? "",
      nameLomba: old.nameLomba,
      nameEkskul: old.nameEkskul,
      round1Status: round1,
      round2Status: round2,
    );
    await box.put(widget.groupHiveKey, updated);
  }

  void _eliminateInRound(int roundIdx, int pos) async {
    if (finalWinner != null) return;
    setState(() {
      if (roundIdx == 1) {
        int groupIdx = pos ~/ 2;
        int lawan = pos % 2 == 0 ? pos + 1 : pos - 1;
        if (round1[pos] != null && round2[groupIdx] == null) {
          round2[groupIdx] = round1[lawan];
          round1[pos] = null;
        }
      } else if (roundIdx == 2) {
        int lawan = pos == 0 ? 1 : 0;
        if (round2[pos] != null && finalWinner == null) {
          finalWinner = round2[lawan];
          round2[pos] = null;
        }
      }
      _saveBracketStateToHive();
    });
  }

  Widget _teamBox(
    String? text,
    double w, {
    VoidCallback? onDoubleTap,
    bool eliminated = false,
  }) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: w,
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: eliminated ? Colors.grey[100] : Colors.white,
          border: Border.all(
            color: eliminated ? Colors.grey.shade300 : Colors.grey.shade400,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text ?? '',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: eliminated ? Colors.grey[400] : Colors.black87,
            decoration: eliminated
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height * 0.60;

    return Scaffold(
      appBar: AppbarComponent(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              widget.ekskul,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              widget.namaLomba,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              widget.statusLomba,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              widget.group.groupName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(width * 0.93, height),
                      painter: Bracket4Painter(),
                    ),
                    SizedBox(
                      width: width * 0.93,
                      height: height,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: width * 0.23,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(4, (i) {
                                return _teamBox(
                                  round1[i],
                                  width * 0.19,
                                  onDoubleTap:
                                      (round1[i] != null &&
                                          round2[i ~/ 2] == null &&
                                          finalWinner == null)
                                      ? () => _eliminateInRound(1, i)
                                      : null,
                                  eliminated: round1[i] == null,
                                );
                              }),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.18,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(height: 25),
                                _teamBox(
                                  round2[0],
                                  width * 0.16,
                                  onDoubleTap:
                                      (round2[0] != null && finalWinner == null)
                                      ? () => _eliminateInRound(2, 0)
                                      : null,
                                  eliminated:
                                      round2[0] == null &&
                                      (round1[0] == null || round1[1] == null),
                                ),
                                _teamBox(
                                  round2[1],
                                  width * 0.16,
                                  onDoubleTap:
                                      (round2[1] != null && finalWinner == null)
                                      ? () => _eliminateInRound(2, 1)
                                      : null,
                                  eliminated:
                                      round2[1] == null &&
                                      (round1[2] == null || round1[3] == null),
                                ),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * 0.18,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _teamBox(
                                  finalWinner,
                                  width * 0.16,
                                  eliminated: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: height / 2 - 38,
                      child: Column(
                        children: const [
                          Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                            size: 44,
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Champion",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bracket4Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 3;

    double boxHeight = 35, boxSpacing = (size.height - 4 * 38) / 3;
    double col1 = 20, col2 = col1 + 30, col3 = col2 + 90;

    List<double> y = [
      0,
      boxHeight + boxSpacing,
      2 * (boxHeight + boxSpacing),
      3 * (boxHeight + boxSpacing),
    ];

    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(col1, y[i] + boxHeight / 2),
        Offset(col2, y[i] + boxHeight / 2),
        paint,
      );
    }

    canvas.drawLine(
      Offset(col2, y[0] + boxHeight / 2),
      Offset(col2, y[1] + boxHeight / 2),
      paint,
    );
    canvas.drawLine(
      Offset(col2, y[2] + boxHeight / 2),
      Offset(col2, y[3] + boxHeight / 2),
      paint,
    );

    canvas.drawLine(
      Offset(col2, (y[0] + y[1]) / 2 + boxHeight / 2),
      Offset(col3, (y[0] + y[1]) / 2 + boxHeight / 2),
      paint,
    );
    canvas.drawLine(
      Offset(col2, (y[2] + y[3]) / 2 + boxHeight / 2),
      Offset(col3, (y[2] + y[3]) / 2 + boxHeight / 2),
      paint,
    );

    canvas.drawLine(
      Offset(col3, (y[0] + y[1]) / 2 + boxHeight / 2),
      Offset(col3, (y[2] + y[3]) / 2 + boxHeight / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
