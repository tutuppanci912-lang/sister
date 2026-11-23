import 'package:flutter/foundation.dart';

String two(int n) => n.toString().padLeft(2, '0');
String dateKey(DateTime d) => '${d.year}-${two(d.month)}-${two(d.day)}';
const bulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
  'Agustus', 'September', 'Oktober', 'November', 'Desember'
];
String bulanPendek(int m) => bulan[m - 1].substring(0, 3);
String tglPanjang(DateTime d) => '${d.day} ${bulan[d.month - 1]} ${d.year}';
String tglPendek(DateTime d) => '${two(d.day)}/${two(d.month)}/${d.year}';

class DayRecord {
  String? masuk; // "HH:mm"
  String? pulang;
  String? status; // Tepat Waktu | Terlambat
}

class IzinItem {
  IzinItem({
    required this.judul,
    required this.jenis,
    required this.mulai,
    required this.selesai,
    required this.alasan,
    this.lampiran,
    this.status = 'Menunggu',
  });
  final String judul, jenis, alasan;
  final DateTime mulai, selesai;
  final String? lampiran;
  final String status;
}

/// State aplikasi sederhana (tanpa package tambahan). Ganti dengan API/database nanti.
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState i = AppState._();

  bool login = false;
  final String nama = 'Jasmine Kumalasari';
  final String kelas = 'XI RPL 1';
  final String sekolah = 'SMK Negeri 1 Bukateja';

  final Map<String, DayRecord> riwayat = {};
  final List<IzinItem> izin = [];

  /// Data Diri: label -> nilai ('-' jika belum diisi).
  final Map<String, Map<String, String>> profil = {
    'Data Personal': {
      'Nama': 'Jasmine Kumalasari',
      'Tempat Lahir': '-',
      'Tanggal Lahir': '-',
      'Jenis Kelamin': '-',
      'Telepon': '-',
      'NIS': '-',
      'NISN': '-',
      'NIK': '-',
      'Agama': '-',
      'Alamat': '-',
      'Anak Ke-': '-',
      'Status Anak': '-',
      'Asal Sekolah': '-',
      'Nomor Surat Tanda Lulus': '-',
      'Tanggal Surat Tanda Lulus': '-',
    },
    'Data Orang Tua': {
      'Nama Ayah': '-',
      'Pekerjaan Ayah': '-',
      'Nama Ibu': '-',
      'Pekerjaan Ibu': '-',
      'Alamat Orangtua': '-',
      'Telepon Orangtua': '-',
    },
    'Data Wali Murid': {
      'Nama Wali Murid': '-',
      'Pekerjaan Wali Murid': '-',
      'Telepon Wali Murid': '-',
    },
  };

  DayRecord get hariIni => riwayat[dateKey(DateTime.now())] ?? DayRecord();

  void setLogin(bool v) {
    login = v;
    notifyListeners();
  }

  /// Mencatat presensi masuk, lalu pulang. Mengembalikan pesan untuk pengguna.
  String presensi() {
    final now = DateTime.now();
    final rec = riwayat.putIfAbsent(dateKey(now), () => DayRecord());
    final jam = '${two(now.hour)}:${two(now.minute)}';
    String msg;
    if (rec.masuk == null) {
      rec.masuk = jam;
      final telat = now.hour > 7 || (now.hour == 7 && now.minute > 15);
      rec.status = telat ? 'Terlambat' : 'Tepat Waktu';
      msg = 'Presensi masuk berhasil pukul $jam';
    } else if (rec.pulang == null) {
      rec.pulang = jam;
      msg = 'Presensi pulang berhasil pukul $jam';
    } else {
      msg = 'Presensi hari ini sudah lengkap';
    }
    notifyListeners();
    return msg;
  }

  void tambahIzin(IzinItem item) {
    izin.insert(0, item);
    notifyListeners();
  }

  void simpanProfil(Map<String, Map<String, String>> baru) {
    baru.forEach((sec, rows) {
      rows.forEach((k, v) => profil[sec]![k] = v.trim().isEmpty ? '-' : v.trim());
    });
    notifyListeners();
  }
}