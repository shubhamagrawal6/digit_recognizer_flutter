import 'dart:typed_data';
import 'dart:ui';
import 'package:digit_recognizer_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

final _canvasCulRect = Rect.fromPoints(
  Offset(0, 0),
  Offset(Constants.imageSize, Constants.imageSize),
);

final _bgPaint = Paint()..color = Colors.black;
final _whitePaint = Paint()
  ..color = Colors.white
  ..strokeCap = StrokeCap.round
  ..strokeWidth = Constants.strokeWidth;

class Recognizer {
  Future loadModel() {
    Tflite.close();
    return Tflite.loadModel(
      model: "assets/mnist.tflite",
      labels: "assets/mnist.txt",
    );
  }

  dispose() {
    Tflite.close();
  }

  Future<Uint8List?> previewImage({required List<Offset?> points}) async {
    final picture = _pointsToPicture(points: points);
    final image = await picture.toImage(
      Constants.mnistImageSize,
      Constants.mnistImageSize,
    );
    var pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  Future recognize({required List<Offset?> points}) async {
    final picture = _pointsToPicture(points: points);
    Uint8List bytes = await _imageToByteListUint8(
      pic: picture,
      size: Constants.mnistImageSize,
    );
    return _predict(bytes: bytes);
  }

  Future _predict({required Uint8List bytes}) {
    return Tflite.runModelOnBinary(binary: bytes);
  }

  Future<Uint8List> _imageToByteListUint8({
    required Picture pic,
    required int size,
  }) async {
    final img = await pic.toImage(size, size);
    final imgBytes = await img.toByteData();
    final resultBytes = Float32List(size * size);
    final buffer = Float32List.view(resultBytes.buffer);

    int index = 0;

    for (int i = 0; i < imgBytes!.lengthInBytes; i += 4) {
      final r = imgBytes.getUint8(i);
      final g = imgBytes.getUint8(i + 1);
      final b = imgBytes.getUint8(i + 2);
      buffer[index++] = (r + g + b) / 3.0 / 255.0;
    }

    return resultBytes.buffer.asUint8List();
  }

  Picture _pointsToPicture({required List<Offset?> points}) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, _canvasCulRect)
      ..scale(Constants.mnistImageSize / Constants.imageSize);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, Constants.imageSize, Constants.imageSize),
      _bgPaint,
    );

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        Offset tmp = points[i] as Offset;
        Offset tmp2 = points[i + 1] as Offset;

        canvas.drawLine(tmp, tmp2, _whitePaint);
      }
    }

    return recorder.endRecording();
  }
}
