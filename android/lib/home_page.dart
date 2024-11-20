import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'karyawan_page.dart';
import 'tambah_edit_karyawan_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Karyawan> _karyawanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKaryawan();
  }

  Future<void> _loadKaryawan() async {
    try {
      final karyawanData = await _databaseHelper.getKaryawan();
      setState(() {
        _karyawanList = karyawanData.map((data) {
          return Karyawan.fromMap({
            ...data,
            'email': data['email'] ?? '',
          });
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data karyawan: $e')),
      );
    }
  }

  Future<void> _deleteKaryawan(int id) async {
    try {
      await _databaseHelper.deleteKaryawan(id);
      _loadKaryawan();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus karyawan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard (Admin)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushNamed(context, '/logout'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _karyawanList.isEmpty
              ? const Center(child: Text('Tidak ada data karyawan'))
              : ListView.builder(
                  itemCount: _karyawanList.length,
                  itemBuilder: (context, index) {
                    final karyawan = _karyawanList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(karyawan.nama,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Email: ${karyawan.email.isNotEmpty ? karyawan.email : 'Email tidak tersedia'}'),
                            Text('Status: ${karyawan.status}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TambahEditKaryawanPage(
                                            karyawan: karyawan),
                                  ),
                                );
                                if (result == true) _loadKaryawan();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Konfirmasi'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin menghapus karyawan ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (confirm == true)
                                  _deleteKaryawan(karyawan.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TambahEditKaryawanPage()),
          );
          if (result == true) _loadKaryawan();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
