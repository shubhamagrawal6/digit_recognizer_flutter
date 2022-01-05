import 'package:digit_recognizer_flutter/models/prediction.dart';
import 'package:flutter/material.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;

  PredictionWidget({required this.predictions});

  Widget _numberWidget({
    required int num,
    required Prediction? prediction,
  }) {
    return Column(
      children: [
        Text(
          "$num",
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.red.withOpacity(
                    (prediction.confidence * 2).clamp(0, 1).toDouble(),
                  ),
          ),
        ),
        Text(
          "${prediction == null ? '' : prediction.confidence.toStringAsFixed(3)}",
          style: TextStyle(
            fontSize: 12,
          ),
        )
      ],
    );
  }

  List<dynamic>? getPredictionStyles({required List<Prediction> prediction}) {
    List<dynamic> data = [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ];

    predictions.forEach(
      (prediction) {
        data[prediction.index] = prediction;
      },
    );

    return data;
  }

  @override
  Widget build(BuildContext context) {
    var styles = getPredictionStyles(prediction: this.predictions);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < 5; i++)
              _numberWidget(num: i, prediction: styles![i]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 5; i < 10; i++)
              _numberWidget(num: i, prediction: styles![i]),
          ],
        ),
      ],
    );
  }
}
