import 'package:hive_flutter/hive_flutter.dart';

final boxTempo = Hive.box("obterTempoBackground");

int getTempoSalvo() {
  return boxTempo.get('tempoSalvoKey', defaultValue: 0);
}

void setTempoSalvo(int tempo) {
  boxTempo.put('tempoSalvoKey', tempo);
}

void setTempoDeIntervaloSomado(int valor) async {
  await boxTempo.put('tempoDeIntervaloKey', valor);
}

int getTempoDeIntervaloSomado() {
  return boxTempo.get('tempoDeIntervaloKey', defaultValue: 10);
}

int getTempoTemporizador() {
  return boxTempo.get('temporizadorKey', defaultValue: 10);
}

void setTempoTemporizador(int tempo) {
  boxTempo.put('temporizadorKey', tempo);
}
