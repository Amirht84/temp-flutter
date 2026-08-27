import 'package:flutter/material.dart';
import 'package:core/core.dart';

class ManualViewModel extends ChangeNotifier {
  ManualViewModel(BleRepository repo) : _repo = repo;
  int _topRpm = 0;
  int _bottomRpm = 0;
  double _verticAngle = 0;
  double _horizonAngle = 0;
  double _xPos = 0;
  double _yPos = 0;

  bool pendingTopRpm = false;
  bool pendingBottomRpm = false;
  bool pendingVerticAngle = false;
  bool pendingHorizonAngle = false;
  bool pendingLaunch = false;
  bool pendingJoystick = false;

  final BleRepository _repo;
  Future<void> launch() async {
    pendingLaunch = true;
    notifyListeners();
    await _repo.shoot();
    pendingLaunch = false;
    notifyListeners();
  }

  Future<void> setUpMotor(int rpm) async {
    _topRpm = rpm;
    pendingTopRpm = true;
    notifyListeners();
    await _repo.setRpm(_topRpm, _bottomRpm);
    pendingTopRpm = false;
    notifyListeners();
  }

  Future<void> setDownMotor(int rpm) async {
    _bottomRpm = rpm;
    pendingBottomRpm = true;
    notifyListeners();
    await _repo.setRpm(_topRpm, _bottomRpm);
    pendingBottomRpm = false;
    notifyListeners();
  }

  Future<void> setVerticAngle(double angle) async {
    _verticAngle = angle;
    pendingVerticAngle = true;
    await _repo.setAngleV(_verticAngle);
    pendingVerticAngle = false;
    notifyListeners();
  }

  Future<void> setHorizonAngle(double angle) async {
    _horizonAngle = angle;
    pendingHorizonAngle = true;
    notifyListeners();
    await _repo.setAngleH(angleH: _horizonAngle);
    pendingHorizonAngle = false;
    notifyListeners();
  }

  Future<void> setJoystick(double x, double y) async {
    _xPos = x;
    _yPos = y;
    pendingJoystick = true;
    notifyListeners();
    await _repo.joystick(_xPos, _yPos);
    pendingJoystick = false;
    notifyListeners();
  }
}
