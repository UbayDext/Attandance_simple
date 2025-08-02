import 'package:attandance_simple/core/component/color_component.dart';
import 'package:attandance_simple/core/screen/setting_screen.dart';
import 'package:flutter/material.dart';


class DrawerComponent extends StatelessWidget {
  const DrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("Panitia Lomba"),
            accountEmail: Text("panitia@sekolah.id"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "P",
                style: TextStyle(fontSize: 40.0, color: Colors.blue),
              ),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Students'),
            onTap: () {
              Navigator.pushNamed(context, '/siswa');
            },
          ),

          ListTile(
            leading: const Icon(Icons.sports_kabaddi),
            title: const Text('Ekskul'),
            onTap: () {
              Navigator.pushNamed(context, '/ekskul');
            },
          ),

          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Competition'),
            onTap: () {
              Navigator.pushNamed(context, '/eksport');
            },
          ),

          ListTile(
            leading: const Icon(Icons.military_tech),
            title: const Text('Achievement'),
            onTap: () {
              Navigator.pushNamed(context, '/achievement');
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Setting'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: ColorComponent.warning),
            title: const Text(
              'Log-out',
              style: TextStyle(color: ColorComponent.warning),
            ),
            onTap: () {
              print('Tombol Logout ditekan');
            },
          ),
        ],
      ),
    );
  }
}
