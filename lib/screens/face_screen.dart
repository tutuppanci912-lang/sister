import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Presensi Wajah.
/// Catatan: tampilan kamera/verifikasi wajah masih berupa prototipe (gambar).
/// Integrasi kamera nyata: gunakan package `camera` dan layanan pengenalan wajah.
class FaceScreen extends StatelessWidget {
  const FaceScreen({super.key});

  Future<void> _konfirmasi(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final ya = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0x99000000),
      builder: (ctx) => const _KonfirmasiDialog(),
    );
    if (ya == true) {
      final msg = AppState.i.presensi();
      navigator.pop();
      toastOn(messenger, msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C2120),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/latar_presensi.png', fit: BoxFit.cover),
          Container(color: const Color(0x59051918)),
          SafeArea(
            child: Column(
              children: [
                // Header
                SizedBox(
                  height: 52,
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Kembali',
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD9F4EF), size: 22),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text('Presensi Wajah',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFFD9F4EF))),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                // Kartu foto (menyusut otomatis di layar pendek)
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        width: 292,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 30, offset: Offset(0, 10))],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset('assets/images/wajah.png', width: 276, height: 392, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: SmallButton(
                                      label: 'Ambil Ulang',
                                      onPressed: () => toast(context, 'Mengambil ulang foto...')),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SmallButton(
                                      label: 'Gunakan Foto', filled: true, onPressed: () => _konfirmasi(context)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(color: const Color(0xB3061E1D), borderRadius: BorderRadius.circular(12)),
                  child: const Text('Pastikan wajah terlihat jelas dan tidak menggunakan masker / topeng.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, height: 1.45, color: Color(0xFFE6F7F4))),
                ),
                const SizedBox(height: 16),
                // Tombol kamera
                Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: C.fabGradient,
                    boxShadow: [BoxShadow(color: Color(0x59000000), blurRadius: 16, offset: Offset(0, 6))],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _konfirmasi(context),
                      child: const Icon(Icons.photo_camera_outlined, color: Colors.white, size: 30),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KonfirmasiDialog extends StatelessWidget {
  const _KonfirmasiDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wajah Terdeteksi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Color(0x290A504C), blurRadius: 12, offset: Offset(0, 3))],
              ),
              child: Row(
                children: [
                  const RoundAvatar(size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(AppState.i.nama,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Lokasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Icon(Icons.refresh_rounded, color: C.teal, size: 20),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Jl. Raya Purwandaru - Bukateja, Dusun 5, Majasari, Kec. Purbalingga, Kabupaten Purbalingga, Jawa Tengah 53382',
              style: TextStyle(fontSize: 12.5, height: 1.5, color: C.muted),
            ),
            const SizedBox(height: 14),
            const Text('Apakah Anda yakin melakukan presensi ?',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: SmallButton(label: 'Tidak', onPressed: () => Navigator.pop(context, false))),
                const SizedBox(width: 10),
                Expanded(
                    child: SmallButton(label: 'Ya', filled: true, onPressed: () => Navigator.pop(context, true))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}