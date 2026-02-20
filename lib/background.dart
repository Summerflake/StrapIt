import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class GlobalBackground extends StatelessWidget {
  const GlobalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white),
        const _BlobBackground(),
        // The Mask (Frosted Glass Effect)
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.white.withOpacity(0.4)),
          ),
        ),
      ],
    );
  }
}

class _BlobBackground extends StatefulWidget {
  const _BlobBackground();

  @override
  State<_BlobBackground> createState() => _BlobBackgroundState();
}

class _BlobBackgroundState extends State<_BlobBackground> {
  Alignment _align1 = Alignment.topLeft;
  Alignment _align2 = Alignment.bottomRight;
  Alignment _align3 = Alignment.topRight;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _align1 = _randomAlignment();
          _align2 = _randomAlignment();
          _align3 = _randomAlignment();
        });
      }
    });
  }

  Alignment _randomAlignment() {
    final Random random = Random();
    return Alignment(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBlob(_align1, Colors.blueAccent.withOpacity(0.15), 500),
        _buildBlob(_align2, Colors.purpleAccent.withOpacity(0.15), 400),
        _buildBlob(_align3, Colors.cyanAccent.withOpacity(0.15), 300),
      ],
    );
  }

  Widget _buildBlob(Alignment alignment, Color color, double size) {
    return AnimatedAlign(
      duration: const Duration(seconds: 5),
      curve: Curves.easeInOutSine,
      alignment: alignment,
      child: Container(
        width: size, 
        height: size, 
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}