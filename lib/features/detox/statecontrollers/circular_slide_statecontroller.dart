import 'package:detox_app/data/services/time_storage_hive.dart';
import 'package:flutter/material.dart';

class CircularSlideStateController extends ChangeNotifier {
  double radialValue = 10.0;

  setRadialValue(double value) {
    radialValue = value;
    notifyListeners();
  }

  onValueChanged(double value) {
    debugPrint("Value: ${value.ceil()}");
    //if try to pass from 60 to 0 it denies
    if ((radialValue.ceil() <= 60 && radialValue.ceil() >= 50) &&
        (value.ceil() >= 0 && value.ceil() <= 20)) {
      debugPrint("Denies1");
      setRadialValue(60.0);
    }
    //if try to pass from 0 to 60 it also denies
    else if ((radialValue.ceil() >= 0 && radialValue.ceil() <= 10) &&
        (value.ceil() <= 61 && value.ceil() >= 40)) {
      debugPrint("Denies2");

      setRadialValue(0.0);
    } else {
      radialValue = value;
    }

    notifyListeners();
    setIntervalTime(radialValue.ceil());
  }
}
