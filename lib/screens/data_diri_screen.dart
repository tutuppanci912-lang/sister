import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class DataDiriScreen extends StatefulWidget {
  const DataDiriScreen({super.key});
  @override
  State<DataDiriScreen> createState() => _DataDiriScreenState();
}

class _DataDiriScreenState extends State<DataDiriScreen> {
  bool _edit = false;
  // controller per "bagian|label"
  final Map<String, TextEditingController> _ctrl = {};

  @override
  void dispose() {
    for (final c in _ctrl.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _c(String sec, String key) => _ctrl.putIfAbsent(
      '$sec|$key', () => TextEditingController(text: AppState.i.profil[sec]![key] == '-' ? '' : AppState.i.profil[sec]![key]));

  void _toggle() {
    if (_edit) {
      final baru = <String, Map<String, String>>{};
      AppState.i.profil.forEach((sec, rows) {
        baru[sec] = {for (final k in rows.keys) k: _c(sec, k).text};
      });
      AppState.i.simpanProfil(baru);
      toast(context, 'Data diri disimpan');
    } else {
      // muat ulang nilai ke controller
      AppState.i.profil.forEach((sec, rows) {
        rows.forEach((k, v) => _c(sec, k).text = v == '-' ? '' : v);
      });
    }
    setState(() => _edit = !_edit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: pageBar(context, 'Data Diri', actions: [
        IconButton(
          tooltip: _edit ? 'Simpan' : 'Ubah data diri',
          icon: Icon(_edit ? Icons.check_rounded : Icons.edit_note_rounded, color: C.teal, size: 26),
          onPressed: _toggle,
        ),
      ]),
      body: AnimatedBuilder(
        animation: AppState.i,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          children: [
            for (final sec in AppState.i.profil.keys) ...[
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 8),
                child: Text(sec, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              ),
              for (final e in AppState.i.profil[sec]!.entries) _row(sec, e.key, e.value),
              const Divider(color: C.line, height: 28),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String sec, String key, String value) {
    if (_edit) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: _c(sec, key),
          decoration: InputDecoration(
            labelText: key,
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.teal, width: 2)),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(key, style: const TextStyle(fontSize: 13.5, color: C.muted)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}