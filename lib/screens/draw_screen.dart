import 'dart:typed_data';

import 'package:digit_recognizer_flutter/constants.dart';
import 'package:digit_recognizer_flutter/models/prediction.dart';
import 'package:digit_recognizer_flutter/screens/drawing_painter.dart';
import 'package:digit_recognizer_flutter/screens/prediction_widget.dart';
import 'package:digit_recognizer_flutter/services/recognizer.dart';
import 'package:flutter/material.dart';

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _recognizer = Recognizer();
  final List<Offset?> _points = [];
  List<Prediction> _prediction = [];
  bool initialize = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Digit Recognizer")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _points.clear();
            _prediction.clear();
          });
        },
        child: Icon(Icons.clear),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "MNIST Handwritten Digits",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "The digits have been size-normalized and centered in a fixed image (28 x 28)",
                        ),
                      ],
                    ),
                  ),
                ),
                _mnistPreviewImage(),
              ],
            ),
            SizedBox(height: 10),
            _drawCanvasWidget(),
            SizedBox(height: 10),
            PredictionWidget(
              predictions: _prediction,
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawCanvasWidget() {
    return Container(
      width: Constants.canvasSize + Constants.borderSize * 2,
      height: Constants.canvasSize + Constants.borderSize * 2,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: Constants.borderSize,
        ),
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset _localPostition = details.localPosition;
          if (_localPostition.dx >= 0 &&
              _localPostition.dx <= Constants.canvasSize &&
              _localPostition.dy >= 0 &&
              _localPostition.dy <= Constants.canvasSize) {
            setState(() {
              _points.add(_localPostition);
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
          _recognize();
        },
        child: CustomPaint(
          painter: DrawingPainter(points: _points),
        ),
      ),
    );
  }

  Widget _mnistPreviewImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.black,
      child: FutureBuilder(
        future: _previewImage(),
        builder: (BuildContext _, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            Uint8List tmp = snapshot.data as Uint8List;
            return Image.memory(
              tmp,
              fit: BoxFit.fill,
            );
          } else {
            return Center(child: Text("Error"));
          }
        },
      ),
    );
  }

  void _initModel() async {
    var res = await _recognizer.loadModel();
    print(res);
  }

  Future<Uint8List?> _previewImage() async {
    return await _recognizer.previewImage(points: _points);
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(points: _points);
    print(pred);
    setState(() {
      _prediction =
          pred.map((json) => Prediction.fromJson(json: json)).toList();
    });
  }
}
