import 'package:permission_handler/permission_handler.dart';

/// Hasil permintaan izin, disederhanakan agar mudah dipakai di layar.
enum IzinHasil { diberikan, ditolak, ditolakPermanen }

/// Layanan izin aplikasi (memakai package permission_handler).
class IzinService {
  /// Meminta izin [izin] (mis. Permission.camera). Bila sudah diberikan,
  /// tidak menampilkan dialog lagi.
  static Future<IzinHasil> minta(Permission izin) async {
    var status = await izin.status;
    if (status.isGranted) return IzinHasil.diberikan;

    // Di Android, hanya hasil request() yang bisa bernilai permanentlyDenied.
    status = await izin.request();
    if (status.isGranted) return IzinHasil.diberikan;
    if (status.isPermanentlyDenied) return IzinHasil.ditolakPermanen;
    return IzinHasil.ditolak;
  }

  /// Membuka halaman pengaturan aplikasi (untuk izin yang ditolak permanen).
  static Future<bool> bukaPengaturan() => openAppSettings();
}