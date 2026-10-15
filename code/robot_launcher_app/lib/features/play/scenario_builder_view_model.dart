import 'package:flutter/foundation.dart';
import 'package:robot_launcher_app/features/play/widgets/spin_card.dart';

class ScenarioShot {
  ScenarioShot({this.zone = 1, this.spin = .flat, this.delay = 2});
  int zone;
  SpinType spin;
  int delay;
}

class ScenarioBuilderViewModel extends ChangeNotifier {
  ScenarioBuilderViewModel() {
    _shotIndex = 0;
    _shots = [ScenarioShot()];
  }
  late List<ScenarioShot> _shots;
  late int _shotIndex;
  void addNewShot() {
    _shotIndex += 1;
    _shots.insert(_shotIndex, ScenarioShot());
    notifyListeners();
  }

  void addNewShotToEnd() {
    _shots.add(ScenarioShot());
    _shotIndex = _shots.length - 1;
    notifyListeners();
  }

  void changeIndex(int index) {
    _shotIndex = index;
    notifyListeners();
  }

  void editShot({int? zone, SpinType? spin, int? delay}) {
    if (zone != null) _shots[shotIndex].zone = zone;
    if (spin != null) _shots[shotIndex].spin = spin;
    if (delay != null) _shots[shotIndex].delay = delay;
  }

  int get shotIndex => _shotIndex;
  ScenarioShot get shot => _shots[_shotIndex];
  List<ScenarioShot> get shots => List.unmodifiable(_shots);
  int get shotsCount => _shots.length;
}
