import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'karyawan_page.dart';

class TambahEditKaryawanPage extends StatefulWidget {
  final Karyawan? karyawan;

  const TambahEditKaryawanPage({Key? key, this.karyawan}) : super(key: key);

  @override
  _TambahEditKaryawanPageState createState() => _TambahEditKaryawanPageState();
}

class _TambahEditKaryawanPageState extends State<TambahEditKaryawanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _statusController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.karyawan != null) {
      _namaController.text = widget.karyawan!.nama;
      _emailController.text = widget.karyawan?.email ?? '';
      _statusController.text = widget.karyawan!.status;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _simpanKaryawan() async {
    if (_formKey.currentState!.validate()) {
      final karyawan = Karyawan(
        id: widget.karyawan?.id,
        nama: _namaController.text,
        email: _emailController.text,
        status: _statusController.text,
      );

      try {
        if (widget.karyawan == null) {
          await _databaseHelper.insertKaryawan(karyawan.toMap());
        } else {
          await _databaseHelper.updateKaryawan(karyawan.toMap());
        }
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan karyawan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.karyawan == null
            ? 'Menambahkan database (karyawan)'
            : 'Mengedit database (karyawan)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Status tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpanKaryawan,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
