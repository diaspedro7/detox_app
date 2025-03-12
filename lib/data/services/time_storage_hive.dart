import 'package:hive_flutter/hive_flutter.dart';

final boxTempo = Hive.box("obterTempoBackground");

// the time that already passed
int getTempoSalvo() {
  return boxTempo.get('tempoSalvoKey', defaultValue: 0);
}

void setTempoSalvo(int tempo) {
  boxTempo.put('tempoSalvoKey', tempo);
}

// time to usage the apps
int getIntervalTime() {
  return boxTempo.get('intervalTimeKey', defaultValue: 600);
}

void setIntervalTime(int tempo) {
  boxTempo.put('intervalTimeKey', tempo);
}

//added time to usage the apps to give continue
void setTempoDeIntervaloSomado(int valor) async {
  await boxTempo.put('tempoDeIntervaloSomadoKey', valor);
}

int getTempoDeIntervaloSomado() {
  return boxTempo.get('tempoDeIntervaloSomadoKey', defaultValue: 10);
}

// Interval time to add
int getTempoTemporizador() {
  return boxTempo.get('temporizadorKey', defaultValue: 10);
}

void setTempoTemporizador(int tempo) {
  boxTempo.put('temporizadorKey', tempo);
}

// --- Saved the current usage time of the monitored apps ---

void setMapAppsCurrentTime(Map<String, int> appTimeMap) {
  boxTempo.put('mapAppsCurrentTimeKey', appTimeMap);
}

Map<String, int> getMapAppsCurrentTime() {
  return Map<String, int>.from(
      boxTempo.get('mapAppsCurrentTimeKey', defaultValue: {}));
}

// -------------X----------------

// --- Save a map of the monitored apps package name and if they are in acrescim mode ---

void setMapAppAcrescimBool(
    Map<String, bool> mapPackageNameAndAcrescimActivaded) {
  boxTempo.put("mapAppAcrescimBoolKey", mapPackageNameAndAcrescimActivaded);
}

Map<String, bool> getMapAppAcrescimBool() {
  return Map<String, bool>.from(
      boxTempo.get("mapAppAcrescimBoolKey", defaultValue: <String, bool>{}));
}

// -------------X----------------

// --- Save a map of monitored apps package name and the acrescim time

void setMapAppTimeAcrescimLimit(
    Map<String, int> mapPackageNameAndTimeAcrescim) {
  boxTempo.put("mapAppTimeAcrescimKey", mapPackageNameAndTimeAcrescim);
}

Map<String, int> getMapAppTimeAcrescimLimit() {
  return Map<String, int>.from(
      boxTempo.get("mapAppTimeAcrescimKey", defaultValue: <String, int>{}));
}

// -------------X----------------

void setMapAppAcrescimCurrentTime(Map<String, int> mapAppAcrescimCurrentTime) {
  boxTempo.put("mapAppAcrescimCurrentTimeKey", mapAppAcrescimCurrentTime);
}

Map<String, int> getMapAppAcrescimCurrentTime() {
  return Map<String, int>.from(boxTempo
      .get("mapAppAcrescimCurrentTimeKey", defaultValue: <String, int>{}));
}
