import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacementNamed(AppState.i.login ? '/main' : '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFEEF7F5)]),
        ),
        child: Stack(
          children: [
            Positioned(left: -120, top: -120, child: _blob(340, const Color(0x120B7F78))),
            Positioned(right: -140, bottom: -100, child: _blob(420, const Color(0x0F0B7F78))),
            Positioned(right: 50, top: 140, child: _blob(90, const Color(0x29FFC24D))),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  LogoImage(size: 140),
                  SizedBox(height: 14),
                  BrandText(size: 42),
                  SizedBox(height: 6),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Sistem Informasi Sekolah Terintegrasi',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: C.muted),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _Dot(C.teal),
                  SizedBox(width: 10),
                  _Dot(Color(0x730B7F78)),
                  SizedBox(width: 10),
                  _Dot(Color(0x330B7F78)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob(double s, Color c) =>
      Container(width: s, height: s, decoration: BoxDecoration(shape: BoxShape.circle, color: c));
}

class _Dot extends StatelessWidget {
  const _Dot(this.color);
  final Color color;
  @override
  Widget build(BuildContext context) =>
      Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}