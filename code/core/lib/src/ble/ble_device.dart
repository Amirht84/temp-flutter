// ============================================================
// FILE: lib/src/ble/ble_device.dart
// Plain data class that describes a discovered BLE device.
// Kept framework-agnostic so it can be serialised / compared
// easily in tests.
// ============================================================

/// Represents a discovered Bluetooth Low Energy device.
class BleDevice {
  const BleDevice({required this.id, required this.name, required this.rssi});

  /// Platform-level device identifier (address on Android,
  /// UUID string on iOS/macOS).
  final String id;

  /// Advertised device name (may be empty).
  final String name;

  /// Received signal-strength indicator in dBm.
  final int rssi;

  BleDevice copyWith({String? id, String? name, int? rssi}) => BleDevice(
    id: id ?? this.id,
    name: name ?? this.name,
    rssi: rssi ?? this.rssi,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BleDevice && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BleDevice(id: $id, name: $name, rssi: $rssi)';
}
