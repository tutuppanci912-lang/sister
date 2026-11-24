// Package `location` dan `permission_handler` sama-sama punya PermissionStatus,
// jadi `location` diimpor dengan awalan `loc` agar tidak bentrok.
import 'package:location/location.dart' as loc;

/// Hasil deteksi lokasi.
class LokasiHasil {
  const LokasiHasil({
    required this.lat,
    required this.lng,
    this.akurasi,
    this.mock = false,
  });

  final double lat, lng;
  final double? akurasi; // meter
  final bool mock; // true bila lokasi palsu (fake GPS)

  String get teks => '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';
  String get akurasiTeks =>
      akurasi == null ? '' : ' (akurasi ±${akurasi!.round()} m)';
}

/// Layanan deteksi lokasi (memakai package location).
class LokasiService {
  static final loc.Location _lokasi = loc.Location();

  /// Mengambil lokasi sekarang. Mengembalikan null bila GPS mati dan tidak
  /// dinyalakan pengguna, atau lokasi gagal didapat.
  /// Izin lokasi harus sudah diberikan lebih dulu (lihat IzinService).
  static Future<LokasiHasil?> ambil() async {
    try {
      // 1) Layanan GPS di HP harus menyala.
      var aktif = await _lokasi.serviceEnabled();
      if (!aktif) {
        aktif = await _lokasi.requestService(); // munculkan dialog "nyalakan GPS"
        if (!aktif) return null;
      }
      // 2) Ambil koordinat satu kali (maksimal 15 detik).
      final data = await _lokasi.getLocation().timeout(const Duration(seconds: 15));
      if (data.latitude == null || data.longitude == null) return null;
      return LokasiHasil(
        lat: data.latitude!,
        lng: data.longitude!,
        akurasi: data.accuracy,
        mock: data.isMock ?? false,
      );
    } catch (_) {
      return null;
    }
  }
}