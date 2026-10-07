class ScenarioHeader {
  const ScenarioHeader({
    required this.title,
    required this.duration,
    required this.shots,

  });
  final String title;
  final Duration duration;
  final int shots;
}

final scenarios = [
  ScenarioHeader(
    title: 'Warm Up',
    duration: Duration(seconds: 45, milliseconds: 320),
    shots: 24,
  ),
  ScenarioHeader(
    title: 'Forehand',
    duration: Duration(minutes: 1, seconds: 32, milliseconds: 580),
    shots: 48,
  ),
  ScenarioHeader(
    title: 'Backhand',
    duration: Duration(minutes: 2, seconds: 15, milliseconds: 120),
    shots: 72,
  ),
  ScenarioHeader(
    title: 'Cross Court',
    duration: Duration(minutes: 3, seconds: 8, milliseconds: 450),
    shots: 96,
  ),
  ScenarioHeader(
    title: 'Down The Line',
    duration: Duration(minutes: 1, seconds: 48, milliseconds: 760),
    shots: 56,
  ),
  ScenarioHeader(
    title: 'High Intensity',
    duration: Duration(minutes: 4, seconds: 22, milliseconds: 310),
    shots: 144,
  ),
  ScenarioHeader(
    title: 'Serve Practice',
    duration: Duration(minutes: 2, seconds: 5, milliseconds: 900),
    shots: 40,
  ),
  ScenarioHeader(
    title: 'Volley',
    duration: Duration(seconds: 58, milliseconds: 640),
    shots: 32,
  ),
  ScenarioHeader(
    title: 'Endurance',
    duration: Duration(minutes: 5, seconds: 17, milliseconds: 250),
    shots: 180,
  ),
  ScenarioHeader(
    title: 'Match Simulation',
    duration: Duration(minutes: 8, seconds: 43, milliseconds: 670),
    shots: 240,
  ),
];