import 'package:detox_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CircularSlide extends StatelessWidget {
  const CircularSlide({
    super.key,
    required this.controller,
  });

  // ignore: prefer_typing_uninitialized_variables
  final controller;
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0.0,
          maximum: 60.0,
          startAngle: 0.0,
          endAngle: 360.0,
          showLabels: false,
          labelsPosition: ElementsPosition.inside,
          showTicks: false,
          radiusFactor: 0.8,
          axisLineStyle: const AxisLineStyle(
            cornerStyle: CornerStyle.bothCurve,
          ),
          pointers: [
            RangePointer(
              value: controller.radialValue,
              cornerStyle: CornerStyle.bothCurve,
              width: 12,
              sizeUnit: GaugeSizeUnit.logicalPixel,
              color: TColors.primary,
            ),
            MarkerPointer(
              value: controller.radialValue,
              enableDragging: true,
              onValueChanged: (value) => controller.onValueChanged(value),
              markerHeight: 40.0,
              markerWidth: 40.0,
              markerType: MarkerType.circle,
              color: TColors.white,
              // borderWidth: 1.0,
              // borderColor: TColors.grey,
            ),
          ],
          annotations: [
            GaugeAnnotation(
                angle: 90,
                axisValue: 5.0,
                positionFactor: 0.1,
                widget: Text(
                  "${controller.radialValue.ceil()} min",
                  style: Theme.of(context).textTheme.headlineMedium,
                ))
          ],
        ),
      ],
    );
  }
}
