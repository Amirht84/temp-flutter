# Testing against the real robot

This adds a second, **real** `BleService` implementation
(`FlutterBluePlusService`) alongside your existing `MockBleService`.
Same contract, so `BleRepository` doesn't change at all — you're
literally swapping one constructor argument.

There are two harnesses that use it:

| File | What it is | Where it works |
|------|------------|-----------------|
| `test/real_robot_cli.dart` | Terminal CLI — same commands as `core_test.dart` (`scan`, `connect`, `rpm`, ...), typed into your terminal | **Desktop only** (Linux/macOS/Windows, via `flutter_blue_plus` 2.x — see below). Won't accept input on Android/iOS. |
| `test/main_debug.dart` + `test/debug_robot_screen.dart` | Throwaway Flutter UI with a Scan button, device list, sliders, Launch/Stop | Any platform, including phones |

If you're on a laptop with Bluetooth (or a Linux/macOS box) near the
robot, `real_robot_cli.dart` is the fastest way to poke at it. If your
robot is only reachable from a phone, use the UI harness instead —
`flutter run` does **not** forward your terminal's stdin into an
app process running on a physical Android/iOS device, so a
terminal-driven CLI can't accept input there.

## 0. Run the real CLI test

From `code/core`, with a device attached/selected that has a real
Bluetooth radio:

```bash
flutter pub get
flutter run -d linux  -t test/real_robot_cli.dart    # or: macos
flutter run -d windows -t test/real_robot_cli.dart   # after step 0b below
```

You'll get the exact same command set as the mock CLI (`help`,
`scan`, `connect <index>`, `disconnect`, `rpm`, `angleh`, `anglev`,
`joystick`, `shoot`, `stop`, `state`, `quit`) — except every command
now goes out over real Bluetooth to `FlutterBluePlusService`, and
`scan` only shows devices advertising `BleConstants.robotServiceUuid`.

It calls `ensureBluetoothOn()` on startup and exits with a clear
error if the adapter isn't on or the platform has no Bluetooth radio
— fix that first before scanning.

### 0b. Windows note

`flutter_blue_plus` versions before 2.1.0 have **no** native Windows
backend. Don't use the community `flutter_blue_plus_windows` package
as a workaround — it hasn't tracked `flutter_blue_plus`'s internal API
and fails to build against current versions (`BmBluetoothCharacteristic
not found`, etc.). Instead, this package is pinned to
`flutter_blue_plus: ^2.1.0`+, which ships **official** Windows support
out of the box via the endorsed `flutter_blue_plus_winrt` plugin — no
extra dependency or import changes needed; `flutter pub get` pulls it
in automatically when targeting Windows.

### 0c. License note

`flutter_blue_plus` 2.0+ moved to the **FlutterBluePlus License**:
free for personal/nonprofit/educational use, but a **paid commercial
license is required for for-profit use**. `BluetoothDevice.connect()`
now takes a required `license:` parameter — `FlutterBluePlusService`
passes `License.nonprofit`. If this project becomes a commercial
product, revisit that (see `FlutterBluePlusService.connect()`) and
purchase a commercial license.

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

## Protocol overview

Each control action is its own BLE characteristic (see
`BleConstants`) instead of a single shared command channel:

| Function                     | Characteristic constant | Frame written (big-endian, + trailing XOR checksum byte unless noted) |
|-------------------------------|--------------------------|--------------------------------------------------------------------|
| `setRpm(int top, int bottom)`| `BleConstants.RPM`       | `[topHigh, topLow, bottomHigh, bottomLow, checksum]` (uint16 each) |
| `setAngleH(double degrees)`  | `BleConstants.Hangle`    | `[float32, checksum]`                                              |
| `setAngleV(double degrees)`  | `BleConstants.Vangle`    | `[float32, checksum]`                                              |
| `shoot()`                    | `BleConstants.Shoot`     | `[0x01]` (single trigger byte, acknowledged write)                 |
| `stop()`                     | `BleConstants.Stop`      | `[0x01]` (single trigger byte, acknowledged write)                 |
| `joystick(double x, double y)`| `BleConstants.Movement` | `[xFloat32, yFloat32, checksum]`                                   |

The robot's firmware needs to expose all six characteristics under
`BleConstants.robotServiceUuid`, decode the frames above, and
validate the trailing checksum byte (XOR of the preceding payload
bytes) the same way `MockBleService` does.

This protocol is currently **write-only** — there's no telemetry
notify characteristic, so `BleRepository.robotStateStream` only
reflects the last value *commanded* by the app, not anything read
back from the robot.

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

BLE doesn't work in an emulator/simulator — you need an actual phone
with Bluetooth, near the actual robot, powered on and advertising
(or, per step 0 above, a Bluetooth-equipped desktop running
`real_robot_cli.dart` instead of this UI):

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
3. **A slider move produces a `📡 state` update** roughly
   immediately in the app log — this confirms the write actually
   left the phone (it does NOT confirm the robot understood it,
   since there's no telemetry notify in this protocol).
4. **Shoot/Stop actually engage the motors.**

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

`FlutterBluePlusService.writeCharacteristic` sends `Shoot`/`Stop` as
acknowledged writes (`withoutResponse: false`) since they're
safety-critical, and everything else (RPM, angles, joystick)
unacknowledged for lower latency. See
`FlutterBluePlusService._criticalCharacteristics` if you want to
change which characteristics get acknowledged writes.

## I couldn't test-run this myself

This sandbox has no Flutter SDK, no physical device, and no
Bluetooth radio, so I can't compile or exercise this code before
handing it to you. Please try it against your robot and paste back
any error — especially anything from `discoverServices()` or
`setNotifyValue()`, since those are the two calls most sensitive to
exact firmware behavior.
