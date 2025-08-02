// lib/add_lomba_screen.dart

import 'package:flutter/material.dart';

class AddIcon extends StatefulWidget {
  const AddIcon({super.key});

  @override
  State<AddIcon> createState() => _AddIconState();
}

class _AddIconState extends State<AddIcon> {
  // Controller untuk mengambil teks dari TextFormField
  final _lombaController = TextEditingController();

  @override
  void dispose() {
    _lombaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Cabang Lomba'),
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali default
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama Lomba',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lombaController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Masukkan jenis lomba di sini...',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(), // Mendorong baris tombol ke bawah
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Tombol "No" (Batal)
                TextButton(
                  onPressed: () {
               
                    Navigator.pop(context);
                  },
                  child: const Text('NO'),
                ),
                const SizedBox(width: 16),
                // Tombol "Save" (Simpan)
                ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman sebelumnya dan mengirim data dari controller
                    if (_lombaController.text.isNotEmpty) {
                      Navigator.pop(context, _lombaController.text);
                    }
                  },
                  child: const Text('SAVE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}