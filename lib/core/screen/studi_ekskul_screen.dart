
import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/component/drawer_component.dart';
import 'package:attandance_simple/core/screen/ekskul_screen.dart';
import 'package:flutter/material.dart';


class StudiEkskulScreen extends StatefulWidget {
  const StudiEkskulScreen({super.key});

  @override
  State<StudiEkskulScreen> createState() => _StudiEkskulScreenState();
}

class _StudiEkskulScreenState extends State<StudiEkskulScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      drawer: DrawerComponent(),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _buildJenjangCard(
                  context,
                  label: "TKIT",
                  icon: Icons.child_friendly,
                ),
                const SizedBox(height: 16),
                _buildJenjangCard(
                  context,
                  label: "SDIT",
                  icon: Icons.menu_book,
                ),
                const SizedBox(height: 16),
                _buildJenjangCard(context, label: "SMPIT", icon: Icons.school),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJenjangCard(
    BuildContext context, {
    required String label,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EkskulScreen(infoStudi: label),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: Icon(icon, size: 28, color: Colors.grey[700]),
              ),
              const SizedBox(width: 24),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
