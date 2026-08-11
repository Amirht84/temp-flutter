# Testing our Core_Logic via simple CLI and mock_robot_ble (not real)

try running these commands in code/core directory:
    flutter pub get
    dart run test/core_test.dart

CLI commands: `scan`, `connect <index>`, `disconnect`, `rpm <top> <bottom>`,
`angleh <degrees>`, `anglev <degrees>`, `joystick <x> <y>`, `shoot`, `stop`,
`state`, `help`, `quit`.

Or run the minimal scripted example:
    dart run example/core_example.dart

For testing against real hardware over Bluetooth, see `README_REAL_TEST.md`.