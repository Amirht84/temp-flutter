import 'dart:async';

import 'package:flutter/material.dart';
import 'package:core/core.dart';

class AppShellViewModel extends ChangeNotifier {

    AppShellViewModel(BleRepository repo) : _repo = repo, isScanning = false, isConnected = false;

    final BleRepository _repo;
    StreamSubscription<BleDevice>? _connectionSubscription;

    bool isConnected;
    bool isScanning;
    bool isConnecting;

    Future<void> connect() async {
        isScanning = true;
        notifyListeners();
        final BleDevice? dev = await _repo.scanForRobots();
        isScanning = false;
        if(dev != null) {
            isConnecting = true;
            await _repo.connectToRobot(dev);
            _repo.connectionStream.listen((connState){
                if(isConnecting && connState){
                    isConnected = true;
                    isConnecting = false;
                } else if(!isConnecting && !connState && isConnected){
                    isConnected = false;
                } else {
                    throw StateError('Unexpected state');
                }
                notifyListeners();
            });
        }
        notifyListeners();
    }

    void stopScan() {
        _repo.stopScan();

        isScanning = false;
        notifyListeners();
    }


    @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }
}