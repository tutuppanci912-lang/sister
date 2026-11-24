
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../app_state.dart';
import '../services/location_service.dart';
import '../services/permission_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Presensi Wajah.
/// Alur: minta izin lokasi -> ambil lokasi -> konfirmasi -> simpan.
class FaceScreen extends StatefulWidget {
  const FaceScreen({super.key});

  @override
  State<FaceScreen> createState() => _FaceScreenState();
}

class _FaceScreenState extends State<FaceScreen> {
  IzinHasil? _izinLokasi;
  LokasiHasil? _lokasi;
  bool _memuat = true;

  bool get _siap => _lokasi != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _siapkan());
  }

  /// Meminta izin lokasi, lalu mengambil lokasi.
  Future<void> _siapkan() async {
    setState(() => _memuat = true);

    _izinLokasi = await IzinService.minta(Permission.location);

    if (_izinLokasi == IzinHasil.diberikan) {
      _lokasi = await LokasiService.ambil();
    }

    if (mounted) setState(() => _memuat = false);
  }

  Future<void> _konfirmasi() async {
    if (_lokasi == null) {
      toast(
        context,
        'Lokasi belum tersedia. Nyalakan GPS lalu coba lagi.',
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final hasil = await showDialog<LokasiHasil>(
      context: context,
      barrierColor: const Color(0x99000000),
      builder: (ctx) => _KonfirmasiDialog(awal: _lokasi!),
    );

    if (hasil == null) return;

    if (hasil.mock) {
      toastOn(
        messenger,
        'Lokasi palsu (fake GPS) terdeteksi. Presensi ditolak.',
      );
      return;
    }

    final msg = AppState.i.presensi(lokasi: hasil.teks);

    navigator.pop();
    toastOn(messenger, msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C2120),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/latar_presensi.png',
            fit: BoxFit.cover,
          ),

          Container(color: const Color(0x59051918)),

          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 52,
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Kembali',
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFFD9F4EF),
                          size: 22,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),

                      const Expanded(
                        child: Text(
                          'Presensi Wajah',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD9F4EF),
                          ),
                        ),
                      ),

                      const SizedBox(width: 48),
                    ],
                  ),
                ),

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
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66000000),
                              blurRadius: 30,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),

                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                'assets/images/wajah.png',
                                width: 276,
                                height: 392,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: SmallButton(
                                    label: 'Ambil Ulang',
                                    onPressed: () => toast(
                                      context,
                                      'Mengambil ulang foto...',
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: SmallButton(
                                    label: 'Gunakan Foto',
                                    filled: true,
                                    onPressed: _konfirmasi,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Status izin lokasi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _StatusIzin(
                    memuat: _memuat,
                    izinLokasi: _izinLokasi,
                    lokasi: _lokasi,
                    onUlangi: _siapkan,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xB3061E1D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Pastikan wajah terlihat jelas dan tidak menggunakan masker / topeng.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: Color(0xFFE6F7F4),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Opacity(
                  opacity: _siap ? 1 : .5,
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: C.fabGradient,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x59000000),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _konfirmasi,
                        child: const Icon(
                          Icons.photo_camera_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
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

/// Status lokasi. Ketuk untuk mencoba lagi / buka pengaturan.
class _StatusIzin extends StatelessWidget {
  const _StatusIzin({
    required this.memuat,
    required this.izinLokasi,
    required this.lokasi,
    required this.onUlangi,
  });

  final bool memuat;
  final IzinHasil? izinLokasi;
  final LokasiHasil? lokasi;
  final VoidCallback onUlangi;

  @override
  Widget build(BuildContext context) {
    if (memuat) {
      return const Text(
        'Memeriksa izin dan lokasi...',
        style: TextStyle(
          fontSize: 12.5,
          color: Color(0xFFE6F7F4),
        ),
      );
    }

    return _chip(
      Icons.location_on_outlined,
      _teksLokasi(),
      lokasi != null,
      izinLokasi,
    );
  }

  String _teksLokasi() {
    if (lokasi != null) {
      return 'Lokasi didapat${lokasi!.akurasiTeks}';
    }

    return switch (izinLokasi) {
      IzinHasil.diberikan =>
        'Lokasi belum didapat (nyalakan GPS)',
      IzinHasil.ditolakPermanen =>
        'Lokasi ditolak (buka pengaturan)',
      _ => 'Lokasi belum diizinkan',
    };
  }

  Widget _chip(
    IconData ic,
    String teks,
    bool ok,
    IzinHasil? izin,
  ) {
    return GestureDetector(
      onTap: () {
        if (ok) return;

        if (izin == IzinHasil.ditolakPermanen) {
          IzinService.bukaPengaturan();
        } else {
          onUlangi();
        }
      },

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xB3061E1D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ok ? C.teal3 : C.coral,
            width: 1.2,
          ),
        ),

        child: Row(
          children: [
            Icon(
              ok
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              size: 16,
              color: ok ? C.teal3 : C.coral,
            ),

            const SizedBox(width: 6),

            Expanded(
              child: Text(
                teks,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.3,
                  color: Color(0xFFE6F7F4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog konfirmasi: menampilkan nama + lokasi terbaru.
class _KonfirmasiDialog extends StatefulWidget {
  const _KonfirmasiDialog({required this.awal});

  final LokasiHasil awal;

  @override
  State<_KonfirmasiDialog> createState() =>
      _KonfirmasiDialogState();
}

class _KonfirmasiDialogState extends State<_KonfirmasiDialog> {
  late LokasiHasil _lok = widget.awal;
  bool _muat = false;

  Future<void> _muatUlang() async {
    setState(() => _muat = true);

    final baru = await LokasiService.ambil();

    if (!mounted) return;

    setState(() {
      if (baru != null) _lok = baru;
      _muat = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wajah Terdeteksi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x290A504C),
                    blurRadius: 12,
                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: Row(
                children: [
                  const RoundAvatar(size: 44),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      AppState.i.nama,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lokasi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                _muat
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : GestureDetector(
                        onTap: _muatUlang,
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: C.teal,
                          size: 20,
                        ),
                      ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              '${_lok.teks}${_lok.akurasiTeks}',
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: C.muted,
              ),
            ),

            if (_lok.mock)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Terdeteksi lokasi palsu (fake GPS).',
                  style: TextStyle(
                    fontSize: 12,
                    color: C.coral,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            const SizedBox(height: 14),

            const Text(
              'Apakah Anda yakin melakukan presensi ?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: SmallButton(
                    label: 'Tidak',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: SmallButton(
                    label: 'Ya',
                    filled: true,
                    onPressed: () => Navigator.pop(context, _lok),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
