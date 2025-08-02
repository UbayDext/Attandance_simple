


import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/model/Trofi_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';


class DetailSiswaScreen extends StatefulWidget {
  final SiswaStudiModel siswa;
  final int index;

  const DetailSiswaScreen({Key? key, required this.siswa, required this.index})
    : super(key: key);

  @override
  State<DetailSiswaScreen> createState() => _DetailSiswaScreenState();
}

class _DetailSiswaScreenState extends State<DetailSiswaScreen> {
  final Box<TrofiModel> sertifikatBox = Hive.box<TrofiModel>('Trofi_model');

  final picker = ImagePicker();

  void _showAddSertifikatDialog() {
    String? _ekskul = widget.siswa.ekskul;
    String? filePath;
    final _lombaController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Tambah Sertifikat"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _lombaController,
                    decoration: const InputDecoration(
                      labelText: "Nama Lomba",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final picked = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        setDialogState(() => filePath = picked.path);
                      }
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.file_upload),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              filePath ?? 'File upload',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: filePath != null
                                    ? Colors.black
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  if (_lombaController.text.isEmpty ||
                      filePath == null ||
                      _ekskul == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Semua field harus diisi')),
                    );
                    return;
                  }
                  await sertifikatBox.add(
                    TrofiModel(
                      lomba: _lombaController.text,
                      filePath: filePath!,
                      ekskul: _ekskul,
                      nameSiswa: widget.siswa.nama,
                      kelas: widget.siswa.kelas,
                    ),
                  );
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

  void _openFile(String path) {
    OpenFile.open(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Siswa"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSertifikatDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CircleAvatar(
            //   radius: 44,
            //   backgroundColor: Colors.grey[300],
            //   backgroundImage: widget.siswa.fotoPath != null
            //       ? FileImage(File(widget.siswa.fotoPath!))
            //       : null,
            //   child: widget.siswa.fotoPath == null
            //       ? const Icon(Icons.person, color: Colors.white, size: 44)
            //       : null,
            // ),
            // const SizedBox(height: 10),
            Text(
              widget.siswa.nama,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('Kelas: ${widget.siswa.kelas}'), // update jika ada field kelas
            // Text('Jenjang: ${widget.siswa.jenjang}'),
            Text('Ekskul: ${widget.siswa.ekskul}'),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              "Daftar Sertifikat",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<TrofiModel>>(
                valueListenable: sertifikatBox.listenable(),
                builder: (context, box, _) {
                  // Filter sertifikat khusus siswa ini (misal: by ekskul/nama, atau tambah field siswaId jika ingin lebih presisi)
                  final sertifikatList = box.values
                      .where(
                        (e) =>
                            e.ekskul == widget.siswa.ekskul &&
                            e.nameSiswa == widget.siswa.nama &&
                            e.kelas == widget.siswa.kelas,
                      )
                      .toList();

                  if (sertifikatList.isEmpty) {
                    return const Center(child: Text('Belum ada sertifikat'));
                  }

                  return ListView.builder(
                    itemCount: sertifikatList.length,
                    itemBuilder: (context, index) {
                      final sertifikat = sertifikatList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.verified),
                          title: Text(sertifikat.lomba),
                          subtitle: Text(sertifikat.filePath),
                          trailing: IconButton(
                            icon: const Icon(Icons.description_rounded),
                            onPressed: () => _openFile(sertifikat.filePath),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
