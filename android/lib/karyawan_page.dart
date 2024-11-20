class Karyawan {
  int? id;
  String nama;
  String email;
  String status;

  Karyawan({
    this.id,
    required this.nama,
    required this.email,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'status': status,
    };
  }

  factory Karyawan.fromMap(Map<String, dynamic> map) {
    return Karyawan(
      id: map['id'],
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
