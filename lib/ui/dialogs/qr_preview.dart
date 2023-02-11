import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPreview extends StatelessWidget {
  final String qrPreviewData;

  const QrPreview({required this.qrPreviewData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: QrImage(
        backgroundColor: Colors.white,
        data: qrPreviewData,
        version: 8,
        size: kIsWeb ? 600 : 250,
      ),
    );
  }
}
