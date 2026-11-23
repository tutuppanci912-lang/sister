import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nis = TextEditingController();
  final _pass = TextEditingController();
  bool _hide = true;
  String _err = '';

  @override
  void dispose() {
    _nis.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _login() {
    if (_nis.text.trim().isEmpty || _pass.text.isEmpty) {
      setState(() => _err = 'NIS/Username dan password wajib diisi.');
      return;
    }
    // DEMO: terima semua isian. Ganti dengan pemanggilan API autentikasi.
    setState(() => _err = '');
    AppState.i.setLogin(true);
    Navigator.of(context).pushReplacementNamed('/main');
  }

  InputDecoration _dec(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: C.muted, fontSize: 15),
        filled: true,
        fillColor: C.field,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 19),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: C.teal, width: 2)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white, Color(0xFFF0F8F6)],
              stops: [0, .55, 1]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 60, 12, 24),
            child: Column(
              children: [
                const LogoImage(size: 104),
                const SizedBox(height: 6),
                const BrandText(size: 34),
                const SizedBox(height: 6),
                const Text('Sistem Informasi Sekolah Terintegrasi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: C.muted)),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 26, 24, 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: C.line),
                    boxShadow: const [BoxShadow(color: Color(0x1F0A504C), blurRadius: 36, offset: Offset(0, 14))],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nis,
                        textInputAction: TextInputAction.next,
                        decoration: _dec('Masukkan NIS atau Username'),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _pass,
                        obscureText: _hide,
                        onSubmitted: (_) => _login(),
                        decoration: _dec(
                          'Masukkan Password',
                          suffix: IconButton(
                            tooltip: 'Tampilkan password',
                            icon: Icon(_hide ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: const Color(0xFF44605D)),
                            onPressed: () => setState(() => _hide = !_hide),
                          ),
                        ),
                      ),
                      if (_err.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_err,
                              style: const TextStyle(color: C.coral, fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ],
                      const SizedBox(height: 24),
                      PrimaryButton(label: 'Login', onPressed: _login, height: 58),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}