import 'package:digit_recognizer_flutter/constants.dart';
import 'package:digit_recognizer_flutter/screens/drawing_painter.dart';
import 'package:digit_recognizer_flutter/services/recognizer.dart';
import 'package:flutter/material.dart';

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _recognizer = Recognizer();
  final List<Offset?> _points = [];

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
              ],
            ),
            Container(
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
                },
                child: CustomPaint(
                  painter: DrawingPainter(points: _points),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _initModel() async {
    var res = await _recognizer.loadModel();
    print(res);
  }
}
