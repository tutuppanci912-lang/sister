import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class _Jadwal {
  const _Jadwal(this.mapel, this.guru, this.jam);
  final String mapel, guru, jam;
}

const _jadwal = [
  _Jadwal('Matematika', 'Joko Santosa', '07:00 - 09:00'),
  _Jadwal('Bahasa Indonesia', 'Siti Paryati', '09:00 - 10:00'),
  _Jadwal('Olahraga', 'Tugimin', '10:00 - 11:00'),
];

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.onSelectTab});
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final s = AppState.i;
    return AnimatedBuilder(
      animation: s,
      builder: (context, _) {
        final now = DateTime.now();
        final rec = s.hariIni;
        return Container(
          color: C.bg,
          child: Stack(
            children: [
              Container(height: 260, decoration: const BoxDecoration(gradient: C.headerGradient)),
              SafeArea(
                bottom: false,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Header identitas
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.shield_rounded, color: C.teal, size: 36),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Hi,', style: TextStyle(fontSize: 14)),
                                Text(s.nama,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                                Text('${s.kelas}  |  ${s.sekolah}',
                                    style: const TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF4B6663))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    // Kartu info
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [BoxShadow(color: C.shadow, blurRadius: 22, offset: Offset(0, 8))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _info(Icons.calendar_today_outlined, '${two(now.day)}/${two(now.month)}', 'Tanggal'),
                          _info(Icons.access_time_rounded, rec.masuk ?? '--:--', 'Masuk'),
                          _info(Icons.history_toggle_off_rounded, rec.pulang ?? '--:--', 'Pulang'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Lembar putih
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _rowHeader('Presensi', () => Navigator.of(context).pushNamed('/riwayat')),
                          const SizedBox(height: 14),
                          _presensiCard(rec, now),
                          const SizedBox(height: 22),
                          const Text('Jadwal Pelajaran',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 108,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _jadwal.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (_, i) => _jadwalCard(_jadwal[i]),
                            ),
                          ),
                          const SizedBox(height: 22),
                          _rowHeader('Perizinan', () => Navigator.of(context).pushNamed('/riwayat')),
                          const SizedBox(height: 12),
                          _perizinan(context, s),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _info(IconData ic, String value, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ic, color: C.teal, size: 25),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text(label, style: const TextStyle(fontSize: 12, color: C.muted)),
            ],
          ),
        ],
      );

  Widget _rowHeader(String title, VoidCallback onAll) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          GestureDetector(
            onTap: onAll,
            child: const Text('Lihat semua',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.teal)),
          ),
        ],
      );

  Widget _presensiCard(DayRecord rec, DateTime now) {
    final tgl = '${now.day} ${bulanPendek(now.month)} ${now.year}';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x240A504C), blurRadius: 16, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          _presensiRow('Masuk', rec.masuk == null ? '--:--' : '$tgl ${rec.masuk}',
              rec.masuk == null ? 'Belum Presensi' : (rec.status ?? 'Tepat Waktu'), rec.masuk != null),
          const SizedBox(height: 16),
          _presensiRow('Pulang', rec.pulang == null ? '--:--' : '$tgl ${rec.pulang}',
              rec.pulang == null ? 'Belum Presensi' : 'Tepat Waktu', rec.pulang != null),
        ],
      ),
    );
  }

  Widget _presensiRow(String label, String sub, String status, bool done) => Row(
        children: [
          RoundAvatar(size: 44, light: !done),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                Text(sub, style: const TextStyle(fontSize: 13, color: C.muted)),
              ],
            ),
          ),
          StatusChip(status),
        ],
      );

  Widget _jadwalCard(_Jadwal j) => Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: C.tint, borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(j.mapel, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, height: 1.2)),
            const Spacer(),
            Text(j.guru, style: const TextStyle(fontSize: 13, color: C.muted)),
            const SizedBox(height: 4),
            Text(j.jam, style: const TextStyle(fontSize: 13, color: C.muted)),
          ],
        ),
      );

  Widget _perizinan(BuildContext context, AppState s) {
    final ajukan = GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/izin'),
      child: Container(
        width: 86,
        height: 86,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x1A0A504C), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.note_add_outlined, color: C.teal, size: 28),
            SizedBox(height: 6),
            Text('Ajukan Izin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: C.teal)),
          ],
        ),
      ),
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      decoration: BoxDecoration(color: C.tint2, borderRadius: BorderRadius.circular(16)),
      child: s.izin.isEmpty
          ? Center(child: ajukan)
          : Column(
              children: [
                for (final it in s.izin.take(3))
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(it.judul, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text('${it.jenis} · ${tglPendek(it.mulai)} – ${tglPendek(it.selesai)}',
                                  style: const TextStyle(fontSize: 12, color: C.muted)),
                            ],
                          ),
                        ),
                        StatusChip(it.status),
                      ],
                    ),
                  ),
                ajukan,
              ],
            ),
    );
  }
}