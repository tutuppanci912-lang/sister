import 'package:flutter/material.dart';
import '../theme.dart';

/// Logo (gambar dari assets).
class LogoImage extends StatelessWidget {
  const LogoImage({super.key, this.size = 104});
  final double size;
  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/images/logo.png', width: size, height: size);
}

/// Teks merek "Hadir" + "ku" berwarna coral, memakai RichText.
class BrandText extends StatelessWidget {
  const BrandText({super.key, this.size = 34});
  final double size;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
            fontSize: size, fontWeight: FontWeight.w800, color: C.inkTeal),
        children: const [
          TextSpan(text: 'Hadir'),
          TextSpan(text: 'ku', style: TextStyle(color: C.coral)),
        ],
      ),
    );
  }
}

/// AppBar halaman dalam (judul tengah, panah kembali teal).
PreferredSizeWidget pageBar(BuildContext context, String title,
    {List<Widget>? actions, bool back = true}) {
  return AppBar(
    flexibleSpace: Container(decoration: const BoxDecoration(gradient: C.headerGradient)),
    automaticallyImplyLeading: false,
    leading: back
        ? IconButton(
            tooltip: 'Kembali',
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.teal, size: 22),
            onPressed: () => Navigator.of(context).maybePop(),
          )
        : null,
    title: Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: C.ink)),
    actions: actions,
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.height = 56});
  final String label;
  final VoidCallback onPressed;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: C.buttonGradient,
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: const [
          BoxShadow(color: Color(0x5908635F), blurRadius: 18, offset: Offset(0, 8))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(height / 2),
          onTap: onPressed,
          child: Center(
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

/// Tombol kecil (Tidak/Ya, Ambil Ulang/Gunakan Foto). filled=true -> teal penuh.
class SmallButton extends StatelessWidget {
  const SmallButton({super.key, required this.label, required this.onPressed, this.filled = false});
  final String label;
  final VoidCallback onPressed;
  final bool filled;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: filled
          ? FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: C.teal, shape: const StadiumBorder(), padding: EdgeInsets.zero),
              onPressed: onPressed,
              child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)))
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                  foregroundColor: C.teal,
                  side: const BorderSide(color: C.teal, width: 1.5),
                  shape: const StadiumBorder(),
                  padding: EdgeInsets.zero),
              onPressed: onPressed,
              child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
    );
  }
}

/// Lencana status: Tepat Waktu / Terlambat / Belum Presensi / Menunggu.
class StatusChip extends StatelessWidget {
  const StatusChip(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    Color fg, bg;
    BoxBorder? border;
    switch (text) {
      case 'Tepat Waktu':
      case 'Tepat':
        fg = Colors.white; bg = C.green; border = null;
        break;
      case 'Terlambat':
        fg = Colors.white; bg = C.coral; border = null;
        break;
      case 'Menunggu':
        fg = const Color(0xFF8A5A00); bg = const Color(0xFFFFF1CC); border = null;
        break;
      default:
        fg = C.teal; bg = Colors.white; border = Border.all(color: C.teal, width: 1.5);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: bg, border: border, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

class RoundAvatar extends StatelessWidget {
  const RoundAvatar({super.key, this.size = 44, this.light = false});
  final double size;
  final bool light;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: light
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7DDCCB), C.teal]),
        color: light ? C.line : null,
      ),
      child: Icon(Icons.person_rounded, color: light ? const Color(0xFF7C908E) : Colors.white, size: size * 0.6),
    );
  }
}

void toast(BuildContext context, String msg) => toastOn(ScaffoldMessenger.of(context), msg);

void toastOn(ScaffoldMessengerState m, String msg) {
  m
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: C.ink,
    ));
}