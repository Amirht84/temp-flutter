import 'package:core/core.dart';
import 'package:flutter/material.dart';

enum PageState { home, play, manual, scenario }

class ModeViewModel extends ChangeNotifier {
  ModeViewModel(BleRepository repo)
    : _repo = repo,
      pageState = .home,
      isStopped = false,
      isRandom = false;

  final BleRepository _repo;
  PageState pageState;
  bool isStopped;
  bool isRandom;

  Modes get _mode {
    if (isStopped) return .STOP;
    switch (pageState) {
      case .home:
        return .IDLE;
      case .manual:
        return .MANUAL;
      case .play:
        return .SMART;
      case .scenario:
        return isRandom ? .RANDOM : .SEQUENCE;
    }
  }

  Future<void> pushMode() async {
    await _repo.selectMode(_mode);
  }

  void setPage(PageState page) {
    pageState = page;
    notifyListeners();
  }

  void switchStop() {
    isStopped = !isStopped;
    notifyListeners();
  }

  void switchRandom() {
    isRandom = !isRandom;
    notifyListeners();
  }
}
