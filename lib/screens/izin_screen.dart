import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class IzinScreen extends StatefulWidget {
  const IzinScreen({super.key});
  @override
  State<IzinScreen> createState() => _IzinScreenState();
}

class _IzinScreenState extends State<IzinScreen> {
  final _judul = TextEditingController();
  final _alasan = TextEditingController();
  final _mulaiT = TextEditingController();
  final _mulaiJ = TextEditingController();
  final _selesaiT = TextEditingController();
  final _selesaiJ = TextEditingController();
  String? _jenis;
  DateTime? _mulaiTgl, _selesaiTgl;
  TimeOfDay? _mulaiJam, _selesaiJam;
  String? _lampiran;
  String _err = '';

  static const _jenisList = ['Sakit', 'Izin', 'Dispensasi'];

  @override
  void dispose() {
    for (final c in [_judul, _alasan, _mulaiT, _mulaiJ, _selesaiT, _selesaiJ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pilihTanggal(bool mulai) async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: (mulai ? _mulaiTgl : _selesaiTgl) ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (d == null) return;
    setState(() {
      if (mulai) {
        _mulaiTgl = d;
        _mulaiT.text = tglPendek(d);
      } else {
        _selesaiTgl = d;
        _selesaiT.text = tglPendek(d);
      }
    });
  }

  Future<void> _pilihJam(bool mulai) async {
    final t = await showTimePicker(
      context: context,
      initialTime: (mulai ? _mulaiJam : _selesaiJam) ?? TimeOfDay.now(),
    );
    if (t == null) return;
    final txt = '${two(t.hour)}:${two(t.minute)}';
    setState(() {
      if (mulai) {
        _mulaiJam = t;
        _mulaiJ.text = txt;
      } else {
        _selesaiJam = t;
        _selesaiJ.text = txt;
      }
    });
  }

  DateTime _gabung(DateTime d, TimeOfDay t) => DateTime(d.year, d.month, d.day, t.hour, t.minute);

  void _submit() {
    if (_judul.text.trim().isEmpty ||
        _jenis == null ||
        _mulaiTgl == null ||
        _mulaiJam == null ||
        _selesaiTgl == null ||
        _selesaiJam == null ||
        _alasan.text.trim().isEmpty) {
      setState(() => _err = 'Semua kolom wajib diisi (lampiran boleh kosong).');
      return;
    }
    final mulai = _gabung(_mulaiTgl!, _mulaiJam!);
    final selesai = _gabung(_selesaiTgl!, _selesaiJam!);
    if (selesai.isBefore(mulai)) {
      setState(() => _err = 'Waktu selesai tidak boleh sebelum waktu mulai.');
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    AppState.i.tambahIzin(IzinItem(
      judul: _judul.text.trim(),
      jenis: _jenis!,
      mulai: mulai,
      selesai: selesai,
      alasan: _alasan.text.trim(),
      lampiran: _lampiran,
    ));
    navigator.pop();
    toastOn(messenger, 'Pengajuan izin terkirim (Menunggu)');
  }

  InputDecoration _dec(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: C.muted, fontSize: 14),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCFE0DC))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: C.teal, width: 2)),
      );

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF3D5250))),
      );

  Widget _pilihan(TextEditingController c, String hint, IconData ic, VoidCallback onTap) => TextField(
        controller: c,
        readOnly: true,
        onTap: onTap,
        decoration: _dec(hint, suffix: Icon(ic, color: C.teal, size: 22)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: pageBar(context, 'Buat Izin'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Masukkan data perizinan dengan sebenar-benarnya',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
            _label('Judul'),
            TextField(controller: _judul, decoration: _dec('Masukkan Judul')),
            _label('Jenis Izin'),
            DropdownButtonFormField<String>(
              value: _jenis,
              isExpanded: true,
              decoration: _dec('Pilih Jenis Izin'),
              hint: const Text('Pilih Jenis Izin', style: TextStyle(color: C.muted, fontSize: 14)),
              items: [for (final j in _jenisList) DropdownMenuItem(value: j, child: Text(j))],
              onChanged: (v) => setState(() => _jenis = v),
            ),
            _label('Mulai Izin'),
            Row(children: [
              Expanded(flex: 145, child: _pilihan(_mulaiT, 'Pilih tanggal', Icons.calendar_month_outlined, () => _pilihTanggal(true))),
              const SizedBox(width: 10),
              Expanded(flex: 100, child: _pilihan(_mulaiJ, 'Pilih Jam', Icons.access_time_rounded, () => _pilihJam(true))),
            ]),
            _label('Selesai Izin'),
            Row(children: [
              Expanded(flex: 145, child: _pilihan(_selesaiT, 'Pilih tanggal', Icons.calendar_month_outlined, () => _pilihTanggal(false))),
              const SizedBox(width: 10),
              Expanded(flex: 100, child: _pilihan(_selesaiJ, 'Pilih Jam', Icons.access_time_rounded, () => _pilihJam(false))),
            ]),
            _label('Alasan'),
            TextField(
              controller: _alasan,
              minLines: 5,
              maxLines: 5,
              decoration: _dec('Tuliskan alasan izin secara detail...'),
            ),
            _label('Lampiran Izin'),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                // Prototipe: pilih berkas memerlukan package image_picker / file_picker.
                setState(() => _lampiran = 'lampiran.jpg');
                toast(context, 'Lampiran contoh ditambahkan (prototipe)');
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFB5C9C5), width: 1.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_lampiran ?? 'Tambah lampiran (foto)',
                          style: TextStyle(fontSize: 14, color: _lampiran == null ? C.muted : C.ink)),
                    ),
                    const Icon(Icons.attach_file_rounded, color: C.muted, size: 22),
                  ],
                ),
              ),
            ),
            if (_err.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(_err, style: const TextStyle(color: C.coral, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
            const SizedBox(height: 22),
            PrimaryButton(label: 'Submit', onPressed: _submit, height: 54),
          ],
        ),
      ),
    );
  }
}