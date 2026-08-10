# Testing against the real robot

This adds a second, **real** `BleService` implementation
(`FlutterBluePlusService`) alongside your existing `MockBleService`.
Same contract, so `BleRepository` doesn't change at all — you're
literally swapping one constructor argument.

## 1. Add the dependency

In your real Flutter project (not the CLI package):

```bash
flutter pub add flutter_blue_plus
```

## 2. Drop in these files

Copy into your real project, same relative paths:

```
lib/src/ble/flutter_blue_plus_service.dart   (new)
lib/debug_robot_screen.dart                  (new, temporary test harness)
lib/main_debug.dart                          (new, separate entry point)
```

`ble_constants.dart`, `ble_device.dart`, `ble_service.dart`,
`ble_repository.dart`, `robot_command.dart`, `robot_state.dart` are
your existing files, included here unchanged just so the folder is
runnable standalone if you want to sanity-check it in isolation.

## 3. Platform permissions (this is where most people get stuck)

### Android — `android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"
    android:usesPermissionFlags="neverForLocation" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH"
    android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"
    android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"
    android:maxSdkVersion="30" />
```

And in `android/app/build.gradle`, make sure `minSdkVersion` is at
least 21 (23+ recommended).

On Android 12+ you also need to request `BLUETOOTH_SCAN` /
`BLUETOOTH_CONNECT` as **runtime** permissions before scanning (a
manifest entry alone isn't enough). Easiest way is the
`permission_handler` package:

```bash
flutter pub add permission_handler
```

```dart
import 'package:permission_handler/permission_handler.dart';

await [
  Permission.bluetoothScan,
  Permission.bluetoothConnect,
].request();
```

Call that once before your first `_scan()` — e.g. at the top of
`DebugRobotScreen.initState()` or a splash screen in the real app.

### iOS — `ios/Runner/Info.plist`

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app uses Bluetooth to connect to your tennis robot.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app uses Bluetooth to connect to your tennis robot.</string>
```

## 4. Run it — on a real phone

BLE doesn't work in an emulator/simulator or on desktop — you need an
actual phone with Bluetooth, near the actual robot, powered on and
advertising:

```bash
flutter run -t lib/main_debug.dart
```

This launches *only* `DebugRobotScreen` — a throwaway harness with a
Scan button, a device list, four sliders, and Launch/Stop buttons —
so you can validate the real path before your friend's UI or the
`RobotViewModel` exist. Your real `main.dart` is untouched.

## 5. What to check, in order

1. **Scan finds your robot.** If nothing shows up: confirm the robot
   firmware is actually advertising `BleConstants.robotServiceUuid`,
   and that you granted the runtime permissions above.
2. **Connect succeeds** and the log shows `connected`. If it throws
   "Robot service ... not found", the firmware isn't exposing the
   UUID you expect, or you're connecting to the wrong device.
3. **A slider move produces a `📡 telemetry` update** roughly
   immediately. If commands seem to work but telemetry never
   arrives, the status characteristic likely isn't set up as
   *notify* on the firmware side, or the checksum in the frames it
   sends doesn't match `BleRepository._decodeState`.
4. **Launch/Stop actually engage the motors.**

## 6. Wiring it into the real app later

Once this is confirmed working, swapping into your real `main.dart`
is exactly one line — no changes to `BleRepository`,
`RobotViewModel`, models, or UI:

```dart
final bleService = FlutterBluePlusService(); // instead of MockBleService()
final repository = BleRepository(bleService: bleService);
final viewModel = RobotViewModel(repository: repository);
```

## A note on write type

`FlutterBluePlusService.writeCommand` sends `launch`/`stop` as
acknowledged writes (`withoutResponse: false`) since they're
safety-critical, and everything else (motor speed, angles)
unacknowledged for lower latency — this was the BLE protocol
discussion from earlier. If you'd rather make this explicit instead
of inferring it from the command byte, we can extend
`BleService.writeCommand` to take a `{required bool critical}`
parameter and have `BleRepository` decide per `CommandType` — happy
to make that change if you want it more visible in the interface.

## I couldn't test-run this myself

This sandbox has no Flutter SDK, no physical device, and no
Bluetooth radio, so I can't compile or exercise this code before
handing it to you. Please try it against your robot and paste back
any error — especially anything from `discoverServices()` or
`setNotifyValue()`, since those are the two calls most sensitive to
exact firmware behavior.
