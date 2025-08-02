
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/model/Group_model.dart';
import 'package:attandance_simple/core/model/Team_round_model.dart';
import 'package:attandance_simple/core/screen/bracket_screen.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';


class TeamScreen extends StatefulWidget {
  final String nameRace;
  final String ekskul;
  final String statusRace;

  const TeamScreen({
    Key? key,
    required this.nameRace,
    required this.statusRace,
    required this.ekskul,
  }) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  late Box<TeamRoundModel> _groupBox;

  @override
  void initState() {
    super.initState();
    _groupBox = Hive.box<TeamRoundModel>('Team_round_model');
  }

  void _showAddGroupDialog() {
    final groupNameController = TextEditingController();
    final List<TextEditingController> teamControllers = List.generate(
      4,
      (_) => TextEditingController(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Tambah Group",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  labelText: "nama grup",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(
                teamControllers.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: teamControllers[i],
                    decoration: InputDecoration(
                      labelText: "nama team",
                      border: const OutlineInputBorder(),
                      prefixText: "${i + 1}. ",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              String groupName = groupNameController.text.trim();
              List<String> teams = teamControllers
                  .map((c) => c.text.trim())
                  .toList();

              if (groupName.isNotEmpty && teams.every((t) => t.isNotEmpty)) {
                final group = TeamRoundModel(
                  nameGroup: groupName,
                  nameTeam1: teams[0],
                  nameTeam2: teams[1],
                  nameTeam3: teams[2],
                  nameTeam4: teams[3],
                  champion: "",
                  nameLomba: widget.nameRace,
                  nameEkskul: widget.ekskul,
                );
                _groupBox.add(group);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, TeamRoundModel group) {
    List<String> teams = [
      group.nameTeam1,
      group.nameTeam2,
      group.nameTeam3,
      group.nameTeam4,
    ];
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BracketScreen(
              groupHiveKey: group.key,
              teamHiveModel: group,
              namaLogo: "Nama Logo",
              ekskul: widget.ekskul,
              namaLomba: widget.nameRace,
              statusLomba: widget.statusRace,
              group: Group(groupName: group.nameGroup, teamNames: teams),
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                group.nameGroup,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              ...teams.map(
                (team) => Padding(
                  padding: const EdgeInsets.only(bottom: 2.5),
                  child: Text(
                    team,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2.5,
                  ),
                  child: Text(
                    'Champion ${group.champion.isNotEmpty ? group.champion : 'Belum ada pemenang'}',
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorComponent.addColor,
        child: const Icon(Icons.add, color: ColorComponent.bgColor),
        onPressed: _showAddGroupDialog,
      ),
      body: Column(
        children: [
          // HEADER INFO
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              children: [
                Text(
                  'Ekskul: ${widget.ekskul}',

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Nama Lomba: ${widget.nameRace}',

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
          // GRID GROUP
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _groupBox.listenable(),
              builder: (context, Box<TeamRoundModel> box, _) {
                var filtered = box.values
                    .where(
                      (group) =>
                          group.nameGroup.isNotEmpty &&
                          group.nameLomba == widget.nameRace &&
                          group.nameEkskul == widget.ekskul,
                    )
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada group.\nKlik tombol + untuk menambah.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16, top: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final group = filtered[i];
                    return _buildGroupCard(context, group);
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
