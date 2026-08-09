// ============================================================
// FILE: lib/core.dart
// The public-facing barrel — consumers only import this file.
// ============================================================

library core;

// BLE layer
export 'src/ble/ble_constants.dart';
export 'src/ble/ble_device.dart';
export 'src/ble/ble_repository.dart';
export 'src/ble/ble_service.dart';

// Models
export 'src/models/robot_command.dart';
export 'src/models/robot_state.dart';

// ViewModels
export 'src/viewmodels/robot_viewmodel.dart';
