import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  bool _isTorchOn = false;
  bool _isScanning = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? _lastScannedCode;
  DateTime? _lastScanTime;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _startScanner();
  }

  void _startScanner() {
    if (!controller.isStarting) {
      controller.start().then((_) {
        if (mounted) setState(() => _isScanning = true);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(Barcode barcode) async {
    final now = DateTime.now();
    if (!_isScanning ||
        barcode.rawValue == null ||
        barcode.rawValue == _lastScannedCode ||
        (_lastScanTime != null && now.difference(_lastScanTime!) < const Duration(seconds: 1))) {
      return;
    }

    setState(() {
      _isScanning = false;
      _lastScannedCode = barcode.rawValue;
      _lastScanTime = now;
    });

    await controller.stop();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanned'),
        content: Text(barcode.rawValue!),
        actions: [
          TextButton(onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (mounted) {
      setState(() => _isScanning = true);
      _startScanner();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Scanner', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_off : Icons.flash_on,
              color: Colors.white,
            ),
            onPressed: () async {
              try {
                // Toggle torch and wait for completion
                await controller.toggleTorch();

                // Update state only after successful toggle
                if (mounted) {
                  setState(() {
                    _isTorchOn = !_isTorchOn;
                  });
                }
              } catch (e) {
                debugPrint('Error toggling torch: $e');
                // Optionally show error to user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to toggle flash: ${e.toString()}')),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Black background
          Container(color: Colors.black),

          // Camera preview clipped to frame
          if (_isScanning)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: MobileScanner(
                    controller: controller,
                    onDetect: (capture) {
                      final barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        _handleBarcode(barcodes.first);
                      }
                    },
                  ),
                ),
              ),
            ),

          // Frame border
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Scanning line animation
          if (_isScanning)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Center(
                  child: Transform.translate(
                    offset: Offset(0, 250 * _animation.value - 125),
                    child: Container(
                      width: 240,
                      height: 2,
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),

          // Instruction text
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Align QR code within frame',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  _isScanning ? 'Scanning...' : 'Scan paused',
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}