import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';

class CbtTab extends StatelessWidget {
  const CbtTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: pageBar(context, 'CBT', back: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/ilustrasi_cbt.png', width: 280),
              const SizedBox(height: 18),
              const Text('CBT Segera Hadir!',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Fitur CBT sedang kami siapkan. Tunggu sebentar, ya!',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: C.muted)),
            ],
          ),
        ),
      ),
    );
  }
}